import 'package:flutter/material.dart';
import 'package:mesh_frontend/set_name_page.dart';

class SetDetailsPage extends StatefulWidget {
  final String groupId;

  const SetDetailsPage({super.key, required this.groupId});

  @override
  State<SetDetailsPage> createState() => _SetDetailsPageState();
}

class _SetDetailsPageState extends State<SetDetailsPage> {
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _locationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final location = _locationController.text.trim();
      final time = _timeController.text.trim();

      // 名前入力画面へ遷移
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => SetNamePage(
                groupId: widget.groupId,
                location: location,
                time: time,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('詳細設定')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: '場所(後で地図から選択する方式に変更)',
                  hintText: '場所を入力',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '場所を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: '時間(後でPickerに変更)',
                  hintText: '待ち合わせ時間を入力',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '時間を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('次へ')),
            ],
          ),
        ),
      ),
    );
  }
}
