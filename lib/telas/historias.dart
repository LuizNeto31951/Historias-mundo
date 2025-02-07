import 'package:historias_mundo/apis/api.dart';
import 'package:historias_mundo/componentes/historiacard.dart';
import 'package:historias_mundo/estado.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Historias extends StatefulWidget {
  const Historias({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HistoriasState();
  }
}

class _HistoriasState extends State<Historias> {
  late List<dynamic> _historiasCarregadas = [];
  bool _carregando = false;
  late TextEditingController _controladorFiltragem;
  String _filtro = "";
  late ScrollController _scrollController;
  late ServicoHistorias _servicoHistorias;
  int _ultimaHistoria = 0;
  final int _itensPorPagina = 6;

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    _servicoHistorias = ServicoHistorias();
    _controladorFiltragem = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_rolagemListener);
    _carregarMaisHistorias();
  }

  void _rolagemListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _carregarMaisHistorias();
    }
  }

  Future<void> _carregarMaisHistorias() async {
    if (_carregando) return;

    setState(() {
      _carregando = true;
    });

    await Future.delayed(const Duration(seconds: 3));
    try {
      List<dynamic> historias = [];
      if (_filtro != "") {
        historias = await _servicoHistorias.findHistorias(
            _ultimaHistoria, _itensPorPagina, _filtro);
      } else {
        historias = await _servicoHistorias.getHistorias(
            _ultimaHistoria, _itensPorPagina);
      }

      if (historias.isNotEmpty) {
        setState(() {
          _ultimaHistoria = historias.last["historia_id"];
          _historiasCarregadas.addAll(historias);
        });
      }
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool usuarioLogado = estadoApp.usuario != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 60, right: 20),
              child: TextField(
                controller: _controladorFiltragem,
                onSubmitted: (descricao) {
                  setState(() {
                    _filtro = descricao;
                    _ultimaHistoria = 0;
                    _historiasCarregadas.clear();
                  });
                  _carregarMaisHistorias();
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          usuarioLogado
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      estadoApp.onLogout();
                    });

                    Toast.show(
                      "Você não está mais conectado",
                      duration: Toast.lengthLong,
                      gravity: Toast.bottom,
                    );
                  },
                  icon: const Icon(Icons.logout),
                )
              : IconButton(
                  onPressed: () {
                    estadoApp.onLogin(() => Toast.show(
                          'Olá, ${estadoApp.usuario?.nome}, você foi conectado com sucesso',
                          duration: Toast.lengthLong,
                          gravity: Toast.bottom,
                        ));
                  },
                  icon: const Icon(Icons.login),
                ),
        ],
      ),
      body: _carregando && _historiasCarregadas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _filtro = "";
                  _controladorFiltragem.clear();
                  _ultimaHistoria = 0;
                  _historiasCarregadas.clear();
                });
                _carregarMaisHistorias();
              },
              child: GridView.builder(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: 0.5,
                ),
                itemCount: _historiasCarregadas.length + (_carregando ? 2 : 0),
                itemBuilder: (context, index) {
                  if (index >= _historiasCarregadas.length) {
                    return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const SizedBox(
                          width: 220,
                          height: 250,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ));
                  }

                  final historia = _historiasCarregadas[index];
                  return SizedBox(
                    width: 220,
                    height: 250,
                    child: Historiacard(historia: historia),
                  );
                },
              ),
            ),
    );
  }
}
