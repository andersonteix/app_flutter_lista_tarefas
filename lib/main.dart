import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main(){
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _pegaTextoController = TextEditingController(); /** pega o texto digitado */

  List _criaLista = [] ;  /** lista para armazenar os dados */

  @override   /** função responsavel para carregar os dados salvos na lista no json no momento de abrir o app */
  void initState() {
    super.initState();

    _readData().then((data){  /** o uso do .then é utilizado para quando assim que retornar a string entrar dentro da função anonima */
      setState((){  /** atualiza a tela com os novos dados */
        _criaLista = jsonDecode(data);
      });
    });
  }

  void _addLista() {
    setState( () {  /** o setState --> é utilizado para reconstruir(atualizar) a tela quando aderir uma nova lista */
      Map<String, dynamic> novaLista = Map(); /** sempre usar dynamic para json */
      novaLista["title"] = _pegaTextoController.text;
      _pegaTextoController.text = "";
      novaLista["ok"] = false;

      _criaLista.add(novaLista);
      _saveData();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ), // AppBar
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(   /**  --> foi utlizado para nao dar overflow na coluna */
                  child: TextField(
                      controller: _pegaTextoController,
                      decoration: InputDecoration(
                        labelText: "Nova Tareva",
                        labelStyle: TextStyle(color: Colors.redAccent),
                      ), // InputDecoration
                  ) // TextField
                ), // Expanded
                RaisedButton(
                  color: Colors.redAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addLista,
                ) // RaisedButton
              ], // <Widget>[]
            ), // Row
          ), // Container
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0,),
                  itemCount: _criaLista.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                       title: Text( _criaLista[index]["title"]),
                       value: _criaLista[index]["ok"],
                       secondary: CircleAvatar(
                         child: Icon(_criaLista[index]["ok"] ? Icons.check : Icons.error),
                       ),
                       onChanged: (c){  /** onChanged --> é utilizado para abilitar o ckeckbox ou item clicavel */
                         setState(() {  /** o setState --> é utilizado para abilitar o estado e funcionalidade do ckeckbox */
                           _criaLista[index]["ok"] = c;
                           _saveData();
                         });
                       },
                     ); // CheckboxListTile
                  }, // itemBuilder
              ), // ListView.builder
          ), // Expended
        ],
      ), // Column
    ); // Scaffold
  } // <Widget>[]

  // Retorna diretorio para salvar o arquivo json
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  // Retorna o arquivo utilizado para salvar os dados
  Future<File> _saveData() async {
    String data = json.encode(_criaLista);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  // Ler os dados
  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e){
      return null;
    }
  }
}

