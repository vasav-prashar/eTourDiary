// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import "package:etourdiary/services/events.dart";

class UpdateDialog extends StatefulWidget {
  final Map<String, dynamic> eventData;

  UpdateDialog({super.key, required this.eventData});

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final EventService _eventService = EventService();
  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.eventData['title']);
    _descriptionController =
        TextEditingController(text: widget.eventData['description']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Update Event'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic),
                  hintText: "Enter Title",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic),
                  hintText: "Enter Description",
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                maxLength: 1000,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue
            ),
            child: const Text('Save'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String id = await _eventService.getEventId(
                    widget.eventData['title'],
                    widget.eventData['description'],
                    widget.eventData['date'],
                    widget.eventData['time']);
                await _eventService.updateEvent(
                    _titleController.text,
                    _descriptionController.text,
                    widget.eventData['date'],
                    widget.eventData['time'],
                    id);
                Navigator.of(context).pop();
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
