import 'package:flutter/material.dart';
import 'package:nvcti/presentation/common/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // UI State
  bool _isPasswordVisible = false;

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Home"), // Matches the screenshot header
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 1. Illustration Area
            Center(
              child: SizedBox(
                height:
                    size.height *
                    0.25, // Slightly smaller than login to fit more fields
                child: Image.asset(
                  'assets/logos/iv_sign.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 2. Title Section
            const Text(
              "Register",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Please register to login", // Typo in screenshot "Please register to login" kept as is, or fix to "to continue"
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 30),

            // 3. Form Fields
            CustomTextField(
              hintText: "Institute Email",
              prefixIcon: Icons.mail_outline,
              controller: _emailController,
            ),

            CustomTextField(
              hintText: "Password",
              prefixIcon: Icons.lock_outline,
              isPassword: !_isPasswordVisible,
              controller: _passwordController,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),

            CustomTextField(
              hintText: "Name",
              prefixIcon: Icons.person_outline,
              controller: _nameController,
              // Capitalize the first letter of sentences
              // textCapitalization: TextCapitalization.words,
            ),

            CustomTextField(
              hintText: "Mobile Number",
              prefixIcon: Icons
                  .phone_android_outlined, // Matches the phone icon in screenshot
              controller: _mobileController,
              // Ensure number pad pops up
              // keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 30),

            // 4. Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Trigger RegisterUser UseCase here
                  print("Registering: ${_emailController.text}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 5. Login Link
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ", // Typo "Alreadt" in screenshot fixed here
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Go back to Login
                    },
                    child: const Text(
                      "Log in",
                      style: TextStyle(
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
