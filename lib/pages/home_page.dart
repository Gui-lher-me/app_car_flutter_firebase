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

  Database database = Database();

  Auth auth = Auth();

  String userEmail;

  void getCurrentUserEmail() {
    try {
      auth.getcurrentUserEmail().then((v){
        setState(() {
          userEmail = v;
          print(userEmail);
        });
      });
    }catch(e) { debugPrint('Some error'); }
  }

  @override
  void initState() {
    getCurrentUserEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Colors.white],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight
                )
              ),
              child: DrawerHeader(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.person, size: 40.0),
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      margin: EdgeInsets.only(left: 10.0),
                      child: Text(
                        userEmail ?? 'carregando...',
                        style: TextStyle(
                          fontSize: 16.0
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
                auth.logOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage()
                  )
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('itinerários recentes'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: ()async {
          String docIncomplete = await checkDocIncomplete();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItineraryPage(docIncomplete: docIncomplete)
            )
          );
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.white],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight
          )
        ),
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
                  Color color = Colors.white;
                  if ( snapshot.hasData ) {
                    List<Widget> ultimosItinerarios = [];
                    for (var doc in snapshot.data.documents) {
                      ultimosItinerarios.add(
                        Card(
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            leading: Icon(Icons.directions_car, color: color,),
                            title: Text('${doc.data['horario_inicio']}', style: TextStyle(color: color)),
                            subtitle: Text(
                              'destino: ${doc.data['destino']}\nveículo: ${doc.data['veiculo_nome']}',
                              style: TextStyle(color: color)
                            ),
                            trailing: Icon(Icons.drag_handle, color: color,),
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
                    child: Text('Sem registros recentes...', style: TextStyle(fontSize: 24.0)),
                  );
                }
              ),
            ],
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
