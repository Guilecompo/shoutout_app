import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches a student document by [studentId].
  /// Returns the document snapshot if found, otherwise returns null.
  Future<DocumentSnapshot?> getStudentByStudentId(String studentId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Students_info')  // Updated collection name
          .where('student_id', isEqualTo: studentId)
          .limit(1)
          .get();

      // Return the first document if found, otherwise null
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        return null;
      }
    } catch (e) {
      // Log the error and rethrow to handle it in the caller
      print("Error fetching student: $e");
      rethrow; 
    }
  }

  // Additional Firestore-related methods can be added here as needed
}
