import 'package:flutter/material.dart';
import 'package:mesh_frontend/map_share_page.dart';
import 'package:mesh_frontend/set_location_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesh_frontend/components/button.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? groupId;

  @override
  void initState() {
    super.initState();
    checkGroupId();
  }

  void checkGroupId() async {
    // SharedPreferencesを使用してグループIDの存在を確認
    final prefs = await SharedPreferences.getInstance();
    String? savedGroupId = prefs.getString('groupId');
    debugPrint(savedGroupId);
    if (savedGroupId != null) {
      setState(() {
        groupId = savedGroupId;
      });
    }

    // 仮にnullに設定
    setState(() {
      groupId = null;
    });
  }

  // void _generateNewGroup(String newGroupId) {
  //   setState(() {
  //     groupId = newGroupId;
  //   });
  //   // SharedPreferencesにグループIDを保存
  //   SharedPreferences.getInstance().then((prefs) {
  //     prefs.setString('groupId', newGroupId);
  //   });
  //   // 地図共有画面に遷移（戻れないように）
  //   Navigator.of(context).pushAndRemoveUntil(
  //     MaterialPageRoute(
  //       builder: (context) => MapSharePage(groupId: newGroupId),
  //     ),
  //     (Route<dynamic> route) => false,
  //   );
  // }

  void _generateNewGroup() async {
    // 詳細設定画面に遷移
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => SetLocationPage()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SharedPreferences.getInstance().then(
        (prefs) => prefs.getString('groupId'),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAE3E2)),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return MapSharePage(groupId: snapshot.data!);
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    height: 200,
                    fit: BoxFit.fitHeight,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    '待ち合わせアプリ mesh',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('待ち合わせリンクを生成して共有しましょう'),
                  const SizedBox(height: 120),
                  OriginalButton(text: '始める', onPressed: _generateNewGroup),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
