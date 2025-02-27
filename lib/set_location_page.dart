import 'package:flutter/material.dart';
import 'package:mesh_frontend/set_details_page.dart';

class SetLocationPage extends StatefulWidget {
  final String groupId;

  const SetLocationPage({super.key, required this.groupId});

  @override
  State<SetLocationPage> createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _submitLocation() {
    if (_formKey.currentState!.validate()) {
      final location = _locationController.text.trim();

      // 🔽 詳細設定ページへ遷移
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) =>
                  SetDetailsPage(groupId: widget.groupId, location: location),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('場所の設定')),
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
                  hintText: '場所を入力してください',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitLocation,
                child: const Text('次へ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
