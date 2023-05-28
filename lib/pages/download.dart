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
      const Text("Select the date range",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),),
      const SizedBox(height: 70),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20),
          Expanded(
              child: ElevatedButton(
            onPressed: pickDateRange,
            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(55))),
                              fixedSize: Size(0,80),
                              backgroundColor: Colors.blue),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.date_range,size: 23,),
                Text(DateFormat('dd/MM/yyyy').format(start),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),),
                            const SizedBox(width: 15,),
                            const Icon(Icons.horizontal_rule),
                            const SizedBox(width: 15,),
                            const Icon(Icons.date_range,size: 23,),
                Text(DateFormat('dd/MM/yyyy').format(end),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),)
              ],
            ),
          )),
          const SizedBox(width: 10),
          const SizedBox(width: 20)
        ],
      ),
      const SizedBox(height: 130),
      ElevatedButton(
          onPressed: () async {
            final pdf.Document pdfDoc = await generatePDF(
                DateFormat('yyyy/MM/dd').format(start),
                DateFormat('yyyy/MM/dd').format(end));

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
          style: ElevatedButton.styleFrom(
                              // shape: const RoundedRectangleBorder(
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(55))),
                              padding:
                                  const EdgeInsets.fromLTRB(45, 20, 45, 20),
                              backgroundColor: Colors.blue,),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.settings),
                              SizedBox(width: 10,),
                              Text('Generate',
                                style: TextStyle(
                                  fontSize: 20,
                                ))
                            ],
                          ),                         
          ),
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
