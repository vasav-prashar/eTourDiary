import 'package:etourdiary/services/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _value = "";
  TextEditingController dateinput = TextEditingController();
  //text editing controller for text field
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();

  final EventService _events = EventService();

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    _value = "forenoon";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _title,
                decoration: InputDecoration(
                    labelText: "Title",
                    icon: Icon(Icons.title),
                    iconColor: Colors.black,
                    labelStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic),
                    hintText: "Enter Title",
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
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 20),
                child: TextFormField(
                  controller: _description,
                  decoration: InputDecoration(
                      icon: Icon(Icons.description),
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: dateinput, //editing controller of this TextField
                  decoration: InputDecoration(
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
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Radio(
                      value: "forenoon",
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = "forenoon";
                        });
                      },
                    ),
                    Text(
                      "Forenoon",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    )
                  ]),
                  Row(children: [
                    Radio(
                      value: "afternoon",
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = "afternoon";
                        });
                      },
                    ),
                    Text("Afternoon",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300))
                  ]),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      _events.addEventData(_title.text, _description.text,
                          dateinput.text, _value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added Sucessfully.'),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
