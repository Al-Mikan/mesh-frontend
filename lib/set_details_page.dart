import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mesh_frontend/components/button.dart';
import 'package:mesh_frontend/grpc/grpc_channel_provider.dart';
import 'package:mesh_frontend/grpc/grpc_service.dart';
import 'package:mesh_frontend/set_name_page.dart';
import 'package:mesh_frontend/share_link_page.dart';
import 'package:mesh_frontend/utils/format_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetDetailsPage extends ConsumerStatefulWidget {
  final double destLon;
  final double destLat;
  final String? address;

  const SetDetailsPage({
    super.key,
    required this.destLon,
    required this.destLat,
    this.address,
  });

  @override
  ConsumerState<SetDetailsPage> createState() => _SetDetailsAndNamePageState();
}

class DropdownItem {
  final String value;
  final String text;

  const DropdownItem({required this.value, required this.text});
}

class _SetDetailsAndNamePageState extends ConsumerState<SetDetailsPage> {
  DateTime? _sharingLocationStartTime;
  DateTime? _selectedDateTime;
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false; // ローディング制御用
  bool _isDateTimeError = false; // 日時未選択時のエラー表示
  bool _isStartTimeFormatError = false; // 共有開始日時未選択時のエラー表示
  String? _selectedIconId;
  String? _selectedIconError;
  late final List<String> _iconIds;
  String? _selectedStartFormat;
  Duration? _selectedDuration;
  final List<DropdownItem> _startFormatItems = [
    DropdownItem(value: 'now', text: '今から'),
    DropdownItem(value: '2h', text: '2時間前から'),
    DropdownItem(value: '1h', text: '1時間前から'),
    DropdownItem(value: '30min', text: '30分前から'),
    DropdownItem(value: 'custom', text: 'カスタム'),
  ];

  @override
  void initState() {
    super.initState();
    _iconIds = _getIconIds();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// 📌 日時ピッカー
  void _pickDateTime(void Function(DateTime) setDate) {
    picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true, // 上部に「完了」「キャンセル」などのボタンを表示
      minTime: DateTime.now(), // 最小日付を今日に設定
      maxTime: DateTime.now().add(const Duration(days: 365)), // 最大を1年先に
      locale: picker.LocaleType.jp, // 日本語ロケール
      onChanged: (date) {},
      onConfirm: (date) {
        setDate(date);
      },
      currentTime: DateTime.now(),
    );
  }

  /// 📌 時間間隔ピッカー
  void _pickTimeDuration(
    Duration? defaultDuration,
    void Function(Duration) setDate,
  ) {
    picker.DatePicker.showTimePicker(
      context,
      showSecondsColumn: false, // 秒を非表示
      showTitleActions: true, // 上部に「完了」「キャンセル」などのボタンを表示
      locale: picker.LocaleType.jp, // 日本語ロケール
      onChanged: (date) {
        setDate(Duration(hours: date.hour, minutes: date.minute));
      },
      onConfirm: (date) {
        setDate(Duration(hours: date.hour, minutes: date.minute));
      },
      currentTime: DateTime(0).add(defaultDuration ?? Duration.zero),
    );
  }

