import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'package:caeli/util/utils.dart' as util;
import 'package:http/http.dart' as http;
import 'package:caeli/ui/second_screen.dart';

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
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
    ]);
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
          Container(
            child: updateTempWidget(_cityEntered),
            margin: const EdgeInsets.only(bottom: 160.0),
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
        // set defaultCity when app is loaded
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          // Code 404: City not found
          if (snapshot.hasData && snapshot.data['cod'].toString() != '404') {
            // content is all the info of the json
            Map content = snapshot.data;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Image.asset(
//                  'images/sunny.png',
//                  height: 200.0,
//                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(60.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${content['main']['temp'].round().toString()}°",
                          style: TextStyle(
                              fontFamily: 'Comfortaa-Regular',
                              fontSize: 40.0,
                              color: Colors.white),
                        ),
                        Text(
                          '${_cityEntered == null
                                ? util.defaultCity
                                : _cityEntered}, ${content['sys']['country']}',
                          style: TextStyle(
                              fontFamily: 'Comfortaa-Regular',
                              fontSize: 40.0,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                "Min: ${content['main']['temp_min'].toString()}°",
                                style: TextStyle(
                                    fontFamily: 'Comfortaa-Regular',
                                    color: Colors.white),
                              ),
                              Text(
                                "Max: ${content['main']['temp_max'].toString()}°",
                                style: TextStyle(
                                    fontFamily: 'Comfortaa-Regular',
                                    color: Colors.white),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 300.0),
                  Center(
                    child: Text(
                      'Stadt nicht gefunden \n\n'
                          'Bitte neue Suchabfrage starten',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Questrial-Regular',
                        fontSize: 20.0,
                      ),
                    ),
                  )
                ]);
          }
        });
  }
}
