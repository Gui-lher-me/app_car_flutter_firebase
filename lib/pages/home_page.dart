import 'package:app_car/auth/auth.dart';
import 'package:app_car/database/database.dart';
import 'package:app_car/pages/itinerary_page.dart';
import 'package:app_car/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  final String userID;

  HomePage({this.userID});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Color blue = Color(0xff006680);
  Color yellow = Color(0xffffdd55);

  Database database = Database();

  Auth auth = Auth();

  String userEmail;

  void getCurrentUserEmail() {
    try {
      auth.getcurrentUserEmail().then((v){
        setState(() {
          userEmail = v;
          // print(userEmail);
        });
      });
    }catch(e) {}
  }

  @override
  void initState() {
    
    getCurrentUserEmail();
    super.initState();
  }

  _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja sair do app?'),
          content: const Text('Certeza?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('Sim'),
              onPressed: () {
                auth.logOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage()
                  )
                );
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        return await Future.value();
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                color: blue,
                child: DrawerHeader(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Icon(Icons.person, size: 40.0, color: yellow),
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          userEmail ?? 'carregando...',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: yellow
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sair...'),
                onTap: () {
                  _showDialog(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: new IconThemeData(color: yellow),
          title: Text('itinerários recentes', style: TextStyle(color: yellow)),
          backgroundColor: blue,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: blue,
          onPressed: ()async {
            String docIncomplete = await checkDocIncomplete();
            // print(docIncomplete);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItineraryPage(docIncomplete: docIncomplete)
              )
            );
          },
          child: Icon(Icons.add, color: yellow),
        ),
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: database.db
                  .where('user_id', isEqualTo: widget.userID)
                  .limit(4)
                  .orderBy('microsecondsSinceEpoch', descending: true)
                  .snapshots(),
                  builder: (_, snapshot) {
                    if ( snapshot.hasData ) {
                      List<Widget> ultimosItinerarios = [];
                      for (var doc in snapshot.data.documents) { 
                        ultimosItinerarios.add(
                          Card(
                            elevation: 10.0,
                            color: blue,
                            child: ListTile(
                              leading: Icon(Icons.directions_car, color: yellow),
                              title: Text('${doc.data['horario_inicio']}', style: TextStyle(color: yellow)),
                              subtitle: Text(
                                'DESTINO: ${doc.data['destino']}\nNOME: ${doc.data['nome']}',
                                style: TextStyle(color: yellow)
                              ),
                              trailing: Icon(Icons.list, color: yellow),
                              isThreeLine: true,
                            ),
                          )
                        );
                      }
                      return Column(
                        children: ultimosItinerarios
                      );
                    }
                    return Center(
                      child: Text('sem registros recentes...', style: TextStyle(fontSize: 24.0)),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> checkDocIncomplete(){
    return database.db
    .where('km_final', isNull: true)
    .where('user_id', isEqualTo: widget.userID)
    .getDocuments()
    .then((snapshot) {
      if (snapshot.documents.length != 0) {
        return snapshot.documents[0].documentID;
      }else { return null; }
    });
  }

}
