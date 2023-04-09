import 'dart:ui';

import 'package:etourdiary/services/events.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class View extends StatefulWidget {
  const View({super.key});

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  EventService _eventService = EventService();
  List<Map<String, dynamic>> _eventsData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getEventsForDate(DateFormat('dd-MM-yyyy').format(_focusedDay).toString());
  }

  void _getEventsForDate(String date) async {
    List<Map<String, dynamic>> events = await _eventService.getEventsData(date);
    if (events != null) {
      setState(() {
        _eventsData = events;
        print(_eventsData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
                _getEventsForDate(
                    DateFormat('dd-MM-yyyy').format(_focusedDay).toString());
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
          Text(
            "Selected Date Is",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Text(
            DateFormat('dd-MM-yyyy').format(_focusedDay),
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
          SingleChildScrollView(
            child: SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _eventsData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.title),
                          iconColor: Colors.black,
                          title: Text(_eventsData[index]['title'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),),
                          subtitle: Text(_eventsData[index]['description'],
                          style: const TextStyle(
                            fontSize: 15
                          ),),
                          trailing: Text(_eventsData[index]['time']),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
