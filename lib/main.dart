import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokeapp/pokemon.dart';
import 'package:pokeapp/pokemon_detail.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "PokeApp",
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  var url = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  PokeHub pokeHub;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    fetchData();
    _controller = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _showModalBottomSheet(BuildContext context){
      showModalBottomSheet(context: context, builder: (builder){
        return Container(
          height: 200,
          child: ListView(
            children: <Widget>[
              TabBar(labelColor: Colors.blue, controller: _controller, tabs: [
                Tab(
                  text: "Types",
                ),
              ]),
              Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: TabBarView(
                      controller: _controller,
                      children: [
                        getTypeList()
                      ]
                  )
              )
            ],
          ),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("PokeApp"),
        backgroundColor: Colors.cyan,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                pokeHub!=null?showSearch(context: context, delegate: PokeSearch(pokeHub.pokemon)):print("Nothing");
              }),
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                _showModalBottomSheet(context);
              }),
        ],
      ),
      body: pokeHub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: pokeHub.pokemon
                  .map(
                    (poke) => InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PokeDetail(poke);
                          }));
                        },
                        child: Hero(
                          tag: poke.img,
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Card(
                              elevation: 3.0,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 100.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(poke.img))),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    poke.name,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  )
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchData();
        },
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),
    );
  }

  void fetchData() async {
    var response = await http.get(url);
    var decodeJSON = jsonDecode(response.body);
    pokeHub = PokeHub.fromJson(decodeJSON);
//  print(response.body);
    setState(() {});
  }

  getTypeList() {
    var typeList=['Green','Fire','Water','Electric','Poison','Ghost','Ground','Dark','Psychic','Rock','Normal','Flying'];
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(typeList[index]),
          );
        },
        itemCount: typeList.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }
}

class PokeSearch extends SearchDelegate<String> {
  List<Pokemon> allPokemon;
  List<Pokemon> recentPokemon=List<Pokemon>();

  PokeSearch(List<Pokemon> allPokemon) {
    this.allPokemon = allPokemon;
    for (int i = 0; i < 5; i++) {
      recentPokemon.add(this.allPokemon[i]);
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query='';
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Pokemon> suggested=query.isEmpty?recentPokemon:allPokemon.where((poke)=>poke.name.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView.builder(itemBuilder: (context, index) {
      return ListTile(
        onTap: (){
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return PokeDetail(suggested[index]);
              }));
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(suggested[index].img),
        ),
        title: Text(
          suggested[index].name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    },
      itemCount: suggested.length,
      //itemCount: suggested.pokemon.length,);
    );
  }
}