import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_screen.dart';
import 'add_musee_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List musees = [];
  int offset = 0;
  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMusees();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent * 0.8) {

        if (!isLoading) {
          fetchMusees();
        }
      }
    });
  }

  Future fetchMusees() async {
    isLoading = true;

    final response = await http.get(
      Uri.parse(
          "http://192.168.61.1/musee-api/public/index.php?action=visites&limit=10&offset=$offset"),
    );

    if (response.statusCode == 200) {
      List newData = json.decode(response.body);

      setState(() {
        musees.addAll(newData);
        offset += 10;
      });
    }

    isLoading = false;
  }

  Future refresh() async {
    musees.clear();
    offset = 0;
    await fetchMusees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Musées"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: musees.length,
          itemBuilder: (context, index) {

            final musee = musees[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(musee: musee),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(10),
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
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            musee['nom'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text("Date : ${musee['date_visite']}"),
                          Text("Prix : ${musee['prix']} €"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMuseeScreen(),
            ),
          );
          if (result == true) {
            fetchMusees();
          }
        },
        child: const Icon(Icons.add),
      ),


    );
  }
}