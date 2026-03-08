import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _students =
      FirebaseFirestore.instance.collection('students');

  Future<void> addStudent(
    String name,
    String studentId,
    String email,
    String course,
    String age,
  ) async {
    await _students.add({
      'name': name,
      'studentId': studentId,
      'email': email,
      'course': course,
      'age': age,
    });
  }

  Stream<QuerySnapshot> getStudents() {
    return _students.snapshots();
  }

  Future<void> updateStudent(
    String docId,
    String name,
    String studentId,
    String email,
    String course,
    String age,
  ) async {
    await _students.doc(docId).update({
      'name': name,
      'studentId': studentId,
      'email': email,
      'course': course,
      'age': age,
    });
  }

  Future<void> deleteStudent(String docId) async {
    await _students.doc(docId).delete();
  }
}
