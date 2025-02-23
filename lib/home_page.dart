
import 'package:flutter/material.dart';
import 'package:mesh_frontend/map_share_page.dart';
import 'package:mesh_frontend/set_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void _generateNewGroup(String newGroupId) {
    setState(() {
      groupId = newGroupId;
    });
    // SharedPreferencesにグループIDを保存
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('groupId', newGroupId);
    });
    // 地図共有画面に遷移（戻れないようにpushReplacement）
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MapSharePage(groupId: newGroupId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SharedPreferences.getInstance().then(
        (prefs) => prefs.getString('groupId'),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          return MapSharePage(groupId: snapshot.data!);
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('ホーム')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('まちあわせリンクを生成して共有しましょう'),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SetDetailsPage(onGenerate: _generateNewGroup),
                        ),
                      );
                    },
                    child: const Text('リンクを生成'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
