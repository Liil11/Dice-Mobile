import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../widgets/custom_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 1. Buat Controller untuk menangkap input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Loading state
  bool _isLoading = false;

  // 2. Fungsi Register
  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);
    
    try {
      // Buat user di Firebase
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Update Username (Display Name)
      await userCredential.user?.updateDisplayName(_usernameController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil Mendaftar! Silakan Login.")),
        );
        Navigator.pop(context); // Kembali ke halaman Login
      }
    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan";
      if (e.code == 'weak-password') message = "Password terlalu lemah.";
      if (e.code == 'email-already-in-use') message = "Email sudah terdaftar.";
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF38383D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image (sama seperti sebelumnya)
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                'https://i.pinimg.com/originals/e8/1a/3f/e81a3f7737df6d795fb2b3b71900d720.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.grid_view, size: 50, color: Colors.black87),
                  const SizedBox(height: 10),
                  Text('DICE & DICE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Serif')),
                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Pasang Controller ke Widget CustomInput
                        CustomInput(label: "Username", controller: _usernameController),
                        const SizedBox(height: 20),
                        CustomInput(label: "Email", controller: _emailController),
                        const SizedBox(height: 20),
                        CustomInput(label: "Password", controller: _passwordController, isPassword: true),
                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister, // Disable jika loading
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white) 
                                : const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        // ... (Sisa kode Footer "Or" & "Have an account" sama seperti sebelumnya)
                         Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Have an account? ",
                              style: const TextStyle(color: Colors.black87, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}