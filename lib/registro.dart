import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:relacionales/ciudades.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Registro extends StatefulWidget {
  const Registro({Key? key}) : super(key: key);

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  @override
  Widget build(BuildContext context) {

    var c_nombre = new TextEditingController();
    var c_correo = new TextEditingController();
    var c_pass = new TextEditingController();

    String? nombre;
    String? correo;
    String? pass;

    Future<void> registrarme() async {
      var url = Uri.parse('https://www.fictionsearch.net/relacionalesDB/registro.php');

      var response = await http.post(url, body: {
        'nombre' : nombre,
        'correo' : correo,
        'pass' : pass,
      }).timeout(Duration(seconds: 90));

      var respuesta = jsonDecode(response.body);

      print(respuesta);

      if (respuesta['respuesta'] == '1'){
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('id', respuesta['id'].toString());

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context){
              return Ciudades();
            }
        ));
      }else {
        print(respuesta['respuesta']);
      }

    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.all(30),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Usuario'
                  ),
                  controller: c_nombre,
                ),
                SizedBox(height: 15,),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Correo'
                  ),
                  controller: c_correo,
                ),
                SizedBox(height: 15,),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  controller: c_pass,
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                    onPressed: (){
                      nombre = c_nombre.text;
                      correo = c_correo.text;
                      pass = c_pass.text;

                      if (nombre == '' || correo == '' || pass == '') {
                        print('Debes de llenar todos los datos');
                      }else {
                        registrarme();
                      }
                    },
                    child: Text('Registrame'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
