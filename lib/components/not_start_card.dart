import 'package:flutter/material.dart';

class NotStartCard extends StatefulWidget {
  final String startTime;

  const NotStartCard({super.key, required this.startTime});

  @override
  State<NotStartCard> createState() => _NotStartCardState();
}

class _NotStartCardState extends State<NotStartCard> {
  var isShow = true;

  @override
  Widget build(BuildContext context) {
    if (!isShow) {
      return const SizedBox();
    }
    final startTime =
        (widget.startTime != "")
            ? DateTime.parse(widget.startTime)
            : DateTime.now();
    final formattedTime =
        '${startTime.month}/${startTime.day} ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}';

    return Card(
      color: Colors.red[50], // 薄い赤色の背景
      margin: const EdgeInsets.all(0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左側のテキスト
            Flexible(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "管理者によって、位置情報の共有は\n$formattedTime 以降に設定されています",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // 右側の閉じるボタン（ラベルなし）
            IconButton(
              onPressed: (){
                setState(() {
                  isShow = false;
                });
              },
              icon: const Icon(Icons.close, size: 20, color: Colors.redAccent),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
