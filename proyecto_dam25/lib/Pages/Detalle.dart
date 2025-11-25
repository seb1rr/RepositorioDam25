import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetalleEventoPage extends StatelessWidget {
  final String eventoId;

  const DetalleEventoPage({super.key, required this.eventoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle del Evento")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("eventos").doc(eventoId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection("categorias").doc(data["categoria"]).get(),
            builder: (context, catSnap) {
              if (!catSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // SI LA CATEGORÍA NO EXISTE → evitar crash
              if (catSnap.data == null || catSnap.data!.data() == null) {
                return const Center(child: Text("Categoría no encontrada"));
              }

              final categoriaData = catSnap.data!.data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    // FOTO DE CATEGORÍA
                    Image.asset("assets/images/${categoriaData['foto']}", height: 180, fit: BoxFit.cover),

                    const SizedBox(height: 20),

                    Text("Título:", style: estiloTitulo),
                    Text(data["titulo"], style: estiloTexto),

                    const SizedBox(height: 20),

                    Text("Lugar:", style: estiloTitulo),
                    Text(data["lugar"], style: estiloTexto),

                    const SizedBox(height: 20),

                    Text("Fecha:", style: estiloTitulo),
                    Text(data["fecha"].toDate().toString(), style: estiloTexto),

                    const SizedBox(height: 20),

                    Text("Categoría:", style: estiloTitulo),
                    Text(categoriaData["nombre"], style: estiloTexto),

                    const SizedBox(height: 20),

                    Text("Autor:", style: estiloTitulo),
                    Text(data["autor"], style: estiloTexto),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  TextStyle get estiloTitulo => const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle get estiloTexto => const TextStyle(fontSize: 16);
}
