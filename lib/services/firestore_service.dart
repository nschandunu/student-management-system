import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _students = FirebaseFirestore.instance.collection(
    'students',
  );

  Future<void> addStudent(String name, String studentId, String degree) async {
    await _students.add({
      'name': name,
      'studentId': studentId,
      'degree': degree,
    });
  }

  Stream<QuerySnapshot> getStudents() {
    return _students.snapshots();
  }

  Future<void> updateStudent(
    String docId,
    String name,
    String studentId,
    String degree,
  ) async {
    await _students.doc(docId).update({
      'name': name,
      'studentId': studentId,
      'degree': degree,
    });
  }

  Future<void> deleteStudent(String docId) async {
    await _students.doc(docId).delete();
  }
}
