import 'dart:io';
import 'dart:async';
import 'package:etourdiary/services/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pdf;
import '../services/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  final EventService _events = EventService();
  DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  @override
  Widget build(BuildContext context) {
    final start = selectedDates.start;
    final end = selectedDates.end;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Select the date range"),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: ElevatedButton(
            child: Text(DateFormat('dd-MM-yyyy').format(start)),
            onPressed: pickDateRange,
          )),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: ElevatedButton(
            child: Text(DateFormat('dd-MM-yyyy').format(end)),
            onPressed: pickDateRange,
          ))
        ],
      ),
      SizedBox(
        height: 20,
      ),
      ElevatedButton(
          onPressed: () async {
            final pdf.Document pdfDoc = await generatePDF(
                DateFormat('dd-MM-yyyy').format(start),
                DateFormat('dd-MM-yyyy').format(end));

// Save the PDF to the device
            final bytes = await pdfDoc.save();
            Directory directory = await getApplicationDocumentsDirectory();
            print(directory);
            final file = File('${directory.path}/events.pdf');
            print(file);
            await file.writeAsBytes(bytes);

            await OpenFile.open('${directory.path}/events.pdf');
            // print(OpenFile.open(file));
          },
          child: Text("Generate"))
    ]);
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: selectedDates,
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));
    if (newDateRange == null) return;
    setState(() {
      selectedDates = newDateRange;
    });
  }
}
