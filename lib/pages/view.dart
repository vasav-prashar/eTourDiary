// ignore_for_file: prefer_final_fields, unused_field, prefer_const_constructors

import 'package:etourdiary/services/events.dart';
import 'package:etourdiary/utils/deletedialog.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../utils/updatedialog.dart';

class View extends StatefulWidget {
  const View({super.key});

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  EventService _eventService = EventService();
  List<Map<String, dynamic>> _eventsData = [];

  @override
  void initState() {
    super.initState();
    _eventService
        .getEventsData(DateFormat('yyyy/MM/dd').format(_focusedDay).toString());
    _focusedDay = _selectedDay;
    // _getEventsForDate(DateFormat('dd-MM-yyyy').format(_focusedDay).toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_focusedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = focusedDay;
                _focusedDay = selectedDay; // update `_focusedDay` here as well
                // _getEventsForDate(
                //     DateFormat('dd-MM-yyyy').format(_focusedDay).toString());
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                if (day.weekday == DateTime.sunday) {
                  final text = DateFormat.E().format(day);

                  return Center(
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20,),
          const Text(
            "Selected Date Is",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          Text(
            DateFormat('dd-MM-yyyy').format(_focusedDay),
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _eventService.getEventsData(
                DateFormat('yyyy/MM/dd').format(_focusedDay).toString()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else if (snapshot.data!.isEmpty) {
                return Text("No events found for selected date");
              } else {
                return SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final event = snapshot.data![index];

                      return Card(
                        // shape:Border(bottom: BorderSide(), top: BorderSide(),left: BorderSide(),right: BorderSide()),
                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(5)),
                            ListTile(
                              leading: Icon(Icons.all_inbox,color: Colors.blue,),
                              title: Text(event['title']),
                              subtitle: Text(event['description']),
                              trailing: Text(event['time']),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit,color: Colors.blue,),
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return UpdateDialog(eventData: event);
                                      },
                                    );
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                    icon: Icon(Icons.delete,color: Colors.blue,),
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return deleteDialog(
                                                eventData: event);
                                          });
                                      setState(() {});
                                    }),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
