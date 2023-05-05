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
        'time': time,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Event data added successfully');
    } catch (e) {
      print('Error adding event data: $e');
      throw e;
    }
  }

  Stream<List<Map<String, dynamic>>> getEventsData(String selectedDate) async* {
    try {
      User? user = _auth.currentUser;
      // List<Map<String, dynamic>> eventsData = [];

      QuerySnapshot snapshot = await _db
          .collection('users')
          .doc(user?.uid)
          .collection('events')
          .where('date', isEqualTo: selectedDate)
          .get();

      print(snapshot.docs.map((doc) => doc.data()).toList());
      yield snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching events: $e');
      throw e;
    }
  }

  Future<void> deleteEvent(
      String title, String description, String date) async {
    try {
      User? user = _auth.currentUser;
      QuerySnapshot snapshot = await _db
          .collection('users')
          .doc(user?.uid)
          .collection('events')
          .where('title', isEqualTo: title)
          .where('description', isEqualTo: description)
          .where('date', isEqualTo: date)
          .get();
      String eventId = snapshot.docs[0].id;
      await _db
          .collection('users')
          .doc(user?.uid)
          .collection('events')
          .doc(eventId)
          .delete();
      print('Event deleted successfully');
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  Future<void> updateEvent(String title, String description, String date,
      String time, String id) async {
    try {
      Map<String, dynamic> data = {
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'updatedAt': FieldValue.serverTimestamp()
      };
      User? user = _auth.currentUser;

      // String timeStamp = snapshot.docs[0]['createdAt'];
      // print(timeStamp);
      await _db
          .collection('users')
          .doc(user?.uid)
          .collection('events')
          .doc(id)
          .update(data);
      print('Event Updated successfully');
    } catch (e) {
      print('Error updating event: $e');
    }
  }

  Future<String> getEventId(
      String title, String description, String date, String time) async {
    try {
      User? user = _auth.currentUser;
      QuerySnapshot snapshot = await _db
          .collection('users')
          .doc(user?.uid)
          .collection('events')
          .where('title', isEqualTo: title)
          .where('description', isEqualTo: description)
          .where('date', isEqualTo: date)
          .get();
      return snapshot.docs[0].id;
    } catch (e) {
      print('Error getting event ID: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getEventsRangeData(
      String start, String end) async {
    try {
      User? user = _auth.currentUser;
      // List<Map<String, dynamic>> eventsData = [];

      QuerySnapshot snapshot = await _db
          .collection('users')
          .doc(user?.uid)
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: start)
          .where('date', isLessThanOrEqualTo: end)
          .orderBy('date')
          .get();

      print(snapshot.docs.map((doc) => doc.data()).toList());
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching events: $e');
      throw e;
    }
  }
}
