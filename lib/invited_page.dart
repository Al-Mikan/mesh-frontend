import 'package:flutter/material.dart';
import 'package:mesh_frontend/map_share_page.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('グループID: ${widget.groupId}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MapSharePage(groupId: widget.groupId),
                  ),
                );
              },
              child: const Text('参加する'),
            ),
          ],
        ),
      ),
    );
  }
}