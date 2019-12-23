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

  Database database = Database();

  String currentDocID;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  TextEditingController nome = TextEditingController();
  TextEditingController veiculoPlaca = TextEditingController();
  TextEditingController veiculoNome = TextEditingController();
  TextEditingController kmFim = TextEditingController();
  TextEditingController kmInicio = TextEditingController();
  TextEditingController destino = TextEditingController();
  TextEditingController infoAdicional = TextEditingController();

  bool showFinalPart = false;

  @override
  void initState() {
    // print(widget.docIncomplete);
    if(widget.docIncomplete != null) {
      showFinalPart = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
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
                          hintText: 'nome/motorista',
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
                          hintText: 'destino/finalidade',
                        ),
                        MyCustomButton(
                          fontSize: 20.0,
                          onPressed: ()async {
                            if (_formKey.currentState.validate()) {
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
                          keyboardType: TextInputType.text,
                          validator: (String v) {
                            if (v.isEmpty) {
                              return 'Insira alguma info adicional ex: tudo ok!';
                            }
                            return null;
                          },
                          controller: infoAdicional,
                          hintText: 'info adicional',
                        ),
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
                          fontSize: 20.0,
                          onPressed: () {
                            if(_formKey2.currentState.validate()) {
                              database.updateData(kmFim.text, currentDocID ?? widget.docIncomplete, infoAdicional.text);
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
