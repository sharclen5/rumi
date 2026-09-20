import 'package:flutter/material.dart';
import 'package:rumi/services/auth.dart';
import 'package:rumi/shared/loading.dart';
import 'package:rumi/shared/constants.dart';

class Register extends StatefulWidget {
  final void Function({bool fromRegister}) toggleView;

  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool loading = false;

  // text field state
  String email = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String gender = '';
  String password = '';
  String error = '';
  bool _obscurePassword = true; // ADDED: state untuk show/hide password

  @override
  Widget build(BuildContext context) {
    // ADDED: baca inset navbar sistem, sama kayak pattern yang udah dipake di bottomnavbar.dart
    final systemNavInset = MediaQuery.of(context).padding.bottom;
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 1, top: 1),
                    child: SizedBox(
                      // ADDED: sama kaya sign_in, kasih box lebih gede biar hit-test badge-nya kena
                      width:
                          500, // 413 + ruang buat badge yang overflow ke kanan
                      height: 457,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            "assets/images/vector-3.png",
                            width: 413,
                            height: 457,
                          ), // TETEP SAMA, ga perlu Positioned, karena overflow-nya ke kanan (arah positif), jadi ga perlu digeser
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Buat Akun Baru',
                            style: TextStyle(
                              color: Color(0xFF363434),
                              fontSize: 27,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 25),
                          // email
                          TextFormField(
                            controller: _emailController,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFF393939),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Email',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF837E93),
                                ),
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? 'Masukan email anda'
                                : null,
                            onChanged: (val) => setState(() => email = val),
                          ),
                          const SizedBox(height: 30),
                          // first name
                          TextFormField(
                            controller: _firstNameController,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFF393939),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Nama Depan',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF837E93),
                                ),
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? 'Masukan nama depan anda'
                                : null,
                            onChanged: (val) => setState(() => firstName = val),
                          ),
                          const SizedBox(height: 30),
                          // last name
                          TextFormField(
                            controller: _lastNameController,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFF393939),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Nama Belakang',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF837E93),
                                ),
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? 'Masukan nama belakang anda'
                                : null,
                            onChanged: (val) => setState(() => lastName = val),
                          ),
                          const SizedBox(height: 30),
                          // gender
                          DropdownButtonFormField<String>(
                            value: gender.isEmpty
                                ? null
                                : gender, // null shows the hint
                            hint: const Text(
                              'Jenis Kelamin',
                            ), // shown when nothing is selected
                            validator: (val) => val == null || val.isEmpty
                                ? 'Pilih jenis kelamin anda'
                                : null,
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Jenis Kelamin',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF837E93),
                                ),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Male',
                                child: Text('Laki-laki'),
                              ),
                              DropdownMenuItem(
                                value: 'Female',
                                child: Text('Perempuan'),
                              ),
                            ],
                            onChanged: (val) => setState(() => gender = val!),
                          ),
                          const SizedBox(height: 30),
                          // phone number
                          TextFormField(
                            controller: _phoneController,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFF393939),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Nomor Telepon',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF837E93),
                                ),
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? 'Masukan nomor telepon anda'
                                : null,
                            onChanged: (val) => setState(() => phone = val),
                          ),
                          const SizedBox(height: 30),
                          // password
                          TextFormField(
                            controller: _passController,
                            textAlign: TextAlign.left,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              color: Color(0xFF393939),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF837E93),
                                ),
                              ),
                              suffixIcon: IconButton(
                                // ADDED: tombol mata di ujung kanan field
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF837E93),
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ), // ADDED: toggle state
                              ),
                            ),
                            validator: (val) => val == null || val.length < 6
                                ? 'Masukan kata sandi dengan minimal 6 karakter'
                                : null,
                            onChanged: (val) => setState(() => password = val),
                          ),
                          const SizedBox(height: 25),
                          // register button
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF363434),
                                ),
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    setState(() => loading = true);
                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                          email,
                                          firstName,
                                          lastName,
                                          phone,
                                          gender,
                                          password,
                                        );
                                    if (result is String) {
                                      // CHANGED: cek apakah result adalah error message (String)
                                      setState(() {
                                        error =
                                            result; // CHANGED: tampilin pesan error yang datang dari auth.dart
                                        loading = false;
                                      });
                                    } else if (result != null) {
                                      // CHANGED: result bukan String dan bukan null = sukses (User object)
                                      setState(() => loading = false);
                                      debugPrint(
                                        'mounted check: $mounted',
                                      ); // ADDED: buat ngecek race condition
                                      if (mounted) {
                                        widget.toggleView(fromRegister: true);
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            error,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Sudah punya akun?',
                                style: TextStyle(
                                  color: Color(0xFF837E93),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 2.5),
                              InkWell(
                                onTap: () => widget.toggleView(),
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    color: Color(0xFF393939),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // CHANGED: 50 -> dihitung dari systemNavInset, biar teks ga ketutup navbar HP
                          // 24 tetep dipertahanin sebagai jarak "nafas" minimal, sama kaya di bottomnavbar.dart
                          SizedBox(height: 24 + systemNavInset),
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
