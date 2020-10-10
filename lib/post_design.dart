class Post {
  String catName;
  String location;
  int value;
  String name;

  Post({this.catName, this.location, this.value, this.name});

  void addPost({String text, String catNames}) {
    var updatePost = new Post(location: text, catName: catNames);
    posts.add(updatePost);
  }
}

class CatNameList {
  int value;
  String name;

  CatNameList(this.value, this.name);
}

List<Post> posts = [];
