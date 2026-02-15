import 'package:flutter/material.dart';
import '../models/visite.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Visite>> visites;

  @override
  void initState() {
    super.initState();
    visites = ApiService.fetchVisites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Musées")),
      body: FutureBuilder<List<Visite>>(
        future: visites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune visite trouvée"));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final visite = data[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(
                    "http://10.0.2.2/site-admin/public/uploads/${visite.photo}",
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(visite.nom),
                  subtitle: Text("${visite.dateVisite} - ${visite.prix} €"),
                  onTap: () {

                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}