import 'package:app_car/auth/auth.dart';
import 'package:app_car/services/get_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dados.dart';
import 'package:intl/intl.dart';

class Database {

  GetLocation getLocation = GetLocation();

  final db = Firestore.instance.collection('records');

  Dados dados = Dados();

  Future<String> insertData(
    String nome,
    String veiculoPlaca,
    String veiculoNome,
    String kmInicio,
    String destino,
  )async {
    dados.nome = nome;
    dados.veiculoPlaca = veiculoPlaca;
    dados.veiculoNome = veiculoNome;
    dados.kmInicio = kmInicio;
    dados.destino = destino;

    Map<String, String> map = Map();

    map['nome'] = dados.nome;
    map['veiculo_placa'] = dados.veiculoPlaca;
    map['veiculo_nome'] = dados.veiculoNome;
    map['km_inicio'] = dados.kmInicio;
    map['destino'] = dados.destino;

    map['horario_inicio'] = DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now());
    map['microsecondsSinceEpoch'] = DateTime.now().microsecondsSinceEpoch.toString();

    map['user_id'] = await Auth().getcurrentUserID();
    map['user_email'] = await Auth().getcurrentUserEmail();

    map['latitude'] = await getLocation.getLatitude();
    map['longitude'] = await getLocation.getLongitude();

    map['km_final'] = null;

    DocumentReference doc = db.document();

    doc.setData(map);

    return doc.documentID;

  }

  updateData(String kmFim, String currentDocID){
    dados.kmFim = kmFim;
    db.document(currentDocID).updateData({
      'km_final': dados.kmFim,
      'doc_id': currentDocID,
      'horario_fim': DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now()),
    });
  }

}
