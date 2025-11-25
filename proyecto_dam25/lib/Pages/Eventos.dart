import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListarEventosPage extends StatelessWidget {
  const ListarEventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String uidActual = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Eventos")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("eventos").orderBy("fecha", descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final eventos = snapshot.data!.docs;

          if (eventos.isEmpty) {
            return const Center(child: Text("No hay eventos publicados"));
          }

          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              var evento = eventos[index];
              var data = evento.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  title: Text(data["titulo"] ?? "Sin título"),
                  subtitle: Text(
                    "Lugar: ${data["lugar"]}\n"
                    "Fecha: ${data["fecha"].toDate()}",
                  ),

                  // Mostrar eliminar SOLO si el evento pertenece al usuario actual
                  trailing: data["autorUid"] == uidActual
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmarEliminacion(context, evento.id);
                          },
                        )
                      : null,

                  onTap: () {
                    // Puedes hacer después el detalle de evento
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmarEliminacion(BuildContext context, String idEvento) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: const Text("¿Estás seguro de eliminar este evento?"),
          actions: [
            TextButton(child: const Text("Cancelar"), onPressed: () => Navigator.pop(context)),
            TextButton(
              child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await FirebaseFirestore.instance.collection("eventos").doc(idEvento).delete();

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
