import 'package:app_car/auth/auth.dart';
import 'package:app_car/pages/home_page.dart';
import 'package:app_car/utilities/my_custom_button.dart';
import 'package:app_car/utilities/my_custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  String userID;

  Auth auth = Auth();

  TextEditingController _emailController = TextEditingController(text: 'test@test.com');
  TextEditingController _passwordController = TextEditingController(text: '123456');

  bool _loading = false;

  @override
  void initState() {
    
    super.initState();
    getUserID();
  }

  Future<String> getUserID()async {
    try {
      if(await auth.getcurrentUserID() != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage()
          )
        );
      }
      return await auth.getcurrentUserID();
    } catch(e) {
      print('No user found');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                      width: 200.0,
                      height: 150.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Aztek'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Color(0xff006680),
                          letterSpacing: 2.0
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.0),
                  MyCustomTextField(
                    validator: (String v) {
                      if (v.isEmpty) {
                        return 'Insira seu email corretamente';
                      }
                      return null;
                    },
                    controller: _emailController,
                    hintText: 'e-mail',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  MyCustomTextField(
                    validator: (String v) {
                      if (v.isEmpty) {
                        return 'Insira sua senha corretamente';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    hintText: 'senha',
                    obscureText: true,
                  ),
                  MyCustomButton(
                    fontSize: 20.0,
                    onPressed: ()async {
                      if(_formKey.currentState.validate()) {
                        try {
                          bool isLoggedIn = await auth.isLoggedIn(_emailController.text, _passwordController.text);
                          if(isLoggedIn == true) {
                            userID = await getUserID();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(userID: userID)
                              )
                            );
                          }
                          setState(() => _loading = true);
                          _emailController.clear();
                          _passwordController.clear();
                        } catch(error) { _showSnackBar('Preencha os campos acima corretamente!'); }
                      }else {}
                    },
                    text: 'Entrar',
                  ),
                  _loading == true ? Center(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ) : Container()
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
    );

    scaffoldKey.currentState.showSnackBar(snackBar);

    
  }

}
