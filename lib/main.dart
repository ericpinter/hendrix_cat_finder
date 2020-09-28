import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      title: "Hendrix Cat Finder",
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //IS there a list of cat names somewhere????
  List<CatNameList> _dropdownlistofcats = [
    CatNameList(1, "Cat 1"),
    CatNameList(2, "cat 2"),
    CatNameList(3, "cat 3"),
    CatNameList(4, "cat 4")
  ];

  List<DropdownMenuItem<CatNameList>> _dropdownMenuOfCats;
  CatNameList _selectedCat;

  void initState() {
    super.initState();
    _dropdownMenuOfCats = buildDropDownMenuItems(_dropdownlistofcats);
    _selectedCat = _dropdownMenuOfCats[0].value;
  }

  List<DropdownMenuItem<CatNameList>> buildDropDownMenuItems(List CatNames) {
    List<DropdownMenuItem<CatNameList>> items = List();
    for (CatNameList Cat in CatNames) {
      items.add(
        DropdownMenuItem(
          child: Text(Cat.name),
          value: Cat,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hendrix Cat Finder"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            tooltip: "Create a Post",
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: "Add a Friend",
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 5.0),
              ),
              child: DropdownButton(
                  value: _selectedCat,
                  items: _dropdownMenuOfCats,
                  onChanged: (value) {
                    setState(() {
                      _selectedCat = value;
                    });
                  }),
            ),
          ),
          Text(" ${_selectedCat.name}"),
        ],
      ),
    );
  }
}

class CatNameList {
  int value;
  String name;

  CatNameList(this.value, this.name);
}
