import 'package:flutter/material.dart';
import 'package:mesh_frontend/set_name_page.dart';
import 'package:mesh_frontend/components/button.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart'; // 日付のフォーマットに使用

class SetDetailsPage extends StatefulWidget {
  final String groupId;
  final String location;

  const SetDetailsPage({
    super.key,
    required this.groupId,
    required this.location,
  });

  @override
  State<SetDetailsPage> createState() => _SetDetailsPageState();
}

class _SetDetailsPageState extends State<SetDetailsPage> {
  DateTime? _selectedDateTime;

  /// 日時ピッカー
  void _pickDateTime() {
    picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true, // 上部に「完了」「キャンセル」などのボタンを表示
      minTime: DateTime.now(), // 最小日付を今日に設定
      maxTime: DateTime.now().add(const Duration(days: 365)), // 最大を1年先に
      locale: picker.LocaleType.jp, // 日本語ロケール
      onChanged: (date) {},
      onConfirm: (date) {
        setState(() {
          _selectedDateTime = date;
        });
      },
      currentTime: DateTime.now(),
    );
  }

  /// 「次へ」ボタンを押したとき
  void _submitDetails() {
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('日時を選択してください')));
      return;
    }

    // 🔸 yyyy年MM月dd日 HH:mm 形式にフォーマット
    final formattedDateTime = DateFormat(
      'MM月dd日 HH:mm',
    ).format(_selectedDateTime!);

    // 🔽 名前入力ページへ遷移
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => SetNamePage(
              groupId: widget.groupId,
              location: widget.location,
              time: formattedDateTime,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔸 TextFormField の表示用 (日時を文字列に変換)
    final displayText =
        _selectedDateTime == null
            ? '日付と時間を選択してください'
            : DateFormat('MM月dd日 HH:mm').format(_selectedDateTime!);

    return Scaffold(
      appBar: AppBar(title: const Text('詳細設定')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '選択された場所: ${widget.location}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🔸 flutter_datetime_picker_plus を使う
            GestureDetector(
              onTap: _pickDateTime,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: '待ち合わせ日時',
                    hintText: '日付と時間を選択',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(text: displayText),
                ),
              ),
            ),

            const SizedBox(height: 30),

            OriginalButton(
              text: "次へ",
              onPressed: _submitDetails,
              fill: true, // 背景色あり
            ),
          ],
        ),
      ),
    );
  }
}
