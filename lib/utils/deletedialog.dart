// ignore_for_file: prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:etourdiary/services/events.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class deleteDialog extends StatefulWidget {
  final Map<String, dynamic> eventData;
  deleteDialog({super.key, required this.eventData});

  @override
  State<deleteDialog> createState() => _deleteDialogState();
}

// ignore: camel_case_types
class _deleteDialogState extends State<deleteDialog> {
  final EventService _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure you want to delete?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('NO')),
        TextButton(
            onPressed: () async {
              await _eventService.deleteEvent(widget.eventData['title'],
                  widget.eventData['description'], widget.eventData['date']);
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text('YES')),
      ],
    );
  }
}
