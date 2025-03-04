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
  String? _selectedIconId;
  String? _selectedIconError;
  late final List<String> _iconIds;

  @override
  void initState() {
    super.initState();
    _iconIds = _getIconIds();
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _selectedIconError = _selectedIconId == null ? 'アイコンを選択してください' : null;
    });
    if (_formKey.currentState!.validate() && _selectedIconId != null) {
      final userName = _nameController.text.trim();

      final channel = ref.read(grpcChannelProvider);
      final anonymousSignUpRes = await GrpcService.anonymousSignUp(
        channel,
        userName,
        _selectedIconId!,
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
      await prefs.setInt('userId', anonymousSignUpRes.user.id.toInt());
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 30),
                const Text(
                  'アイコンを選択',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (_selectedIconError != null)
                  Text(
                    _selectedIconError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      _iconIds.map((iconId) => UserIconButton(
                    iconId: iconId,
                    isSelected: _selectedIconId == iconId,
                    onTap: () => setState(() => _selectedIconId = iconId),
                  )).toList(),
                ),
                const SizedBox(height: 20),
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

  List<String> _getIconIds() {
    final iconFiles = [
      'ahiru.jpg',
      'beetle.jpg',
      'crocodile.jpg',
      'monkey.jpg',
      'penguin.jpg',
      'pig.jpg',
      'saurus.jpg',
      'sunflower.jpg'
    ];
    return iconFiles.map((file) => file.split('.').first).toList();
  }

}

class UserIconButton extends StatelessWidget {
  final String iconId;
  final bool isSelected;
  final VoidCallback onTap;

  const UserIconButton({
    super.key,
    required this.iconId,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/user_icons/$iconId.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
