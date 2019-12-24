
class Dados {
  String _nome;
  String _veiculoPlaca;
  String _veiculoNome;
  String _kmFim;
  String _kmInicio;
  String _destino;
  String _infoAdicional;

  Dados();

  String get getNome => _nome;
  set setNome(String v) => this._nome = v;


  String get getVeiculoPlaca => _veiculoPlaca;
  set setVeiculoPlaca(String v) => this._veiculoPlaca = v;


  String get getVeiculoNome => _veiculoNome;
  set setVeiculoNome(String v) => this._veiculoNome = v;


  String get getKmFim => _kmFim;
  set setKmFim(String v) => this._kmFim = v;


  String get getKmInicio => _kmInicio;
  set setKmInicio(String v) => this._kmInicio = v;


  String get getDestino => _destino;
  set setDestino(String v) => this._destino = v;


  String get getInfoAdicional => _infoAdicional;
  set setInfoAdicional(String v) => this._infoAdicional = v;


}
