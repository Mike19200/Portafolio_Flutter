class VideoModel {
  final String id; // Nuevo: Para identificar el doc en Firestore
  final String title;
  final String description;
  final String videoUrl;
  final int likes; // Nuevo: Para el contador

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.likes,
  });

  factory VideoModel.fromFirestore(Map<String, dynamic> data, String id) {
    return VideoModel(
      id: id,
      title: data['title'] ?? 'Sin título',
      description: data['description'] ?? 'sin descripcion',
      videoUrl: data['videoUrl'] ?? '',
      likes: int.tryParse(data['likes'].toString()) ?? 0,
    );
  }
}