// ignore_for_file: unnecessary_brace_in_string_interps
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:etourdiary/services/events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart';

String formatDateToMonth(String date) {
  final DateFormat inputFormat = DateFormat('yyyy/MM/dd');
  final DateTime dateTime = inputFormat.parse(date);
  final DateFormat outputFormat = DateFormat('MMMM yyyy');
  return outputFormat.format(dateTime);
}

final EventService _events = EventService();
// Function to generate the PDF
Future<pdf.Document> generatePDF(String startDate, String endDate) async {
  // Retrieve events data for the given date range
  final List<Map<String, dynamic>> events =
      await _events.getEventsRangeData(startDate, endDate);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String designation = '';

  // Get the current user ID
  String userId = _auth.currentUser?.uid ?? '';
  // Retrieve the user's data from the 'designations' subcollection
  QuerySnapshot designationSnapshot = await _firestore
      .collection('users')
      .doc(userId)
      .collection('designation')
      .limit(1) // Limit to one document in case there are multiple (not required if you only expect one)
      .get();

  if (designationSnapshot.docs.isNotEmpty) {
    designation = designationSnapshot.docs.first.get('designation') ?? '';
  }

  String startMonth = formatDateToMonth(startDate);
  // String endMonth = formatDateToMonth(endDate);

  // Create a new PDF document
  final pdf.Document pdfDoc = pdf.Document();

  // Define the table headers
  final List<String> headers = ['Date', 'Time', 'Title', 'Description'];

  // Create a table widget
  final pdf.Table table = pdf.Table.fromTextArray(
    headers: headers,
    data: List<List<dynamic>>.from(
      events.map((event) => [
            event['date'] ?? '',
            event['time'] ?? '',
            event['title'] ?? '',
            event['description'] ?? '',
          ]),
    ),
    cellStyle: const pdf.TextStyle(fontSize: 10),
    headerStyle: pdf.TextStyle(fontSize: 12, fontWeight: pdf.FontWeight.bold),
    border: pdf.TableBorder.all(width: 1, color: PdfColors.black),
    headerDecoration: const pdf.BoxDecoration(
      borderRadius: pdf.BorderRadius.all(pdf.Radius.circular(2)),
      color: PdfColors.grey300,
    ),
    columnWidths: {
      0: const FlexColumnWidth(1.1),
      1: const FlexColumnWidth(0.9),
      2: const FlexColumnWidth(1),
      3: const FlexColumnWidth(5)
    },
  );

  // Add the table to the PDF document
  pdfDoc.addPage(
    pdf.MultiPage(
      build: (pdf.Context context) => [
        pdf.Header(
          level: 0,
          text: 'TOUR DIARY OF ${_auth.currentUser?.displayName} $designation, JAMMU FOR THE MONTH OF  $startMonth', textStyle: TextStyle(
            fontSize: 16,
            fontWeight: pdf.FontWeight.bold
          ),
        ),
        pdf.Padding(padding: const pdf.EdgeInsets.only(bottom: 10)),
        table,
      ],
    ),
  );

  return pdfDoc;
}
