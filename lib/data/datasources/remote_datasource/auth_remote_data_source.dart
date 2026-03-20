import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSource({required this.firebaseAuth});

  Future<void> login(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Block login if email is not verified
      if (credential.user != null && !credential.user!.emailVerified) {
        // Sign them back out so they can't access the app
        await firebaseAuth.signOut();
        throw Exception('email-not-verified');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseErrorCode(e.code));
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String mobileNumber,
  ) async {
    try {
      // 1. Create the user in Firebase Auth
      UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);

      // 2. Send email verification
      await credential.user?.sendEmailVerification();

      // 3. Extract admission number from email (e.g., "20JE0000@iitism.ac.in" -> "20JE0000")
      String admissionNumber = email.split('@').first.toUpperCase();

      // 4. Save extra user details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
            'userName': name,
            'userEmail': email,
            'userContact': mobileNumber,
            'userAdmNo': admissionNumber,
            'emailVerified': false,
          });

      // 5. Sign out immediately — user must verify email before logging in
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      print("🔥 FIREBASE REGISTER ERROR CODE: ${e.code}");
      throw Exception(_mapFirebaseErrorCode(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  // Helper method to convert Firebase errors into readable text
  String _mapFirebaseErrorCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'email-not-verified':
        return 'Please verify your email before logging in. Check your inbox.';
      default:
        return 'An undefined Error happened. Please try again.';
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseErrorCode(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> resendVerificationEmail(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null && !credential.user!.emailVerified) {
        await credential.user!.sendEmailVerification();
        await firebaseAuth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseErrorCode(e.code));
    }
  }
}
