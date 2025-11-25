import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido ${user?.displayName ?? 'Usuario'}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FOTO DEL USUARIO
            if (user?.photoURL != null) CircleAvatar(radius: 40, backgroundImage: NetworkImage(user!.photoURL!)),

            const SizedBox(height: 20),

            // CORREO
            Text(user?.email ?? "Correo no disponible", style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 40),

            // BOTÓN AGREGAR EVENTO
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/agregar_evento");
              },
              child: const Text("Agregar Evento"),
            ),

            const SizedBox(height: 15),

            // BOTÓN LISTAR EVENTOS
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/listar_eventos");
              },
              child: const Text("Ver Todos los Eventos"),
            ),
          ],
        ),
      ),
    );
  }
}
