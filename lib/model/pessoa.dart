class Pessoa {
  late int id;
  late String nome;
  late String data;
  Pessoa(this.nome, this.data);

  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "data": data
    };
    return map;
  }

  Pessoa.fromMap(Map map) {
    id = map["id"];
    nome = map["nome"];
    data = map["data"];
  }
}