import 'package:flutter/material.dart';
import 'package:nvcti/presentation/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // UI State
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsive illustration
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Home"), // Matches the "Home" title in screenshot
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
                height: size.height * 0.3, // Takes 30% of screen height
                child: Image.asset(
                  'assets/logos/iv_login.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 2. Title Section
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Please login to continue",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 30),

            // 3. Input Fields
            CustomTextField(
              hintText: "Institute Email",
              prefixIcon: Icons.mail_outline,
              controller: _emailController,
            ),

            CustomTextField(
              hintText: "Password",
              prefixIcon: Icons.lock_outline,
              isPassword: !_isPasswordVisible, // Toggle visibility
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

            // 4. Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to Forgot Password
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 5. Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Trigger Login UseCase via BLoC/Provider here
                  print("Login Attempt: ${_emailController.text}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF1565C0,
                  ), // AppTheme.primaryBlue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 6. Sign Up Link
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Sign Up
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom padding to ensure scrollability on small screens
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
