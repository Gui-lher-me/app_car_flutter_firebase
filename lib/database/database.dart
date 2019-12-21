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
    dados.setNome = nome;
    dados.setVeiculoPlaca = veiculoPlaca;
    dados.setVeiculoNome = veiculoNome;
    dados.setKmInicio = kmInicio;
    dados.setDestino = destino;

    Map<String, String> map = Map<String, String>();

    map['nome'] = dados.getNome;
    map['veiculo_placa'] = dados.getVeiculoPlaca;
    map['veiculo_nome'] = dados.getVeiculoNome;
    map['km_inicio'] = dados.getKmInicio;
    map['destino'] = dados.getDestino;

    map['horario_inicio'] = DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now());
    map['microsecondsSinceEpoch'] = DateTime.now().microsecondsSinceEpoch.toString();

    map['user_id'] = await Auth().getcurrentUserID();
    map['user_email'] = await Auth().getcurrentUserEmail();

    map['latitude_inicio'] = await getLocation.getLatitude();
    map['longitude_inicio'] = await getLocation.getLongitude();

    map['km_final'] = null;

    DocumentReference doc = db.document();

    doc.setData(map);

    return doc.documentID;

  }

  Future<void> updateData(String kmFim, String currentDocID)async{
    dados.setKmFim = kmFim;
    double kmRodados = double.parse(dados.getKmFim) - double.parse(dados.getKmInicio);
    db.document(currentDocID).updateData({
      'km_final': dados.getKmFim,
      'doc_id': currentDocID,
      'horario_fim': DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now()),
      'latitude_fim': await getLocation.getLatitude(),
      'longitude_fim': await getLocation.getLongitude(),
      'km_rodados': kmRodados.toString()
    });
  }

}
