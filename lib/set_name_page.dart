import 'package:flutter/material.dart';
import 'package:mesh_frontend/share_link_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesh_frontend/components/button.dart'; // ✅ `OriginalButton` を使用

class SetNamePage extends StatefulWidget {
  final String groupId;
  final String location;
  final String time;

  const SetNamePage({
    super.key,
    required this.groupId,
    required this.location,
    required this.time,
  });

  @override
  State<SetNamePage> createState() => _SetNamePageState();
}

class _SetNamePageState extends State<SetNamePage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final userName = _nameController.text.trim();

      // ✅ `groupId` と `userName` をローカルに保存
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('groupId', widget.groupId);
      await prefs.setString('userName', userName);

      final shareUrl = 'https://example.com/share/123456'; // 仮のURL

      // ✅ `ShareLinkPage` に遷移し、戻れないようにする
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (context) => ShareLinkPage(
                shareUrl: shareUrl,
                groupId: widget.groupId,
                location: widget.location,
                time: widget.time,
                userName: userName,
              ),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ ボタンを横幅いっぱいに
          children: <Widget>[
            const Text(
              'あなたの名前を入力してください',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                autofocus: true, // ✅ 自動でフォーカスする
                decoration: InputDecoration(
                  labelText: '名前を入力',
                  hintText: '例: たかし',
                  prefixIcon: const Icon(Icons.person), // ✅ アイコンを追加
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // ✅ 角丸
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
            const SizedBox(height: 40),
            OriginalButton(text: '次へ', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
