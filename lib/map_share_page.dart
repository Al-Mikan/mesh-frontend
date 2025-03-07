import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:mesh_frontend/all_gathered_page.dart';
import 'package:mesh_frontend/components/custom_goal_pin.dart';
import 'package:mesh_frontend/components/map_bottom_card.dart';
import 'package:mesh_frontend/components/map_top_address_card.dart';
import 'package:mesh_frontend/components/not_start_card.dart';
import 'package:mesh_frontend/grpc/gen/server.pb.dart';
import 'package:mesh_frontend/grpc/grpc_channel_provider.dart';
import 'package:mesh_frontend/grpc/grpc_service.dart';
import 'package:mesh_frontend/home_page.dart';
import 'package:mesh_frontend/utils/googlemaps_direction.dart';
import 'package:mesh_frontend/utils/location_service.dart';
import 'package:mesh_frontend/utils/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesh_frontend/components/custom_user_pin.dart';
import 'package:mesh_frontend/components/arrival_confirmation_card.dart';

//https://www.cloudbuilders.jp/articles/4214/
class MapSharePage extends ConsumerStatefulWidget {
  final String groupId;

  const MapSharePage({super.key, required this.groupId});

  @override
  ConsumerState<MapSharePage> createState() => _MapSharePageState();
}

class _MapSharePageState extends ConsumerState<MapSharePage> {
  late GoogleMapController mapController;
  StreamSubscription<GetCurrentShareGroupResponse>? _groupStreamSubscription;
  LocationDto? _currentLocation;
  final location = Location();
  static const String isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool hasArrived = false; // 到着済みかどうかのフラグ
  ShareGroup? group;
  String? accessToken;
  int? userId;

  // timer
  Timer? fetchTimer;
  Timer? countdownTimer;
  String remainingTimeText = "計算中..."; // 初期値

