// ignore_for_file: prefer_final_fields

import 'package:etourdiary/services/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Submit extends StatefulWidget {
  const Submit({super.key});

  @override
  State<Submit> createState() => _SubmitState();
}

class _SubmitState extends State<Submit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _value = "";
  TextEditingController dateinput = TextEditingController();
  //text editing controller for text field
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  Meeting? _selectedMeeting;
  bool _isOthersSelected = false;
  String? _selectedValue;

  final EventService _events = EventService();

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    _value = "Forenoon";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    DropdownButtonFormField<Meeting>(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.title),
                        iconColor: Colors.black,
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      items: meetings.map((meeting) {
                        return DropdownMenuItem<Meeting>(
                          value: meeting,
                          child: Text(meeting.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value?.name != 'Others') {
                            _selectedMeeting = value;
                            _selectedValue = value!.name;
                            _isOthersSelected = false;
                          } else {
                            _isOthersSelected = true;
                          }
                        });
                      },
                      value: _selectedMeeting,
                      hint: const Text('Title'),
                      validator: (Meeting? value) {
                        if (value == null) {
                          return 'Please select a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    if (_isOthersSelected)
                      TextFormField(
                        controller: _title,
                        decoration: InputDecoration(
                            labelText: "Enter a title",
                            icon: const Icon(Icons.title),
                            iconColor: Colors.black,
                            labelStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic),
                            hintText: "Others",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _description,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.description),
                          iconColor: Colors.black,
                          labelText: "Description",
                          labelStyle: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic),
                          hintText: "Enter Description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      maxLength: 1000,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller:
                          dateinput, //editing controller of this TextField
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.calendar_today), //icon of text field
                          iconColor: Colors.black,
                          labelText: "Select Date" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime
                                .now(), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(pickedDate);
                          String formattedDate =
                              DateFormat('yyyy/MM/dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            dateinput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Radio(
                            value: "Forenoon",
                            groupValue: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = "Forenoon";
                              });
                            },
                          ),
                          const Text(
                            "Forenoon",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          )
                        ]),
                        Row(children: [
                          Radio(
                            value: "Afternoon",
                            groupValue: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = "Afternoon";
                              });
                            },
                          ),
                          const Text("Afternoon",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w300))
                        ]),
                      ],
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () async {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          if (_isOthersSelected) {
                            _selectedValue = _title.text;
                          }

                          // Process data.
                          _events.addEventData(_selectedValue!,
                              _description.text, dateinput.text, _value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added Sucessfully.'),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _title.clear();
                          _description.clear();
                          dateinput.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(120, 60),
                          backgroundColor: Colors.blue),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Meeting {
  final String name;
  Meeting(this.name);
}

List<Meeting> meetings = [
  Meeting('A'),
  Meeting('B'),
  Meeting('C'),
  Meeting('Others')
];
