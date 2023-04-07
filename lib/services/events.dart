import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addEventData(
      String title, String description, String date, String time) async {
    try {
      // Get the current user
      User? user = _auth.currentUser;
      print(user);

      // Add event data to Firestore for the current user
      await _db.collection('users').doc(user!.uid).collection('events').add({
        'title': title,
        'description': description,
        'date': date,
        'time': time
      });

      print('Event data added successfully');
    } catch (e) {
      print('Error adding event data: $e');
      throw e;
    }
  }
}
