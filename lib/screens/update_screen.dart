import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class UpdateScreen extends StatefulWidget {
  final String docId;
  final String name;
  final String studentId;
  final String degree;

  const UpdateScreen({
    super.key,
    required this.docId,
    required this.name,
    required this.studentId,
    required this.degree,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _idController;
  late final TextEditingController _degreeController;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _idController = TextEditingController(text: widget.studentId);
    _degreeController = TextEditingController(text: widget.degree);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _degreeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await _firestoreService.updateStudent(
        widget.docId,
        _nameController.text.trim(),
        _idController.text.trim(),
        _degreeController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    }
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => controller.clear(),
        ),
      ),
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Please enter $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Student')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(label: 'Name', controller: _nameController),
              const SizedBox(height: 16),
              _buildField(label: 'Id', controller: _idController),
              const SizedBox(height: 16),
              _buildField(label: 'Degree', controller: _degreeController),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
