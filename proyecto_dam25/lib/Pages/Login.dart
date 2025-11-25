import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<User?> signInWithGoogle() async {
    try {
      // Seleccionar cuenta Google
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) return null;

      // Obtener credenciales
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      // Enviar credencial a Firebase
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      debugPrint("ERROR LOGIN GOOGLE: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
          onPressed: () async {
            final user = await signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacementNamed(context, "/home");
            }
          },
          child: const Text("Iniciar sesión con Google", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
