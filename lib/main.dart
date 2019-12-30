import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokedex/pokemon.dart';
import 'package:pokedex/pokemondetail.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'PokeDex',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(title: 'PokeDex'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var url = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async{
    var res = await http.get(url);
    var decodedJson= jsonDecode(res.body);

    pokeHub = PokeHub.fromJson(decodedJson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red,
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(widget.title),
      ),
      //drawer: new Drawer(),
      body: pokeHub == null?Center(child: CircularProgressIndicator(),): GridView.count(
        crossAxisCount: 2,
      children:pokeHub.pokemon.map((poke)=>
          Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => PokeDetail(
              pokemon: poke,
            )));
          },
          child: Hero(
            tag: poke.img,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('No. '+poke.num, style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),),
                  Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(poke.img),
                      ),
                    ),
                  ),
                  Text(poke.name, style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )).toList(),
      ),
      /*floatingActionButton: new FloatingActionButton(
        onPressed: (){},
        tooltip: 'Refresh',
        child: new Icon(Icons.refresh),
      ),*/
    );
  }
}
