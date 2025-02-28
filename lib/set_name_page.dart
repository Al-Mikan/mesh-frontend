import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mesh_frontend/grpc/grpc_channel_provider.dart';
import 'package:mesh_frontend/grpc/grpc_service.dart';
import 'package:mesh_frontend/map_share_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesh_frontend/components/button.dart'; // ✅ `OriginalButton` を使用

class SetNamePage extends ConsumerStatefulWidget {
  final String groupId;

  const SetNamePage({super.key, required this.groupId});

  @override
  ConsumerState<SetNamePage> createState() => _SetNamePageState();
}

class _SetNamePageState extends ConsumerState<SetNamePage> {
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

      final channel = ref.read(grpcChannelProvider);
      final anonymousSignUpRes = await GrpcService.anonymousSignUp(
        channel,
        userName,
      );
      final joinShareGroupRes = await GrpcService.joinShareGroupRequest(
        channel,
        widget.groupId,
        anonymousSignUpRes.accessToken,
      );

      // ✅ `groupId` と `userName` をローカルに保存
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('groupId', widget.groupId);
      await prefs.setString('userName', userName);
      await prefs.setString('accessToken', anonymousSignUpRes.accessToken);

      // ✅ `MapSharePage` に遷移し、戻れないようにする
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MapSharePage(groupId: widget.groupId),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Spacer(), // ✅ 上部のスペースを確保し、フォームを中央寄せ
            Column(
              children: [
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
              ],
            ),
            const Spacer(), // ✅ 下部のスペースを確保
            Padding(
              padding: const EdgeInsets.only(bottom: 80), // ✅ ボタンの位置を下から80pxに設定
              child: OriginalButton(text: '次へ', onPressed: _submit),
            ),
          ],
        ),
      ),
    );
  }
}
