import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:caeli/util/utils.dart' as util;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class Caeli extends StatefulWidget {
  @override
  _CaeliState createState() => _CaeliState();
}

class _CaeliState extends State<Caeli> {
  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator
        .of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new ChangeCity();
    }));

    if (results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];
    }
  }

  showInfo() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data['weather'][0]['main']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        title: Text("Caeli", style: TextStyle(fontFamily: 'Comfortaa-Regular')),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _goToNextScreen(context);
              }),
          new IconButton(
              icon: Icon(Icons.refresh),
              //TODO: implement refresh function
              onPressed: () => print("test"))
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [gradientStart, gradientEnd],
                  begin: FractionalOffset(0.5, 0.0),
                  end: FractionalOffset(0.5, 0.7),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //TODO: Show images of the weather
            ],
          ),
          Container(
            child: updateTempWidget(_cityEntered),
            margin: const EdgeInsets.only(bottom: 120.0),
          ),
          Center(
            child: new Text(
              '${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: TextStyle(
                  fontFamily: 'Comfortaa-Regular',
                  fontSize: 40.0,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appId=${util.appId}&units=metric";

    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData && snapshot.data['cod'].toString() != '404') {
            // content is all the info of the json
            Map content = snapshot.data;

            return ListTile(
              title: Center(
                child: Text(
                  "${content['main']['temp'].round().toString()}°",
                  style: TextStyle(
                      fontFamily: 'Comfortaa-Regular',
                      fontSize: 40.0,
                      color: Colors.white),
                ),
              ),
              subtitle: new ListTile(
                title: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        "Min: ${content['main']['temp_min'].toString()}°            "
                            "Max: ${content['main']['temp_max'].toString()}°",
                        style: TextStyle(
                            fontFamily: 'Comfortaa-Regular',
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 300.0),
                  Text(
                    'Stadt nicht gefunden',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Questrial-Regular',
                      fontSize: 20.0,
                    ),
                  )
                ]);
          }
        });
  }
}

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
