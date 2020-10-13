class Cat {
  final int id;
  final String catName;
  final String catLocation;
  final String catRating;

  Cat({this.id, this.catName, this.catLocation, this.catRating});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catName': catName,
      'catLocation': catLocation,
      'catRating': catRating
    };
  }

  factory Cat.fromMap(Map<String, dynamic> data) => Cat(
      id: data['id'],
      catName: data['catName'],
      catLocation: data['catLocation'],
      catRating: data['catRating']);
}
