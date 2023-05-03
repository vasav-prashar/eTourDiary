// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:intl/intl.dart';
import 'package:etourdiary/services/events.dart';
import 'package:pdf/widgets.dart';

final EventService _events = EventService();
// Function to generate the PDF
Future<pdf.Document> generatePDF(String startDate, String endDate) async {
  // Retrieve events data for the given date range
  final List<Map<String, dynamic>> events =
      await _events.getEventsRangeData(startDate, endDate);

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
      0: FlexColumnWidth(1.1),
      1: FlexColumnWidth(0.9),
      2: FlexColumnWidth(1),
      3: FlexColumnWidth(5)
    },
  );

  // Add the table to the PDF document
  pdfDoc.addPage(
    pdf.MultiPage(
      build: (pdf.Context context) => [
        pdf.Header(
          level: 0,
          text: 'Events for ${startDate} - ${endDate}',
        ),
        pdf.Padding(padding: const pdf.EdgeInsets.only(bottom: 10)),
        table,
      ],
    ),
  );

  return pdfDoc;
}
