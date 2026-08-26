import 'package:flutter/material.dart';
import 'package:rumi/services/auth.dart';
import 'package:rumi/shared/loading.dart';
import 'package:rumi/shared/constants.dart';

class SignIn extends StatefulWidget {
  final VoidCallback toggleView;
  final bool showSuccessPopup;

  const SignIn({
    super.key,
    required this.toggleView,
    this.showSuccessPopup = false,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';
  bool _obscurePassword = true; // ADDED: state untuk show/hide password

  @override
  void initState() {
    super.initState();
    // ADDED: kalau masuk dari register, tunjukin popup sukses setelah frame pertama render
    if (widget.showSuccessPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSuccessDialog();
      });
    }
  }

  @override
  void didUpdateWidget(covariant SignIn oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint(
      'didUpdateWidget — showSuccessPopup: ${widget.showSuccessPopup}, old: ${oldWidget.showSuccessPopup}',
    );
    // ADDED: initState ga re-run saat widget di-rebuild, jadi pakai didUpdateWidget
    // fires tiap kali parent kirim props baru, termasuk saat toggleView dari register
    if (widget.showSuccessPopup && !oldWidget.showSuccessPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSuccessDialog();
      });
    }
  }

  void _showSuccessDialog() {
    const brand = Color.fromARGB(255, 144, 121, 84);

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) Navigator.of(context).pop();
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFDF8F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8D5B7), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: brand,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Registrasi Berhasil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF363434),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Akun kamu berhasil dibuat.\nSilakan login untuk melanjutkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      fontFamily: 'Poppins',
                      color: Color(0xFF363434),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showForgotPasswordDialog() {
    // controller khusus buat dialog ini, biar ga nyampur sama login form
    final resetEmailController = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();
    bool isSending = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (dialogContext) {
        return StatefulBuilder(
          // StatefulBuilder biar bisa setState di dalam dialog (loading state)
          builder: (dialogContext, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF8F2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE8D5B7),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: dialogFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Color(0xFF393939),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Masukkan email akunmu, kami akan kirim link reset.',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontFamily: 'Poppins',
                          color: Colors.grey.shade500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: resetEmailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Color(0xFF393939),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF837E93),
                            ),
                          ),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Masukkan email'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF393939),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: isSending
                              ? null // disable tombol pas lagi loading
                              : () async {
                                  if (!(dialogFormKey.currentState
                                          ?.validate() ??
                                      false))
                                    return;
                                  setDialogState(() => isSending = true);

                                  final String? errorMsg = await _auth
                                      .sendPasswordResetEmail(
                                        resetEmailController.text.trim(),
                                      );

                                  if (!dialogContext.mounted) return;
                                  Navigator.of(
                                    dialogContext,
                                  ).pop(); // tutup dialog

                                  if (errorMsg != null) {
                                    // tampil error di sign in screen
                                    setState(() => error = errorMsg);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Link reset dikirim ke ${resetEmailController.text.trim()}',
                                        ),
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          144,
                                          121,
                                          84,
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF363434),
                                  ),
                                )
                              : const Text(
                                  'Kirim Link Reset',
                                  style: TextStyle(
                                    color: Color(0xFF363434),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ADDED: sama kayak register.dart
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
                    padding: const EdgeInsets.only(left: 10, top: 30),
                    child: SizedBox(
                      // ADDED: kasih ukuran box eksplisit yang cukup gede buat nampung badge yang overflow,
                      // biar hit-test area-nya juga ikut segede itu, ga cuma segede gambar doang
                      width:
                          478, // 413 (lebar gambar) + 65 (overflow badge ke kiri)
                      height: 457,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            "assets/images/vector-1.png",
                            width: 413,
                            height: 457,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Log In',
                            style: TextStyle(
                              color: Color(0xFF363434),
                              fontSize: 27,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
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
                                ? 'Enter an email'
                                : null,
                            onChanged: (val) => setState(() => email = val),
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
                                ? 'Enter a password with at least 6 characters'
                                : null,
                            onChanged: (val) => setState(() => password = val),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _showForgotPasswordDialog,
                              child: const Text(
                                'Lupa Password?',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 144, 121, 84),
                                  fontSize: 12.5,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // sign in button
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
                                  'Sign In',
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
                                        .signInWithEmailAndPassword(
                                          email,
                                          password,
                                        );
                                    if (result == null) {
                                      setState(() {
                                        error =
                                            'Could not sign in with those credentials';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
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
                                'Don\'t have an account?',
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
                                  'Sign Up',
                                  style: TextStyle(
                                    color: const Color(0xFF363434),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // CHANGED: 15 -> dihitung dari systemNavInset, sama alasannya kaya register.dart
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
