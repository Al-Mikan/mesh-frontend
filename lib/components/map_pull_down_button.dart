import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mesh_frontend/grpc/gen/server.pb.dart';
import 'package:pull_down_button/pull_down_button.dart';

class MapPullDownButton extends StatelessWidget {
  const MapPullDownButton({
    super.key,
    required this.group,
    required this.onTapExit,
  });

  final ShareGroup? group;
  final ui.VoidCallback onTapExit;

  @override
  Widget build(BuildContext context) {
    return PullDownButton(
      itemBuilder:
          (context) => [
            PullDownMenuItem(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: group!.inviteUrl),
                ).then((_) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text("招待リンクをコピーしました！"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
    
              title: '招待をコピーする',
              icon: CupertinoIcons.doc_on_clipboard,
            ),
            PullDownMenuItem(
              onTap: () {
                onTapExit();
              },
              title: 'グループから退出する',
              isDestructive: true,
              icon: CupertinoIcons.square_arrow_right,
            ),
          ],
      buttonBuilder:
          (context, openMenu) => IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: openMenu,
          ),
    );
  }
}