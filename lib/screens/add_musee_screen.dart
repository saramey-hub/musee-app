import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class AddMuseeScreen extends StatefulWidget {
  const AddMuseeScreen({super.key});

  @override
  State<AddMuseeScreen> createState() => _AddMuseeScreenState();
}

class _AddMuseeScreenState extends State<AddMuseeScreen> {

  final _formKey = GlobalKey<FormState>();

  final nomController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final prixController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  double? latitude;
  double? longitude;

  File? selectedImage;

  // 📍 Position
  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  // 📂 Ouvrir explorateur de fichiers
  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

  // 📤 Envoi
  Future<void> addMusee() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez choisir une image")),
      );
      return;
    }

    var uri = Uri.parse(
        "http://10.0.2.2/musee-api/public/index.php?action=create");

    var request = http.MultipartRequest('POST', uri);

    request.fields['nom'] = nomController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['date_visite'] = dateController.text;
    request.fields['prix'] = prixController.text;
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['contact_nom'] = contactController.text;
    request.fields['contact_email'] = emailController.text;

    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        selectedImage!.path,
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Musée ajouté avec succès")),
      );
      Navigator.pop(context, true);
    } else {
      print("Erreur upload");
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un musée")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (value) =>
                value!.isEmpty ? "Champ obligatoire" : null,
              ),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),

              // 📅 Date picker
              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Date de visite",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                    setState(() {
                      dateController.text = formattedDate;
                    });
                  }
                },
              ),

              TextFormField(
                controller: prixController,
                decoration: const InputDecoration(labelText: "Prix"),
                keyboardType: TextInputType.number,
              ),

              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(labelText: "Nom contact"),
              ),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email contact"),
              ),

              const SizedBox(height: 20),

              selectedImage != null
                  ? Image.file(selectedImage!, height: 150)
                  : const Text("Aucune image sélectionnée"),

              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Choisir une photo"),
              ),

              const SizedBox(height: 20),

              Text("Latitude: ${latitude ?? "Chargement..."}"),
              Text("Longitude: ${longitude ?? "Chargement..."}"),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: addMusee,
                child: const Text("Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}