import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  Future<void> addMessage(String message, String name) {
    return messages.add({
      'message': message,
      'name': name,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getMessageStream() {
    final messageStream =
        messages.orderBy('timestamp', descending: true).snapshots();

    return messageStream;
  }
}
