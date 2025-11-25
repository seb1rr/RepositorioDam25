import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController tituloCtrl = TextEditingController();
  final TextEditingController fechaCtrl = TextEditingController();
  final TextEditingController lugarCtrl = TextEditingController();

  DateTime? fechaSeleccionada;
  String? categoriaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Evento")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Titulo
              TextFormField(
                controller: tituloCtrl,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) => value!.isEmpty ? "Ingrese un título" : null,
              ),

              const SizedBox(height: 15),

              // FECHA CON DATEPICKER
              TextFormField(
                controller: fechaCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Fecha y hora", suffixIcon: Icon(Icons.calendar_today)),
                validator: (value) => fechaSeleccionada == null ? "Seleccione fecha" : null,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // oculta teclado

                  final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));

                  if (picked != null) {
                    final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());

                    if (time != null) {
                      final dt = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);

                      setState(() {
                        fechaSeleccionada = dt;
                        fechaCtrl.text = DateFormat("dd/MM/yyyy HH:mm").format(dt);
                      });
                    }
                  }
                },
              ),

              const SizedBox(height: 15),

              // LUGAR
              TextFormField(
                controller: lugarCtrl,
                decoration: const InputDecoration(labelText: "Lugar"),
                validator: (value) => value!.isEmpty ? "Ingrese un lugar" : null,
              ),

              const SizedBox(height: 15),

              // CATEGORIAS DESDE FIRESTORE
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("categorias").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final categorias = snapshot.data!.docs;

                  return DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: "Categoría"),
                    items: categorias.map((c) {
                      return DropdownMenuItem(value: c.id, child: Text(c["nombre"]));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => categoriaSeleccionada = value.toString());
                    },
                    validator: (value) => value == null ? "Seleccione una categoría" : null,
                  );
                },
              ),

              const SizedBox(height: 25),

              ElevatedButton(onPressed: guardarEvento, child: const Text("Guardar Evento")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> guardarEvento() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection("eventos").add({
      "titulo": tituloCtrl.text,
      "fecha": Timestamp.fromDate(fechaSeleccionada!), // <--- SOLO ESTA FECHA
      "lugar": lugarCtrl.text,
      "categoria": categoriaSeleccionada,
      "autor": user?.email,
      "autorUid": user?.uid,
    });

    Navigator.pop(context);
  }
}
