import 'package:flutter/material.dart';
import 'package:caeli/ui/colors.dart';


class ChangeCity extends StatefulWidget {
  final _cityFieldController = new TextEditingController();
  @override
  ChangeCityState createState() {
    return new ChangeCityState();
  }
}

class ChangeCityState extends State<ChangeCity> {
  final _formKey = new GlobalKey<FormState>();
  String _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Caeli',
          style: TextStyle(fontFamily: 'Comfortaa-Regular'),
        ),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [gradientEnd, gradientStart],
                  begin: FractionalOffset(0.5, 0.0),
                  end: FractionalOffset(0.5, 0.7),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              ListTile(
                title: Form(
                  key: _formKey,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    autocorrect: true,
                    key: new Key('_city'),
                    initialValue: _city,
                    validator: (val) =>
                    val.isEmpty ? 'Darf nicht leer sein.' : null,
                    decoration: new InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Bitte eine Stadt eingeben',
                      border: OutlineInputBorder(),
                    ),
                    controller: widget._cityFieldController,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                  ),
                ),
              ),
              ListTile(
                title: FlatButton.icon(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.pop(context,
                            {'enter': widget._cityFieldController.text});
                      }
                    },
                    label: Text('Bestätigen',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Comfortaa-Regular',
                            fontSize: 20.0)),
                    icon: Icon(
                      Icons.cloud,
                      color: Colors.white,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}