  /// 📌 「次へ」ボタンを押したとき
  void _submitDetails() async {
    // すべてのバリデーションをまとめて実行
    setState(() {
      _isDateTimeError = _selectedDateTime == null;
      _isStartTimeFormatError = _selectedStartFormat == null;
      _selectedIconError = _selectedIconId == null ? 'アイコンを選択してください' : null;
    });

    // バリデーションエラーがある場合は処理を中断
    if (!_formKey.currentState!.validate() ||
        _selectedDateTime == null ||
        _selectedIconId == null) {
      return;
    }

    setState(() {
      _isSubmitting = true; // ローディング開始
    });

    final formattedDateTime = formatDateTime(_selectedDateTime!);
    final userName = _nameController.text.trim();

    // 匿名ログイン
    final channel = ref.read(grpcChannelProvider);
    var anonymousSignUpRes = await GrpcService.anonymousSignUp(
      channel,
      userName,
      _selectedIconId!,
    );

    switch (_selectedStartFormat) {
      case 'now':
        _sharingLocationStartTime = DateTime.now();
        break;
      default:
        _sharingLocationStartTime = _selectedDateTime!.subtract(
          _selectedDuration!,
        );
    }

    final createShareGroupRes = await GrpcService.createShareGroup(
      channel,
      widget.destLat,
      widget.destLon,
      _sharingLocationStartTime!
          .toUtc()
          .toIso8601String(), // Zをつけないとバックエンドがクラッシュする
      _selectedDateTime!.toUtc().toIso8601String(), // Zをつけないとバックエンドがクラッシュする
      widget.address ?? "",
      anonymousSignUpRes.accessToken,
    );

    // ✅ `groupId` と `userName` をローカルに保存
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('groupId', createShareGroupRes.shareGroup.linkKey);
    await prefs.setString('userName', userName);
    await prefs.setString('accessToken', anonymousSignUpRes.accessToken);
    await prefs.setInt('userId', anonymousSignUpRes.user.id.toInt());

    // ✅ `ShareLinkPage` に遷移し、戻れないようにする
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (context) => ShareLinkPage(
                shareUrl: createShareGroupRes.shareGroup.inviteUrl,
                groupId: createShareGroupRes.shareGroup.linkKey,
                location: "${widget.destLat}, ${widget.destLon}",
                time: formattedDateTime,
                userName: userName,
                address: widget.address,
              ),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDateTime =
        _selectedDateTime == null
            ? '日付と時間を選択してください'
            : formatDateTime(_selectedDateTime!);
    final displayDuration =
        _selectedDuration == null
            ? '位置共有開始時間を選択してください'
            : formatDuration(_selectedDuration!);

    return Scaffold(
      appBar: CupertinoNavigationBar(middle: const Text('詳細設定')),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            // 📌 メインのコンテンツ
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // 🔹 待ち合わせ日時選択フィールド
                    GestureDetector(
                      onTap: () {
                        _pickDateTime((date) {
                          setState(() {
                            _selectedDateTime = date;
                          });
                        });
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '待ち合わせ日時',
                            hintText: '日付と時間を選択',
                            suffixIcon: const Icon(Icons.calendar_today),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 28,
                            ),
                            errorText: _isDateTimeError ? '日時を選択してください' : null,
                          ),
                          controller: TextEditingController(
                            text: displayDateTime,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: '位置共有開始',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _isStartTimeFormatError ? '選択してください' : null,
                      ),
                      items:
                          _startFormatItems.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.value,
                              child: Text(
                                item.text,
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStartFormat = value;
                          if (value == "2h") {
                            _selectedDuration = const Duration(hours: 2);
                          } else if (value == "1h") {
                            _selectedDuration = const Duration(hours: 1);
                          } else if (value == "30min") {
                            _selectedDuration = const Duration(minutes: 30);
                          } else {
                            _selectedDuration = const Duration(hours: 2);
                          }
                        });
                      },
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (_selectedStartFormat == 'custom')
                      // 🔹 共有開始日時選択フィールド
                      GestureDetector(
                        onTap: () {
                          _pickTimeDuration(_selectedDuration, (date) {
                            setState(() {
                              _selectedDuration = date;
                            });
                          });
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: '共有開始をカスタム',
                              hintText: '日付と時間を選択',
                              suffixIcon: const Icon(Icons.calendar_today),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 28,
                              ),
                            ),
                            controller: TextEditingController(
                              text: displayDuration,
                            ),
                          ),
                        ),
                      ),
                    if (_selectedStartFormat == 'custom')
                      const SizedBox(height: 24),

                    // 🔹 名前入力フォーム
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'あなたの名前を入力',
                          hintText: '例: たかし',
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '名前を入力してください';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'アイコンを選択',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (_selectedIconError != null)
                      Text(
                        _selectedIconError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          _iconIds
                              .map(
                                (iconId) => UserIconButton(
                                  iconId: iconId,
                                  isSelected: _selectedIconId == iconId,
                                  onTap:
                                      () => setState(
                                        () => _selectedIconId = iconId,
                                      ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 80),
                    _isSubmitting
                        ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFFAE3E2),
                            ),
                          ),
                        )
                        : OriginalButton(
                          text: "リンクを作成する",
                          onPressed: _submitDetails,
                          fill: true,
                        ),
                  ],
                ),
              ),
            ),

            // 📌 「次へ」ボタンを `Positioned` で調整
          ],
        ),
      ),
    );
  }

  List<String> _getIconIds() {
    final iconFiles = [
      'azarashi.jpg',
      'bear.jpg',
      'bird.jpg',
      'cat.jpg',
      'chicken.jpg',
      'cow.jpg',
      'deer.jpg',
      'elephant.jpg',
      'fox.jpg',
      'lion.jpg',
      'monkey.jpg',
      'panda.jpg',
    ];
    return iconFiles.map((file) => file.split('.').first).toList();
  }
}