  //経路の時間
  late GoogleMapsDirections directionsService;
  TravelTime? travelTime;
  bool isFetchedDirections = false;

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
    _initializeServices();
    _startCountdownTimer();
  }

  Future<void> _loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    userId = prefs.getInt('userId');
    const apiKay = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
    directionsService = GoogleMapsDirections(apiKey: apiKay);
    _setupGroupStream();
  }

  // ストリームのセットアップ
  void _setupGroupStream() async {
    if (accessToken == null) return;

    final channel = ref.read(grpcChannelProvider);
    try {
      final stream = GrpcService.getCurrentShareGroupStream(
        channel,
        accessToken!,
      );
      _groupStreamSubscription = stream.listen(
        (response) {
          if (mounted) {
            setState(() {
              group = response.shareGroup;
            });
            if (_currentLocation != null && travelTime == null) {
              _calculateTravlTimesAndSetNotification();
            }
            _setCustomMarkers();
            _fetchCurrentUser();
            if (_checkAllArrived()) {
              _removeAuthenticationState();
              _navigateToAllGatheredPage();
            }
          }
        },
        onError: (error) {
          debugPrint("グループストリームエラー: $error");
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint("ストリーム接続エラー: $e");
    }
  }

  //getCurrentUserを呼び出す
  Future<void> _fetchCurrentUser() async {
    if (accessToken == null) return;

    final channel = ref.read(grpcChannelProvider);
    final res = await GrpcService.getCurrentUser(channel, accessToken!);

    if (mounted) {
      final userJson = res.user.toProto3Json() as Map<String, dynamic>?;

      setState(() {
        hasArrived =
            userJson != null &&
            userJson.containsKey('isArrived') &&
            res.user.isArrived;
      });
    }
  }

  void _navigateToAllGatheredPage() {
    if (!mounted) return; // Widgetが破棄されていたら処理しない

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AllGatheredPage()),
      (Route<dynamic> route) => false, // すべての前の画面を削除
    );
  }

  void _startCountdownTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (group == null || group!.meetingTime.isEmpty) {
        setState(() {
          remainingTimeText = "未設定";
        });
        return;
      }

      DateTime meetingTime =
          DateTime.parse(group!.meetingTime).toLocal(); // 文字列からDateTimeに変換
      Duration difference = meetingTime.difference(DateTime.now());

      if (difference.isNegative) {
        setState(() {
          remainingTimeText = "集合時間を過ぎました";
          countdownTimer?.cancel(); // タイマー停止
        });
      } else {
        int days = difference.inDays;
        int hours = difference.inHours % 24;
        int minutes = difference.inMinutes % 60;
        int seconds = difference.inSeconds % 60;

        String timeText = "集合まで残り ";
        if (days > 0) {
          timeText += "$days日";
        }
        if (hours > 0) {
          timeText += "$hours時間";
        }
        if (minutes > 0) {
          timeText += "$minutes分";
        }
        timeText += "$seconds秒";

        setState(() {
          remainingTimeText = timeText;
        });
      }
    });
  }

  // 集合場所と現在地との移動時間を計算
  Future<void> _calculateTravlTimesAndSetNotification() async {
    if (_currentLocation == null || group == null) return;

    final times = await directionsService.getTravelTimes(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      group!.destLat,
      group!.destLon,
    );

    if (mounted) {
      setState(() {
        travelTime = times;
      });
    }

    // 通知を設定
    final meetingTime = DateTime.parse(group!.meetingTime).toLocal();
    final walkingTime = meetingTime.subtract(Duration(minutes: times.walking!));
    final bicyclingTime = meetingTime.subtract(
      Duration(minutes: times.bicycling!),
    );
    final drivingTime = meetingTime.subtract(Duration(minutes: times.driving!));
    NotificationService().create(AppNotificationType.meeting, meetingTime);
    NotificationService().create(AppNotificationType.walkingStart, walkingTime);
    NotificationService().create(
      AppNotificationType.bicyclingStart,
      bicyclingTime,
    );
    NotificationService().create(AppNotificationType.drivingStart, drivingTime);
  }

  Future<void> _initializeServices() async {
    await _requestLocationPermission();
    await _initializeLocationService();
    LocationCallbackHandler.startLocationService();
  }

  Future<void> _initializeLocationService() async {
    IsolateNameServer.registerPortWithName(port.sendPort, isolateName);
    port.listen((dynamic data) async {
      // debugPrint("received location: $data");
      if (data != null) {
        setState(() {
          _currentLocation = LocationDto.fromJson(data);
        });
        if (group != null && travelTime == null) {
          await _calculateTravlTimesAndSetNotification();
        }

        if (accessToken != null) {
          final channel = ref.read(grpcChannelProvider);
          final res = await GrpcService.updatePosition(
            channel,
            _currentLocation!.latitude,
            _currentLocation!.longitude,
            accessToken!,
          );
        }
      }
    });
    await initPlatformState();
  }

  Future<void> _requestLocationPermission() async {
    await RequestLocationPermission.request(location);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onTapExit(BuildContext context) async {
    final bool? result = await showGeneralDialog<bool>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return CupertinoAlertDialog(
          title: const Text('確認'),
          content: const Text('本当にグループから退出しますか？'),
          actions: [
            CupertinoDialogAction(
              child: const Text('いいえ', style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(false), // キャンセル
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('はい'),
              onPressed: () => Navigator.of(context).pop(true), // OK
            ),
          ],
        );
      },
    );

    // 「はい」を選択した場合のみ退出処理を実行
    if (result == true) {
      IsolateNameServer.removePortNameMapping(isolateName);
      BackgroundLocator.unRegisterLocationUpdate();

      if (context.mounted) {
        await _removeAuthenticationState();
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false, // すべての前のルートを削除
        );
      }
    }
  }

  void _setCustomMarkers() async {
    if (group == null) return;

    Set<Marker> markers = {};
    Set<Polyline> polylines = {};

    for (var user in group!.users) {
      if (!user.hasLat() || !user.hasLon()) continue;

      final BitmapDescriptor icon = await CustomUserPin.createCustomMarker(
        user.name,
        user.iconID,
        user.shortMessage,
      );
      final lineWidth = (user.id == userId) ? 5 : 5;
      final lineColor = (user.id == userId) ? Colors.orange : Colors.black12;
      final linePattern =
          (user.id == userId)
              ? <PatternItem>[PatternItem.dash(70), PatternItem.gap(30)]
              : <PatternItem>[PatternItem.dash(50), PatternItem.gap(50)];

      markers.add(
        Marker(
          markerId: MarkerId(user.name),
          position: LatLng(user.lat, user.lon),
          icon: icon,
          infoWindow: InfoWindow(title: user.name),
          zIndex: 1,
          anchor: const Offset(0.5, 0.5),
        ),
      );

      // 曲線の制御点を計算
      final points = _calculateBezierCurve(
        LatLng(user.lat, user.lon),
        LatLng(group!.destLat, group!.destLon),
      );

      // ユーザーと目的地の距離が1000km以上なら線を描画しない
      final distance = _calculateDistance(
        user.lat,
        user.lon,
        group!.destLat,
        group!.destLon,
      );
      if (distance > 1000000) continue; // 1000km = 1,000,000m

      polylines.add(
        Polyline(
          polylineId: PolylineId('${user.name}_route'),
          points: points,
          color: lineColor,
          width: lineWidth,
          geodesic: true, // 地球の曲率を考慮
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          patterns: linePattern,
        ),
      );
    }

    final BitmapDescriptor goalIcon = await CustomGoalPin.createGoalMarker();

    markers.add(
      Marker(
        markerId: const MarkerId("goal"),
        position: LatLng(group!.destLat, group!.destLon),
        icon: goalIcon,
        infoWindow: const InfoWindow(title: "待ち合わせ場所"),
        zIndex: 2,
        anchor: const Offset(0.5, 0.5),
      ),
    );

    if (mounted) {
      setState(() {
        _markers = markers;
        _polylines = polylines;
      });
    }
  }

  /// 目的地との距離を計算
  bool _isNearMeetingPoint() {
    if (_currentLocation == null) return false;
    if (group == null) return false;

    double distance = _calculateDistance(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      group!.destLat,
      group!.destLon,
    );

    return distance < 200; // 200メートル以内なら到着とみなす
  }

  /// Haversine Formula で距離を計算
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double radius = 6371000; // 地球の半径 (メートル)
    double dLat = (lat2 - lat1) * (3.141592653589793 / 180);
    double dLon = (lon2 - lon1) * (3.141592653589793 / 180);
    double a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(lat1 * (3.141592653589793 / 180)) *
            cos(lat2 * (3.141592653589793 / 180)) *
            (sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  /// 「到着」ボタンが押されたとき
  void _onArrived() async {
    if (accessToken == null) return; // 認証情報がない場合は処理しない

    final channel = ref.read(grpcChannelProvider);

    try {
      // 🔹 サーバーに到着情報を送信
      await GrpcService.arriveDest(channel, accessToken!);
    } catch (e) {
      debugPrint("到着処理エラー: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("到着情報の更新に失敗しました"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// 参加者全員が到着したかをチェック
  bool _checkAllArrived() {
    if (group == null || group!.users.isEmpty) {
      return false;
    }
    return group!.users.every((user) => user.isArrived);
  }

  Future<void> _removeAuthenticationState() async {
    final channel = ref.read(grpcChannelProvider);
    await GrpcService.leaveShareGroup(channel, accessToken!);
    await _removePrefStateAndNotification();
  }

  Future<void> _removePrefStateAndNotification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('groupId');
    await prefs.remove('accessToken');
    NotificationService().deleteAll();
  }

  @override
  void dispose() {
    _groupStreamSubscription?.cancel();
    countdownTimer?.cancel();
    IsolateNameServer.removePortNameMapping(isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
    port.close();
    fetchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null || group == null) {
      return Scaffold(
        body: Stack(
          children: [
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAE3E2)),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    await _removePrefStateAndNotification();
                    if (context.mounted) {
                      await Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (Route<dynamic> route) => false, // すべての前のルートを削除
                      );
                    }
                  },
                  child: const Text(
                    '退出してホームに戻る',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final cameraPosition = CameraPosition(
      target: LatLng(
        _currentLocation!.latitude - 0.01,
        _currentLocation!.longitude,
      ),
      zoom: 14.0,
    );

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: onMapCreated,
            initialCameraPosition: cameraPosition,
            myLocationButtonEnabled: false,
            markers: _markers.toSet(),
            polylines: _polylines,
          ),
          if (!hasArrived && _isNearMeetingPoint()) // 近くにいるかつ未到着なら表示
            Positioned(
              top: 130,
              left: 12,
              right: 12,
              child: ArrivalConfirmationCard(onArrived: _onArrived),
            ),
          if (!(group?.isSharingLocation ?? true))
            Positioned(
              top: 140,
              left: 12,
              right: 12,
              child: NotStartCard(
                startTime: group?.sharingLocationStartTime ?? "",
              ),
            ),
          if (group != null)
            TopAddressCard(
              address: group!.address,
              lat: group!.destLat,
              lon: group!.destLon,
            ),
          Positioned(
            bottom: 30,
            left: 12,
            right: 12,
            child: MapBottomCard(
              group: group,
              remainingTimeText: remainingTimeText,
              travelTime: travelTime,
              currentLocation: _currentLocation,
              onTapExit: () => onTapExit(context),
              onTapFocusMe: onTapFocusMe,
              onTapFocusRoute: onTapFocusRoute,
              onSubmitMessage: onSubmitMessage,
            ),
          ),
        ],
      ),
    );
  }

  // フォーカスボタンが押されたときの処理
  void onTapFocusMe() {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(_currentLocation!.latitude - 0.01, _currentLocation!.longitude),
        14.0,
      ),
    );
  }

  void onTapFocusRoute() {
    if (_currentLocation == null || group == null) return;
    final latDiff = _currentLocation!.latitude - group!.destLat;
    final northOffset = latDiff.abs() * 0.3;
    final southOffset = latDiff.abs() * 1.2;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        min(_currentLocation!.latitude, group!.destLat) - southOffset,
        min(_currentLocation!.longitude, group!.destLon),
      ),
      northeast: LatLng(
        max(_currentLocation!.latitude, group!.destLat) + northOffset,
        max(_currentLocation!.longitude, group!.destLon),
      ),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  // メッセージを送信したときの処理
  void onSubmitMessage(String message) async {
    if (accessToken == null) return;

    final channel = ref.read(grpcChannelProvider);
    await GrpcService.updateShortMessage(channel, message, accessToken!);
  }

  List<LatLng> _calculateBezierCurve(LatLng start, LatLng end) {
    // 中間地点
    double midLat = (start.latitude + end.latitude) / 2;
    double midLng = (start.longitude + end.longitude) / 2;
    double latDiff = (start.latitude - end.latitude).abs();
    double lngDiff = (start.longitude - end.longitude).abs();
    LatLng controlPoint1 = LatLng(midLat, start.longitude);
    LatLng controlPoint2 = LatLng(midLat, end.longitude);
    if (latDiff < lngDiff) {
      controlPoint1 = LatLng(start.latitude, midLng);
      controlPoint2 = LatLng(end.latitude, midLng);
    }

    // ベジェ曲線を補間
    List<LatLng> bezierPoints = [];
    for (double t = 0; t <= 1; t += 0.1) {
      double lat =
          (1 - t) * (1 - t) * (1 - t) * start.latitude +
          3 * (1 - t) * (1 - t) * t * controlPoint1.latitude +
          3 * (1 - t) * t * t * controlPoint2.latitude +
          t * t * t * end.latitude;

      double lng =
          (1 - t) * (1 - t) * (1 - t) * start.longitude +
          3 * (1 - t) * (1 - t) * t * controlPoint1.longitude +
          3 * (1 - t) * t * t * controlPoint2.longitude +
          t * t * t * end.longitude;

      bezierPoints.add(LatLng(lat, lng));
    }

    return bezierPoints;
  }
}
