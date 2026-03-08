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
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: Icon(prefixIcon, size: 20),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () => controller.clear(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Please enter $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Update Student',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(
                label: 'Name',
                controller: _nameController,
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 14),
              _buildField(
                label: 'Student ID',
                controller: _studentIdController,
                prefixIcon: Icons.badge_outlined,
              ),
              const SizedBox(height: 14),
              _buildField(
                label: 'Email',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              _buildField(
                label: 'Course',
                controller: _courseController,
                prefixIcon: Icons.book_outlined,
              ),
              const SizedBox(height: 14),
              _buildField(
                label: 'Age',
                controller: _ageController,
                prefixIcon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
