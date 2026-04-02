import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video_model.dart';

class VideoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<VideoModel>> getVideos() {
    return _firestore.collection('videos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return VideoModel.fromFirestore(data, doc.id);
      }).toList();
    });
  }

  Future<void> likeVideo(String videoId) async {
    if (videoId.isEmpty) {
      print("Error: El ID del video está vacío");
      return;
    }

    try {
      // CAMBIO AQUÍ: de '_db' a '_firestore'
      await _firestore.collection('videos').doc(videoId).update({
        'likes': FieldValue.increment(1),
      });
      print("Firestore actualizado con éxito");
    } catch (e) {
      print("Error detallado en Firestore: $e");
    }
  }
}