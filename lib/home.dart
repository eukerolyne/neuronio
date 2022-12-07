import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'helper/pessoa_helper.dart';
import 'model/pessoa.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _nomeController = TextEditingController();
  var _db = PessoaHelper();

  List<Pessoa> _pessoas = [];

  _exibirTelaCadastro({Pessoa? pessoa}) {
    String salvarAtualizar = "";

    /*Salvar*/
    if (pessoa == null) {
      _nomeController.text = "";
      salvarAtualizar = "Salvar";
    } else {
      /*Atualizar*/
      _nomeController.text = pessoa.nome;
      salvarAtualizar = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Adicionar pessoa"),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: _nomeController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: "Nome completo funcionar",
                      hintText: "Digine o nome..."),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar")),
              TextButton(
                  //salvar
                  onPressed: () {
                    _salvarAtualizarPessoa(pessoaSelecionada: pessoa);
                    Navigator.pop(context);
                  },
                  child: const Text("Salvar")),
            ],
          );
        });
  }

  _salvarAtualizarPessoa({Pessoa? pessoaSelecionada}) async {
    String nome = _nomeController.text;

    if (pessoaSelecionada == null) {
      Pessoa pessoa = Pessoa(nome, DateTime.now().toString());
      int resultado = await _db.salvarPessoa(pessoa);
    } else {
      pessoaSelecionada.nome = nome;
      pessoaSelecionada.data = DateTime.now().toString();
      int resultado = await _db.atualizarPessoa(pessoaSelecionada);
    }
    _nomeController.clear();
    _recuperarPessoa();
  }

  _removerPessoa(int id) async {
    await _db.removePessoa(id);

    _recuperarPessoa();
  }

  _formatarData(String data) {
    initializeDateFormatting('pt-BR');

    var formatador = DateFormat.yMMMd('pt-BR');

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _recuperarPessoa() async {
    List pessoasRecuperadas = await _db.recuperarPessoa();
    List<Pessoa> listaTemporaria = [];
    for (var item in pessoasRecuperadas) {
      Pessoa pessoa = Pessoa.fromMap(item);
      listaTemporaria.add(pessoa);
    }

    setState(() {
      _pessoas = listaTemporaria;
    });

    print("Lista pessoas" + pessoasRecuperadas.toString());
  }

  @override
  Widget build(BuildContext context) {
    _recuperarPessoa();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Death Note"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _pessoas.length,
                itemBuilder: (context, index) {
                  final pessoa = _pessoas[index];

                  return Card(
                    child: ListTile(
                      title: Text(pessoa.nome),
                      subtitle: Text("${_formatarData(pessoa.data)}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _exibirTelaCadastro(pessoa: pessoa);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.edit,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _removerPessoa(pessoa.id);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
