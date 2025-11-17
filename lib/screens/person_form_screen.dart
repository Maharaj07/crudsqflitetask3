import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled3/database/database_helper.dart';
import '../models/person.dart';

class PersonFormScreen extends StatefulWidget {
  final Person? person;
  PersonFormScreen({this.person});

  @override
  _PersonFormScreenState createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends State<PersonFormScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  DateTime? _selectedDob;
  final _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      _nameController.text = widget.person!.name;
      _emailController.text = widget.person!.email;
      _ageController.text = widget.person!.age.toString();
      _selectedDob = DateTime.tryParse(widget.person!.dob);
    }
  }

  void _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  void _save() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final ageStr = _ageController.text.trim();

    if (name.isEmpty || email.isEmpty || ageStr.isEmpty || _selectedDob == null) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return;
    }

    final age = int.tryParse(ageStr);
    if (age == null) {
      Fluttertoast.showToast(msg: 'Enter valid age');
      return;
    }

    final dobIso = _selectedDob!.toIso8601String().split('T').first;

    if (widget.person == null) {
      final person = Person(name: name, email: email, age: age, dob: dobIso);
      await _dbHelper.insertPerson(person);
      Fluttertoast.showToast(msg: 'Data inserted successfully!');
    } else {
      final person = Person(
          id: widget.person!.id, name: name, email: email, age: age, dob: dobIso);
      final updated = await _dbHelper.updatePerson(person);
      if (updated > 0)
        Fluttertoast.showToast(msg: 'Data updated successfully!');
      else
        Fluttertoast.showToast(msg: 'Error updating record!');
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.person != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Person' : 'Add Person')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration:
                InputDecoration(border: OutlineInputBorder(), hintText: 'Name')),
            SizedBox(height: 8),
            TextField(
                controller: _emailController,
                decoration:
                InputDecoration(border: OutlineInputBorder(), hintText: 'Email')),
            SizedBox(height: 8),
            TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration:
                InputDecoration(border: OutlineInputBorder(), hintText: 'Age')),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(_selectedDob == null
                      ? 'No DOB chosen'
                      : 'DOB: ${_selectedDob!.toIso8601String().split('T').first}'),
                ),
                ElevatedButton(onPressed: _pickDob, child: Text('Pick DOB'))
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'Update Data' : 'Insert Data'))
          ],
        ),
      ),
    );
  }
}
