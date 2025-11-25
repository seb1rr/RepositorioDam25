import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_dam/Pages/AddEvento.dart';
import 'package:proyecto_dam/Pages/Eventos.dart';
import 'package:proyecto_dam/Pages/HomePage.dart';
import 'package:proyecto_dam/Pages/Login.dart';

import 'package:proyecto_dam/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // RUTAS GLOBALES
      routes: {"/home": (context) => const HomePage(), "/login": (context) => const LoginPage(), "/agregar_evento": (context) => const AddEventPage(), "/listar_eventos": (context) => const ListarEventosPage()},

      // CONTROL DE SESIÓN
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasData && snapshot.data != null) {
            return const HomePage();
          }

          return const LoginPage();
        },
      ),
    );
  }
}
