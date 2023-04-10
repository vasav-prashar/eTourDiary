import 'package:flutter/material.dart';
import "package:etourdiary/services/events.dart";

class UpdateDialog extends StatefulWidget {
  final Map<String, dynamic> eventData;

  UpdateDialog({required this.eventData});

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  final EventService _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.eventData['title']);
    _descriptionController =
        TextEditingController(text: widget.eventData['description']);
    _dateController = TextEditingController(text: widget.eventData['date']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Event'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(hintText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(hintText: 'Date'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Save'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await _eventService.updateEvent(
                  _titleController.text,
                  _descriptionController.text,
                  _dateController.text,
                  'forenoon');
              Navigator.of(context).pop();
              setState(() {});
            }
          },
        ),
      ],
    );
  }
}
