
class Dados {
  String _nome;
  String _veiculoPlaca;
  String _veiculoNome;
  String _kmFim;
  String _kmInicio;
  String _destino;

  Dados();

  String get nome => _nome;

  set nome(String v) {
    if (v.length > 8) {
      print('test');
    }else { print('test2'); }
    this._nome = v;
  }


  String get veiculoPlaca => _veiculoPlaca;

  set veiculoPlaca(String v) {
    this._veiculoPlaca = v;
  }


  String get veiculoNome => _veiculoNome;

  set veiculoNome(String v) {
    this._veiculoNome = v;
  }


  String get kmFim => _kmFim;

  set kmFim(String v) {
    this._kmFim = v;
  }


  String get kmInicio => _kmInicio;

  set kmInicio(String v) {
    this._kmInicio = v;
  }


  String get destino => _destino;

  set destino(String v) {
    this._destino = v;
  }


}
