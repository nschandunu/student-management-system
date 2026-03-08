import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'update_screen.dart';

class ReadScreen extends StatelessWidget {
  const ReadScreen({super.key});

  static const _pastelColors = [
    Color(0xFFFFD6E0),
    Color(0xFFFFEFCC),
    Color(0xFFD6F5E8),
    Color(0xFFCCE5FF),
    Color(0xFFE8D6FF),
    Color(0xFFFFD6CC),
  ];

  static const _pastelTextColors = [
    Color(0xFFB0003A),
    Color(0xFF8A6000),
    Color(0xFF006644),
    Color(0xFF004999),
    Color(0xFF5B009E),
    Color(0xFF8A2E00),
  ];

  Color _avatarColor(String name) {
    if (name.isEmpty) return _pastelColors[0];
    return _pastelColors[name.codeUnitAt(0) % _pastelColors.length];
  }

  Color _avatarTextColor(String name) {
    if (name.isEmpty) return _pastelTextColors[0];
    return _pastelTextColors[name.codeUnitAt(0) % _pastelTextColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Students',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'No students yet',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final name = data['name'] as String? ?? '';
              final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
              final bgColor = _avatarColor(name);
              final fgColor = _avatarTextColor(name);

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: bgColor,
                    child: Text(
                      initial,
                      style: TextStyle(
                        color: fgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          data['course'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'ID: ${data['studentId'] ?? ''}  •  Age: ${data['age'] ?? ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        data['email'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.grey.shade400),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateScreen(
                            docId: doc.id,
                            name: data['name'] ?? '',
                            studentId: data['studentId'] ?? '',
                            email: data['email'] ?? '',
                            course: data['course'] ?? '',
                            age: data['age'] ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
