class Visite {
  final int id;
  final String nom;
  final String description;
  final String dateVisite;
  final double prix;
  final String latitude;
  final String longitude;
  final String contactNom;
  final String contactEmail;
  final String photo;

  Visite({
    required this.id,
    required this.nom,
    required this.description,
    required this.dateVisite,
    required this.prix,
    required this.latitude,
    required this.longitude,
    required this.contactNom,
    required this.contactEmail,
    required this.photo,
  });

  factory Visite.fromJson(Map<String, dynamic> json) {
    return Visite(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      dateVisite: json['date_visite'],
      prix: (json['prix'] as num).toDouble(),
      latitude: json['latitude'],
      longitude: json['longitude'],
      contactNom: json['contact_nom'],
      contactEmail: json['contact_email'],
      photo: json['photo'],
    );
  }
}