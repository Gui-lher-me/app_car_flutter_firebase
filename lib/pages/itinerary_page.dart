import 'package:app_car/database/database.dart';
import 'package:app_car/utilities/my_custom_button.dart';
import 'package:app_car/utilities/my_custom_textfield.dart';
import 'package:flutter/material.dart';

class ItineraryPage extends StatefulWidget {

  final String docIncomplete;

  ItineraryPage({this.docIncomplete});

  @override
  _ItineraryPageState createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {

  String currentDocID;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  TextEditingController nome = TextEditingController();
  TextEditingController veiculoPlaca = TextEditingController();
  TextEditingController veiculoNome = TextEditingController();
  TextEditingController kmFim = TextEditingController();
  TextEditingController kmInicio = TextEditingController();
  TextEditingController destino = TextEditingController();

  bool showFinalPart = false;

  @override
  void initState() {
    print(widget.docIncomplete);
    if(widget.docIncomplete != null) {
      showFinalPart = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.white],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight
          )
        ),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: !showFinalPart,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        MyCustomTextField(
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Insira seu nome';
                            }
                            return null;
                          },
                          controller: nome,
                          hintText: 'nome',
                        ),
                        MyCustomTextField(
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Insira a placa';
                            }
                            return null;
                          },
                          controller: veiculoPlaca,
                          hintText: 'veiculo placa',
                        ),
                        MyCustomTextField(
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Insira o nome do veículo';
                            }
                            return null;
                          },
                          controller: veiculoNome,
                          hintText: 'veiculo nome',
                        ),
                        MyCustomTextField(
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Insira o km inicial';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          controller: kmInicio,
                          hintText: 'km inicio',
                        ),
                        MyCustomTextField(
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Insira seu destino';
                            }
                            return null;
                          },
                          controller: destino,
                          hintText: 'destino',
                        ),
                        MyCustomButton(
                          onPressed: ()async {
                            if (_formKey.currentState.validate()) {
                              Database database = Database();
                              currentDocID = await database.insertData(
                                nome.text,
                                veiculoPlaca.text,
                                veiculoNome.text,
                                kmInicio.text,
                                destino.text
                              );
                              setState(() {
                                showFinalPart = true;
                              });
                            }
                          },
                          text: 'Iniciar rota',
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showFinalPart,
                  child: Form(
                    key: _formKey2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        MyCustomTextField(
                          keyboardType: TextInputType.number,
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Insira o km final';
                            }
                            return null;
                          },
                          controller: kmFim,
                          hintText: 'km fim',
                        ),
                        MyCustomButton(
                          onPressed: () {
                            if(_formKey2.currentState.validate()) {
                              Database database = Database();
                              database.updateData(kmFim.text, currentDocID ?? widget.docIncomplete);
                              Navigator.pop(context);
                            }
                          },
                          text: 'Finalizar rota',
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}