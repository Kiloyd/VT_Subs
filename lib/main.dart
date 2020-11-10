import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Liver {
  final String id;
  final String group;
  final String title;
  final String status;

  Liver({this.status, this.id, this.group, this.title});

  factory Liver.fromJson(Map<String, dynamic> json) {
    print(json.keys);
    return Liver(
      id: json['id'],
      title: json['title'],
      group: json['group'],
      status: json['status'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyStatefulWidget();
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

Future<List<Liver>> fetchLive() async {
  final response = await http.get("https://api.chooks.app/live");
  final liveJson = jsonDecode(response.body)['live'];
  final List<Liver> liverList = [];

  if (response.statusCode == 200) {
    for (var i in liveJson) {
      print(Liver.fromJson(i).title);
      liverList.add(Liver.fromJson(i));
    }
    return liverList;
  } else {
    throw Exception('Failed to load liver');
  }
}

void refresh_press() {
  print("refresh the page");
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Future<List<Liver>> _liverList;
  @override
  void initState() {
    _liverList = fetchLive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("start build the mat app");
    return MaterialApp(
      title: 'fetch test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Now Live'),
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh), onPressed: refresh_press)
          ],
        ),
        body: Center(
          child: FutureBuilder<List<Liver>>(
            future: _liverList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.all(5),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: FlutterLogo(
                        size: 40,
                      ),
                      title: Text(snapshot.data[index].id),
                      subtitle: Text(snapshot.data[index].group),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
