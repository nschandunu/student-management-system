import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _degreeController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _degreeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await _firestoreService.addStudent(
        _nameController.text.trim(),
        _idController.text.trim(),
        _degreeController.text.trim(),
      );
      _nameController.clear();
      _idController.clear();
      _degreeController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student added successfully')),
        );
      }
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
      appBar: AppBar(title: const Text('Add Student')),
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
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
