import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mesh_frontend/grpc/grpc_channel_provider.dart';
import 'package:mesh_frontend/grpc/grpc_service.dart';
import 'package:mesh_frontend/share_link_page.dart';
import 'package:mesh_frontend/components/button.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart'; // 日付のフォーマットに使用
import 'package:shared_preferences/shared_preferences.dart';

class SetDetailsPage extends ConsumerStatefulWidget {
  final double destLon;
  final double destLat;
  final String? address;

  const SetDetailsPage({
    super.key,
    required this.destLon,
    required this.destLat,
    this.address,
  });

  @override
  ConsumerState<SetDetailsPage> createState() => _SetDetailsAndNamePageState();
}

class _SetDetailsAndNamePageState extends ConsumerState<SetDetailsPage> {
  DateTime? _selectedDateTime;
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false; // 🔹 ローディング制御用
  bool _isDateTimeError = false; // 🔹 日時未選択時のエラー表示

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
    setState(() {
      _isDateTimeError = _selectedDateTime == null; // 日時未選択ならエラー
    });
    if (!_formKey.currentState!.validate() || _selectedDateTime == null) {
      return;
    }

    setState(() {
      _isSubmitting = true; // ローディング開始
    });

    final formattedDateTime = DateFormat(
      'MM月dd日 HH:mm',
    ).format(_selectedDateTime!);
    final userName = _nameController.text.trim();

    // 匿名ログイン
    final channel = ref.read(grpcChannelProvider);
    var anonymousSignUpRes = await GrpcService.anonymousSignUp(
      channel,
      userName,
    );

    final createShareGroupRes = await GrpcService.createShareGroup(
      channel,
      widget.destLat,
      widget.destLon,
      _selectedDateTime!.toIso8601String(), // JSTのみ考慮する
      widget.address ?? "",
      anonymousSignUpRes.accessToken,
    );

    // ✅ `groupId` と `userName` をローカルに保存
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('groupId', createShareGroupRes.shareGroup.linkKey);
    await prefs.setString('userName', userName);
    await prefs.setString('accessToken', anonymousSignUpRes.accessToken);

    // ✅ `ShareLinkPage` に遷移し、戻れないようにする
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (context) => ShareLinkPage(
                shareUrl: createShareGroupRes.shareGroup.inviteUrl,
                groupId: createShareGroupRes.shareGroup.linkKey,
                location: "${widget.destLat}, ${widget.destLon}",
                time: formattedDateTime,
                userName: userName,
                address: widget.address,
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
                        errorText: _isDateTimeError ? '日時を選択してください' : null,
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
                      text: "リンクを作成する",
                      onPressed: _submitDetails,
                      fill: true,
                    ),
          ),
        ],
      ),
    );
  }
}
