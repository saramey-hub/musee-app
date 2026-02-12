import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Musee App"),
      ),
      body: const Center(
        child: Text(
          "Connexion OK",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
