import 'package:flutter/material.dart';
import 'package:pokeapp/pokemon.dart';

class PokeDetail extends StatelessWidget {
  final Pokemon pokemon;

  PokeDetail(this.pokemon);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.cyan,
        title: Text(pokemon.name),
      ),
      body: bodyWidget(context),
    );
  }

  bodyWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height/1.5,
          width: MediaQuery.of(context).size.width-20,
          left: 10.0,
          top: MediaQuery.of(context).size.height*0.15,
          child: Container(
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 50.0,),
                Text(pokemon.name,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                Text("Height : ${pokemon.height}"),
                Text("Weight : ${pokemon.weight}"),
                Text("Types",style: TextStyle(fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: pokemon.type
                      .map((type) => FilterChip(
                          backgroundColor: Colors.amberAccent,
                          label: Text(type),
                          onSelected: (val) {}))
                      .toList(),
                ),
                Text("Weakness",style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: pokemon.weaknesses
                      .map((weakness) => FilterChip(
                          backgroundColor: Colors.redAccent,
                          label: Text(
                            weakness,
                            style: TextStyle(color: Colors.white),
                          ),
                          onSelected: (val) {}))
                      .toList(),
                ),
                Text("Next Evolution",style: TextStyle(fontWeight: FontWeight.bold)),
                pokemon.nextEvolution==null?
                Center(child: FilterChip(
                    backgroundColor: Colors.greenAccent,
                    label: Text("None"), onSelected: (val) {}))
                    :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: pokemon.nextEvolution
                      .map((pokemons) => FilterChip(
                      backgroundColor: Colors.greenAccent,
                      label: Text(pokemons.name),
                      onSelected: (val) {}))
                      .toList(),
                )
              ],
            ),
          ),
        )),
        Align(
          alignment: Alignment.topCenter,
          child: Hero(tag: pokemon.img, child: Container(
            height: 150.0,
            width: 150.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(pokemon.img))
            ),
          )),
        )
      ],
    );
  }
}
