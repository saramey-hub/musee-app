import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map musee;

  const DetailScreen({super.key, required this.musee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(musee['nom']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.network(
              "http://192.168.61.1/site-admin/public/uploads/${musee['photo']}",
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    musee['nom'],
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text("Date : ${musee['date_visite']}"),
                  Text("Prix : ${musee['prix']} €"),

                  const SizedBox(height: 15),

                  Text(musee['description']),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Réservation ajoutée !"),
                        ),
                      );
                    },
                    child: const Text("Réserver"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}