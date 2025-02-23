import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SetDetailsPage extends StatefulWidget {
  final Function(String) onGenerate;

  const SetDetailsPage({super.key, required this.onGenerate});

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
      // UUIDを生成
      final uuid = Uuid();
      final groupId = uuid.v4();
      widget.onGenerate(groupId);
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
                  labelText: '場所',
                  hintText: '待ち合わせ場所を入力',
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
                  labelText: '時間',
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
              ElevatedButton(onPressed: _submit, child: const Text('リンクを生成')),
            ],
          ),
        ),
      ),
    );
  }
}
