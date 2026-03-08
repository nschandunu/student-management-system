import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class UpdateScreen extends StatefulWidget {
  final String docId;
  final String name;
  final String studentId;
  final String email;
  final String course;
  final String age;

  const UpdateScreen({
    super.key,
    required this.docId,
    required this.name,
    required this.studentId,
    required this.email,
    required this.course,
    required this.age,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _studentIdController;
  late final TextEditingController _emailController;
  late final TextEditingController _courseController;
  late final TextEditingController _ageController;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _studentIdController = TextEditingController(text: widget.studentId);
    _emailController = TextEditingController(text: widget.email);
    _courseController = TextEditingController(text: widget.course);
    _ageController = TextEditingController(text: widget.age);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await _firestoreService.updateStudent(
        widget.docId,
        _nameController.text.trim(),
        _studentIdController.text.trim(),
        _emailController.text.trim(),
        _courseController.text.trim(),
        _ageController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    }
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(label: 'Name', controller: _nameController),
              const SizedBox(height: 16),
              _buildField(
                label: 'Student ID',
                controller: _studentIdController,
              ),
              const SizedBox(height: 16),
              _buildField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildField(label: 'Course', controller: _courseController),
              const SizedBox(height: 16),
              _buildField(
                label: 'Age',
                controller: _ageController,
                keyboardType: TextInputType.number,
              ),
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
