import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:nepali_date_picker/nepali_date_picker.dart" as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

class AddToList extends StatefulWidget {
  final void Function({required String item, required dynamic dt}) addNote;
  AddToList({required this.addNote, super.key});

  @override
  State<AddToList> createState() => _AddToListState();
}

class _AddToListState extends State<AddToList> {
  var noteController = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  NepaliDateTime? _selectedDateTime;
  String? formattedDate;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                maxLines: 2,
                autofocus: true,
                controller: noteController,
                validator: (value) {
                  if (value == "") {
                    return "Please add your note first";
                  }
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                        onTap: () async {
                          _selectedDateTime =
                              await picker.showMaterialDatePicker(
                            context: context,
                            initialDate: NepaliDateTime.now(),
                            firstDate: NepaliDateTime(2000),
                            lastDate: NepaliDateTime(2090),
                            initialDatePickerMode: DatePickerMode.day,
                          );
                          if (_selectedDateTime != null) {
                            formattedDate = DateFormat('yyyy-MM-dd')
                                .format(_selectedDateTime!);
                          }
                        },
                        child: Icon(Icons.calendar_month)),
                    contentPadding: EdgeInsets.all(20),
                    label: Text("Write Note")),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate() &&
                          _selectedDateTime != null) {
                        widget.addNote(
                            item: noteController.text, dt: formattedDate);
                        noteController.text = "";
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              icon: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              title: Text(
                                "Error!!",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                  "Please write a note and choose the date"),
                            );
                          },
                        );
                      }
                    },
                    child: Text("Add Note")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
