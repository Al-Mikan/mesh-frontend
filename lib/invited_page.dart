import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mesh_frontend/components/button.dart';
import 'package:mesh_frontend/components/meeting_details_card.dart';
import 'package:mesh_frontend/grpc/gen/server.pb.dart';
import 'package:mesh_frontend/grpc/grpc_channel_provider.dart';
import 'package:mesh_frontend/grpc/grpc_service.dart';
import 'package:mesh_frontend/home_page.dart';
import 'package:mesh_frontend/set_name_page.dart';
import 'package:mesh_frontend/utils/format_date.dart';

class InvitedPage extends ConsumerStatefulWidget {
  final String groupId;

  const InvitedPage({super.key, required this.groupId});

  @override
  ConsumerState<InvitedPage> createState() => _InvitedPageState();
}

class _InvitedPageState extends ConsumerState<InvitedPage> {
  ShareGroup? group;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    debugPrint('InvitedPage initState');

    // 非同期処理を microtask に追加して ref.read を安全に呼び出す
    Future.microtask(() => _fetchGroup());
  }

  Future<void> _fetchGroup() async {
    try {
      final channel = ref.read(grpcChannelProvider);
      final res = await GrpcService.getShareGroupByLinkKey(
        channel,
        widget.groupId,
      );
      setState(() {
        group = res.shareGroup;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'グループ情報の取得に失敗しました';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            isLoading
                ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAE3E2)),
                )
                : errorMessage != null
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${group?.adminUser.name ?? "管理者"}さんから待ち合わせの招待がきました！',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            MeetingDetailsCard(
                              location: group?.address ?? "不明",
                              time:
                                  group != null
                                      ? formatDateTime(group!.meetingTime)
                                      : "未定",
                              userName: '${group?.adminUser.name ?? "管理者"}さん',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Column(
                          children: [
                            OriginalButton(
                              text: "参加する",
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SetNamePage(
                                          groupId: widget.groupId,
                                        ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            OriginalButton(
                              text: "辞退する",
                              fill: false,
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
