import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rumi/models/baby.dart';
import 'package:rumi/shared/constants.dart';

class AddRecommendation extends StatefulWidget {
  const AddRecommendation({super.key});

  @override
  State<AddRecommendation> createState() => _AddRecommendationState();
}

class _AddRecommendationState extends State<AddRecommendation> {
  final _formKey = GlobalKey<FormState>();

  Baby? _selectedBaby;
  String _currentNotes = '';
  String? _selectedDuration;

  @override
  Widget build(BuildContext context) {
    final babies = Provider.of<List<Baby>?>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text('Buat Rencana Menu MPASI', style: TextStyle(fontSize: 18.0)),
              SizedBox(height: 20.0),

              if (_selectedBaby == null) ...[
                // center the dropdown + button when no baby selected
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ],

              // baby dropdown
              DropdownButtonFormField<Baby>(
                value: _selectedBaby,
                hint: Text('Pilih Bayi'),
                items: (babies ?? []).map((baby) {
                  return DropdownMenuItem<Baby>(
                    value: baby,
                    child: Text(baby.fullName),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedBaby = val),
                validator: (val) =>
                    val == null ? 'Pilih bayi terlebih dahulu' : null,
              ),

              // munculin data bayi yang dipilih, read only
              if (_selectedBaby != null) ...[
                SizedBox(height: 20.0),

                // first name
                TextFormField(
                  initialValue: _selectedBaby!.firstName,
                  readOnly: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'First Name',
                    hintText: 'First Name',
                  ),
                ),
                SizedBox(height: 20.0),

                // middle name (read-only, only shown if exists)
                if (_selectedBaby!.middleName != null &&
                    _selectedBaby!.middleName!.isNotEmpty) ...[
                  TextFormField(
                    initialValue: _selectedBaby!.middleName,
                    readOnly: true,
                    decoration: textInputDecoration.copyWith(
                      labelText: 'Middle Name',
                      hintText: 'Middle Name',
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],

                // last name (read-only)
                TextFormField(
                  initialValue: _selectedBaby!.lastName,
                  readOnly: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Last Name',
                    hintText: 'Last Name',
                  ),
                ),
                SizedBox(height: 20.0),

                // gender (read-only)
                TextFormField(
                  initialValue: _selectedBaby!.gender,
                  readOnly: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Gender',
                    hintText: 'Gender',
                  ),
                ),
                SizedBox(height: 20.0),

                // date of birth (read-only)
                TextFormField(
                  initialValue:
                      '${_selectedBaby!.dateOfBirth.day}/${_selectedBaby!.dateOfBirth.month}/${_selectedBaby!.dateOfBirth.year}',
                  readOnly: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Date of Birth',
                    hintText: 'Date of Birth',
                  ),
                ),
                SizedBox(height: 20.0),

                // weight (read-only)
                TextFormField(
                  initialValue: '${_selectedBaby!.weight} kg',
                  readOnly: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Weight (kg)',
                    hintText: 'Weight (kg)',
                  ),
                ),
                SizedBox(height: 20.0),

                // height (read-only)
                TextFormField(
                  initialValue: '${_selectedBaby!.height} cm',
                  readOnly: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Height (cm)',
                    hintText: 'Height (cm)',
                  ),
                ),
                SizedBox(height: 20.0),

                // catatan kesehatan khusus
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Catatan Kesehatan Khusus',
                    hintText: 'Catatan Kesehatan Khusus (Opsional)',
                  ),
                  maxLines: 3,
                  onChanged: (val) => setState(() => _currentNotes = val),
                ),
                SizedBox(height: 20),

                // duration selection
                DropdownButtonFormField<String>(
                  value: _selectedDuration,
                  hint: Text('Pilih Durasi'),
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Durasi Rencana',
                  ),
                  items: ['1 Minggu', '2 Minggu', '1 Bulan'].map((duration) {
                    return DropdownMenuItem<String>(
                      value: duration,
                      child: Text(duration),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedDuration = val),
                  validator: (val) =>
                      val == null ? 'Pilih durasi rencana' : null,
                ),

                SizedBox(height: 20),

                // submit
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 144, 121, 84),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Buat Rencana',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
