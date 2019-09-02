import 'dart:convert';

import 'package:abiapp/detay.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AbiSatisApp',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'ABI.SHOP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final urunAdiController = new TextEditingController();
  final urunAciklamasiController = new TextEditingController();
  final urunFiyatiController = new TextEditingController();
  final urunAdediController = new TextEditingController();

  final String uri = 'https://abiteam.azurewebsites.net/api/urun';

  Future<List<Urun>> _fetchUsers() async {
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Urun> listOfUrun = items.map<Urun>((json) {
        return Urun.fromJson(json);
      }).toList();

      return listOfUrun;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TÜM ÜRÜNLER'),
        ),
        body: FutureBuilder<List<Urun>>(
          future: _fetchUsers(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return ListView(
              children: snapshot.data
                  .map((urun) => ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetaySayfasi(
                                        urun: urun,
                                      )));
                        },
                        title: Text(urun.urunAdi),
                        subtitle: Text(urun.urunFiyati.toString()),
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo,
                          child: Text(urun.urunAdi,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              )),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Theme(
                                data: new ThemeData(
                                    primaryColor: Colors.red,
                                    primaryColorDark: Colors.redAccent),
                                child: TextFormField(
                                  controller: urunAdiController,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.red,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: "Ürün Adı",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(32)),
                                  ),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Theme(
                                data: new ThemeData(
                                    primaryColor: Colors.red,
                                    primaryColorDark: Colors.redAccent),
                                child: TextFormField(
                                  controller: urunAciklamasiController,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.red,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: "Ürün Açıklaması",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(32)),
                                  ),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Theme(
                                data: new ThemeData(
                                    primaryColor: Colors.red,
                                    primaryColorDark: Colors.redAccent),
                                child: TextFormField(
                                  controller: urunAdediController,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.red,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: "Ürün Adedi",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(32)),
                                  ),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Theme(
                                data: new ThemeData(
                                    primaryColor: Colors.red,
                                    primaryColorDark: Colors.redAccent),
                                child: TextFormField(
                                  controller: urunFiyatiController,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.red,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: "Ürün Fiyatı",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(32)),
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text("Yeni Ürün Oluştur",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              onPressed: () {
                                
                                print(urunFiyatiController.text);
                                if (urunAdiController.text != null &&
                                    urunAciklamasiController.text != null &&
                                    urunAdediController.text != null &&
                                    urunFiyatiController.text != null) {
                                  createUrun(
                                      urunAdiController.text.toString(),
                                      urunAciklamasiController.text.toString(),
                                      
                                          urunAdediController.text.toString(),
                                      urunFiyatiController.text.toString()
                                         );
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
          tooltip: 'Increment',
          child: Icon(Icons.add)
        ));
  }

  void createUrun(
      String urunAdi, String urunAciklamasi, String urunAdedi, String urunFiyati) {
    var body ={
      "urunAdi": urunAdi,
      "urunAciklamasi": urunAciklamasi,
      "urunAdedi": int.parse(urunAdedi),
      "urunFiyati": double.parse(urunFiyati)
    };
    var uri="https://abiteam.azurewebsites.net/api/urun";
    try {
      http.put(uri,
      body: body).then((response){
        var result = json.decode(response.body);
        print("oldu");
        print(result);
      });
      
    } catch(e) {
      print("Hata");
    }
  }
}

class Urun {
  int id;
  String urunAdi;
  String urunAciklamasi;
  int urunAdedi;
  double urunFiyati;

  Urun({
    this.id,
    this.urunAdi,
    this.urunAciklamasi,
    this.urunAdedi,
    this.urunFiyati,
  });
  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      id: json['id'],
      urunAdi: json['urunAdi'],
      urunAciklamasi: json['urunAciklamasi'],
      urunAdedi: json['urunAdedi'],
      urunFiyati: json['urunFiyati'],
    );
  }
}
