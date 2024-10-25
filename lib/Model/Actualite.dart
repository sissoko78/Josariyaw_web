
class Actualite{
  String id;
  String description;
  String image;

  Actualite({
 required this.id,
 required this.description,
 required this.image
}
);
  factory Actualite.fromFirestore(Map<String, dynamic>data, String id){
    return Actualite(
        id: id,
        description: data['description'] ?? '',
        image: data['image'] ?? '');
  }

  Map<String, dynamic> Tofirestore(){
    return {'description': description,
      'image': image};

  }

}