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

  @override
  void initState() {
    super.initState();
    debugPrint('InvitedPage initState');

    _fetchGroup();
  }

  Future<void> _fetchGroup() async {
    final channel = ref.read(grpcChannelProvider);
    final res = await GrpcService.getShareGroupByLinkKey(
      channel,
      widget.groupId,
    );
    setState(() {
      group = res.shareGroup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          group == null
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAE3E2)),
                ),
              )
              : Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${group!.adminUser.name}さんから待ち合わせの招待がきました！',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text('グループID: ${widget.groupId}'),
                    MeetingDetailsCard(
                      location: group!.address,
                      time: formatDateTime(group!.meetingTime),
                      userName: '${group!.adminUser.name}さん',
                    ),
                    const SizedBox(height: 20),
                    OriginalButton(
                      text: "参加する",
                      onPressed:
                          () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        SetNamePage(groupId: widget.groupId),
                              ),
                            ),
                          },
                    ),
                    const SizedBox(height: 20),
                    OriginalButton(
                      text: "辞退する",
                      fill: false,
                      onPressed:
                          () => {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                              (Route<dynamic> route) => false,
                            ),
                          },
                    ),
                  ],
                ),
              ),
    );
  }
}
