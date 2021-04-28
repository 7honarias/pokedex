import 'package:flutter/material.dart';
import 'package:pokedex/mpokemon.dart';
import 'constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DbPokemon extends StatefulWidget {
  @override
  _DbPokemonState createState() => _DbPokemonState();
}

class _DbPokemonState extends State<DbPokemon> {
  ScrollController controller = ScrollController();
  var url = 'https://pokeapi.co/api/v2/pokemon?limit=2';
  List<ModelPokemon> data = <ModelPokemon>[];

  Future<List<ModelPokemon>> getPokeUrl() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body)['results'];
      var registros = <ModelPokemon>[];
      for (jsonResponse in jsonResponse) {
        registros.add(ModelPokemon.fromJson(jsonResponse));
      }
      print('Number of books about http: $registros.');
      return registros;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  getDataPoke(String urlPoke) async {
    var url = urlPoke;

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var name = jsonResponse['name'];
      var image = jsonResponse['sprites']['front_default'];
      var type = jsonResponse['types'][0]['type']['name'];
      POKE_DATA.add({'name': name, 'type': type, 'image': image});
      print('Number of books about http: $name.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  getPostsData() {
    data.forEach((element) {
      getDataPoke(element.url);
    });
    print('here');
    List<dynamic> responseList = POKE_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post["name"],
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post["type"],
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Image.network(
                  "${post["image"]}",
                  width: 150,
                  height: 160,
                )
              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPokeUrl().then((value) {
      setState(() {
        data.addAll(value);
      });
      getPostsData();
    });
    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Pokemons Found",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        if (topContainer > 0.5) {
                          scale = index + 0.5 - topContainer;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform: Matrix4.identity()..scale(scale, scale),
                            alignment: Alignment.bottomCenter,
                            child: Align(
                                heightFactor: 0.7,
                                alignment: Alignment.topCenter,
                                child: itemsData[index]),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
