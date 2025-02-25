import 'package:flutter/material.dart';
import 'package:mesh_frontend/components/button.dart';
import 'package:mesh_frontend/components/meeting_details_card.dart';
import 'package:mesh_frontend/home_page.dart';
import 'package:mesh_frontend/set_name_page.dart';

class InvitedPage extends StatefulWidget {
  final String groupId;

  const InvitedPage({super.key, required this.groupId});

  @override
  State<InvitedPage> createState() => _InvitedPageState();
}

class _InvitedPageState extends State<InvitedPage> {
  @override
  void initState() {
    super.initState();
    print('InvitedPage initState');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '〇〇さんから待ち合わせの招待がきました！',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            Text('グループID: ${widget.groupId}'),
            MeetingDetailsCard(
              location: '東京タワー',
              time: '2021/12/31 18:00',
              userName: '〇〇さん',
            ),
            const SizedBox(height: 20),
            OriginalButton(
              text: "参加する",
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SetNamePage(groupId: widget.groupId, time: '2021/12/31 18:00', location: '東京タワー'), //後で変える
                  ),
                )
              },
            ),
            const SizedBox(height: 20),
            OriginalButton(
              text: "辞退する",
              fill: false,
              onPressed: () => {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HomePage()
                  ),
                  (Route<dynamic> route) => false,
                )
              },
            ),
          ],
        ),
      ),
    );
  }
}
