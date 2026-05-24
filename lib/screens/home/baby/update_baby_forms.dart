import 'package:flutter/material.dart';
import 'package:rumi/models/baby.dart';
import 'package:rumi/services/database.dart';
import 'package:rumi/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:rumi/models/user.dart';
import 'package:rumi/shared/loading.dart';

class UpdateBabyForms extends StatefulWidget {
  final Baby baby;
  const UpdateBabyForms({super.key, required this.baby});

  @override
  State<UpdateBabyForms> createState() => _UpdateBabyFormsState();
}

class _UpdateBabyFormsState extends State<UpdateBabyForms> {
  final _formKey = GlobalKey<FormState>();
  final List<String> genders = ['Male', 'Female'];

  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;

  String _currentGender = 'Male';
  DateTime? _currentDOB;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.baby.firstName);
    _middleNameController = TextEditingController(text: widget.baby.middleName ?? '');
    _lastNameController = TextEditingController(text: widget.baby.lastName);
    _weightController = TextEditingController(text: widget.baby.weight.toString());
    _heightController = TextEditingController(text: widget.baby.height.toString());
    _currentGender = widget.baby.gender;
    _currentDOB = widget.baby.dateOfBirth;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text('Update Baby', style: TextStyle(fontSize: 18.0)),
                  SizedBox(height: 20.0),

                  // first name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: textInputDecoration.copyWith(hintText: 'First Name'),
                    validator: (val) => val!.isEmpty ? 'Please enter a first name' : null,
                  ),
                  SizedBox(height: 20.0),

                  // middle name
                  TextFormField(
                    controller: _middleNameController,
                    decoration: textInputDecoration.copyWith(hintText: 'Middle Name (Optional)'),
                  ),
                  SizedBox(height: 20.0),

                  // last name
                  TextFormField(
                    controller: _lastNameController,
                    decoration: textInputDecoration.copyWith(hintText: 'Last Name'),
                    validator: (val) => val!.isEmpty ? 'Please enter a last name' : null,
                  ),
                  SizedBox(height: 20.0),

                  // gender
                  DropdownButtonFormField(
                    value: _currentGender,
                    items: genders.map((gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender));
                    }).toList(),
                    onChanged: (val) => setState(() => _currentGender = val!),
                  ),
                  SizedBox(height: 20.0),

                  // date of birth
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _currentDOB ?? DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 5),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _currentDOB = picked);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: _currentDOB == null
                              ? 'Date of Birth'
                              : '${_currentDOB!.day}/${_currentDOB!.month}/${_currentDOB!.year}',
                        ),
                        validator: (_) => _currentDOB == null ? 'Please select a date of birth' : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),

                  // weight
                  TextFormField(
                    controller: _weightController,
                    decoration: textInputDecoration.copyWith(hintText: 'Weight (kg)'),
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? 'Please enter a weight' : null,
                  ),
                  SizedBox(height: 20.0),

                  // height
                  TextFormField(
                    controller: _heightController,
                    decoration: textInputDecoration.copyWith(hintText: 'Height (cm)'),
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? 'Please enter a height' : null,
                  ),
                  SizedBox(height: 20.0),

                  // submit
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Update Data', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        await DatabaseService(uid: user!.uid).updateBaby(
                          widget.baby.id,
                          _firstNameController.text,
                          _middleNameController.text.trim().isEmpty ? null : _middleNameController.text.trim(),
                          _lastNameController.text,
                          _currentGender,
                          _currentDOB!,
                          double.parse(_weightController.text),
                          double.parse(_heightController.text),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(child: Loading()),
            ),
          ),
      ],
    );
  }
}