import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_http/offices.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Networking',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<OfficesList> officesList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serialization'),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder<OfficesList>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('${snapshot.data?.offices[index].name}'),
                      subtitle:
                          Text('${snapshot.data?.offices[index].address}'),
                      leading: Image.network(
                          '${snapshot.data?.offices[index].image}'),
                      isThreeLine: true,
                    ),
                  );
                },
                itemCount: snapshot.data?.offices.length,
              );
            } else if (snapshot.hasError) {
              return Text('Error');
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          future: officesList,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    officesList = getOfficesList();
  }
}

Future<http.Response> getData() async {
  const url = 'https://about.google/static/data/locations.json';
  return await http.get(Uri.parse(url));
}

void loadData() {
  getData().then((response) {
    if (response.statusCode == 200) {
      log('response body:');
      log(response.body);
    } else {
      log('error section body');
      log('${response.statusCode}');
    }
  }).catchError((error) {
    log('error section body');
    debugPrint(error.toString());
  });
}
