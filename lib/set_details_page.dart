import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mesh_frontend/share_link_page.dart';
import 'package:mesh_frontend/components/button.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart'; // 日付のフォーマットに使用
import 'package:shared_preferences/shared_preferences.dart';

class SetDetailsPage extends StatefulWidget {
  final String groupId;
  final String location;

  const SetDetailsPage({
    super.key,
    required this.groupId,
    required this.location,
  });

  @override
  State<SetDetailsPage> createState() => _SetDetailsAndNamePageState();
}

class _SetDetailsAndNamePageState extends State<SetDetailsPage> {
  DateTime? _selectedDateTime;
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false; // 🔹 ローディング制御用

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// 📌 日時ピッカー
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

  /// 📌 「次へ」ボタンを押したとき
  void _submitDetails() async {
    if (!_formKey.currentState!.validate() || _selectedDateTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('日時と名前を入力してください')));
      return;
    }

    setState(() {
      _isSubmitting = true; // 🔹 ローディング開始
    });

    final formattedDateTime = DateFormat(
      'MM月dd日 HH:mm',
    ).format(_selectedDateTime!);
    final userName = _nameController.text.trim();

    // ✅ `groupId` と `userName` をローカルに保存
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('groupId', widget.groupId);
    await prefs.setString('userName', userName);

    final shareUrl = 'https://example.com/share/123456'; // 仮のURL

    // ✅ `ShareLinkPage` に遷移し、戻れないようにする
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (context) => ShareLinkPage(
                shareUrl: shareUrl,
                groupId: widget.groupId,
                location: widget.location,
                time: formattedDateTime,
                userName: userName,
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
            : DateFormat('MM月dd日 HH:mm').format(_selectedDateTime!);

    return Scaffold(
      appBar: CupertinoNavigationBar(middle: const Text('詳細設定')),
      body: Stack(
        children: [
          // 📌 メインのコンテンツ
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // 🔹 日時選択フィールド
                GestureDetector(
                  onTap: _pickDateTime,
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
                      ),
                      controller: TextEditingController(text: displayDateTime),
                    ),
                  ),
                ),
                const SizedBox(height: 42),

                // 🔹 名前入力フォーム
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '名前を入力',
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
                const SizedBox(height: 30),
              ],
            ),
          ),

          // 📌 「次へ」ボタンを `Positioned` で調整
          Positioned(
            bottom: 80, // 🔹 画面下から少し上に配置
            left: 24,
            right: 24,
            child:
                _isSubmitting
                    ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFAE3E2),
                        ),
                      ),
                    )
                    : OriginalButton(
                      text: "次へ",
                      onPressed: _submitDetails,
                      fill: true,
                    ),
          ),
        ],
      ),
    );
  }
}
