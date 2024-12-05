import 'dart:convert';
import 'package:historias_mundo/componentes/historiacard.dart';
import 'package:historias_mundo/estado.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class Historias extends StatefulWidget {
  const Historias({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HistoriasState();
  }
}

class _HistoriasState extends State<Historias> {
  late List<dynamic> _feedEstatico = [];
  late Map<String, List<dynamic>> _historiasPorPais = {};
  late List<String> _paisesCarregados = [];

  bool _carregando = false;
  late TextEditingController _controladorFiltragem;
  String _filtro = "";
  late ScrollController _scrollController;

  int _paginaAtual = 1;
  final int _itensPorPagina = 3;

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    _controladorFiltragem = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_rolagemListener);
    _lerFeedEstatico();
  }

  Future<void> _lerFeedEstatico() async {
    setState(() {
      _carregando = true;
    });

    final String conteudoJson =
        await rootBundle.loadString("lib/recursos/json/feed.json");
    _feedEstatico = json.decode(conteudoJson)["historias"];

    _atualizarHistorias();
  }

  void _atualizarHistorias() {
    setState(() {
      _historiasPorPais = _agruparPorPais(_feedEstatico, _filtro);
      _paisesCarregados =
          _historiasPorPais.keys.take(_paginaAtual * _itensPorPagina).toList();
      _carregando = false;
    });
  }

  Map<String, List<dynamic>> _agruparPorPais(
      List<dynamic> historias, String filtro) {
    final Map<String, List<dynamic>> agrupados = {};
    for (var historia in historias) {
      if (filtro.isNotEmpty &&
          !historia["titulo"].toLowerCase().contains(filtro.toLowerCase())) {
        continue;
      }

      String pais = historia["pais"];
      if (!agrupados.containsKey(pais)) {
        agrupados[pais] = [];
      }
      agrupados[pais]?.add(historia);
    }
    return agrupados;
  }

  void _rolagemListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _carregarMaisHistorias();
    }
  }

  Future<void> _carregarMaisHistorias() async {
    if (_carregando) return;
    if (_paginaAtual * _itensPorPagina >= _historiasPorPais.keys.length) return;

    setState(() {
      _carregando = true;
      _paginaAtual++;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _paisesCarregados.addAll(
        _historiasPorPais.keys
            .skip((_paginaAtual - 1) * _itensPorPagina)
            .take(_itensPorPagina),
      );
      _carregando = false;
    });
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
                    _paginaAtual = 1;
                    _atualizarHistorias();
                  });
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
                    setState(() {
                      estadoApp.onLogin(() => Toast.show(
                            'Olá, ${estadoApp.usuario?.nome} você foi conectado com sucesso',
                            duration: Toast.lengthLong,
                            gravity: Toast.bottom,
                          ));
                    });
                  },
                  icon: const Icon(Icons.login),
                ),
        ],
      ),
      body: _carregando && _paginaAtual == 1
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                _filtro = "";
                _controladorFiltragem.clear();
                _paginaAtual = 1;
                _atualizarHistorias();
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _paisesCarregados.length + 1,
                itemBuilder: (context, index) {
                  if (index == _paisesCarregados.length) {
                    return _carregando
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  }

                  String pais = _paisesCarregados[index];
                  List<dynamic> historias = _historiasPorPais[pais]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'lib/recursos/imagens/paises/${historias.first["bandeira"]}',
                              width: 38,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              pais,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 350,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: historias.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final historia = historias[index];
                            return SizedBox(
                              width: 220,
                              child: Historiacard(historia: historia),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
