import 'package:etourdiary/services/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class deleteDialog extends StatefulWidget {
  final Map<String, dynamic> eventData;
  deleteDialog({required this.eventData});

  @override
  State<deleteDialog> createState() => _deleteDialogState();
}

class _deleteDialogState extends State<deleteDialog> {
  EventService _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure you want to delete?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('NO')),
        TextButton(
            onPressed: () async {
              await _eventService.deleteEvent(widget.eventData['title'],
                  widget.eventData['description'], widget.eventData['date']);
              Navigator.of(context).pop();
              setState(() {});
            },
            child: Text('YES')),
      ],
    );
  }
}
