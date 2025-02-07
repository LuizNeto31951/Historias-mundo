import 'dart:convert';

import 'package:historias_mundo/estado.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:toast/toast.dart';

import '../apis/api.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetalhesState();
  }
}

enum _EstadoHistoria { naoVerificado, temHistoria, semHistoria }

class _DetalhesState extends State<Detalhes> {
  _EstadoHistoria _temHistoria = _EstadoHistoria.naoVerificado;
  late dynamic _historia;

  late PageController _controladorSlides;
  late int _slideSelecionado;
  late ServicoHistorias _servicoHistorias;
  late ServicoCurtidas _servicoCurtidas;

  bool _curtiu = false;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);
    _servicoHistorias = ServicoHistorias();
    _servicoCurtidas = ServicoCurtidas();

    _carregarHistoria();
    _iniciarSlides();
  }

  void _iniciarSlides() {
    _slideSelecionado = 0;
    _controladorSlides = PageController(initialPage: _slideSelecionado);
  }

  void _carregarHistoria() {
    _servicoHistorias.findHistoria(estadoApp.idHistoria).then((historia) {
      _historia = historia;

      if (estadoApp.usuario != null) {
        _servicoCurtidas
            .curtiu(estadoApp.usuario!, estadoApp.idHistoria)
            .then((curtiu) {
          setState(() {
            _temHistoria = _historia != null
                ? _EstadoHistoria.temHistoria
                : _EstadoHistoria.semHistoria;
            _curtiu = curtiu;
          });
        });
      } else {
        setState(() {
          _temHistoria = _historia != null
              ? _EstadoHistoria.temHistoria
              : _EstadoHistoria.semHistoria;
          _curtiu = false;
        });
      }
    });
  }

  Widget _exibirMensagemHistoriaInexistente() {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(children: [
                    Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text("Histórias do Mundo"))
                  ]),
                  GestureDetector(
                      onTap: () {
                        estadoApp.mostrarHistorias();
                      },
                      child: const Icon(Icons.arrow_back))
                ])),
        body: const SizedBox.expand(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.error, size: 32, color: Colors.red),
          Text("História inexistente :(",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red)),
          Text("Selecione outra história na tela anterior",
              style: TextStyle(fontSize: 14))
        ])));
  }

  Widget _exibirHistoria() {
    bool usuarioLogado = estadoApp.usuario != null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(children: [
          Row(children: [
            Image.network(formatarCaminhoArquivo(_historia["bandeira"]),
                width: 38),
            Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: Text(
                  _historia["titulo_historia"],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ))
          ]),
          const Spacer(),
          GestureDetector(
            onTap: () {
              estadoApp.mostrarHistorias();
            },
            child: const Icon(Icons.arrow_back, size: 30),
          )
        ]),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 350,
            child: Stack(children: [
              PageView.builder(
                itemCount: 3,
                controller: _controladorSlides,
                onPageChanged: (slide) {
                  setState(() {
                    _slideSelecionado = slide;
                  });
                },
                itemBuilder: (context, pagePosition) {
                  return Image.network(
                    formatarCaminhoArquivo(_historia["imagem"]),
                    fit: BoxFit.cover,
                  );
                },
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Column(children: [
                    usuarioLogado
                        ? IconButton(
                            onPressed: () {
                              if (_curtiu) {
                                _servicoCurtidas
                                    .descurtir(estadoApp.usuario!,
                                        estadoApp.idHistoria)
                                    .then((resultado) {
                                  if (resultado["situacao"] == "ok") {
                                    Toast.show("Avaliação removida",
                                        duration: Toast.lengthLong,
                                        gravity: Toast.bottom);

                                    setState(() {
                                      _carregarHistoria();
                                    });
                                  }
                                });
                              } else {
                                _servicoCurtidas
                                    .curtir(estadoApp.usuario!,
                                        estadoApp.idHistoria)
                                    .then((resultado) {
                                  if (resultado["situacao"] == "ok") {
                                    Toast.show("Obrigado pela sua avaliação",
                                        duration: Toast.lengthLong,
                                        gravity: Toast.bottom);

                                    setState(() {
                                      _carregarHistoria();
                                    });
                                  }
                                });
                              }
                            },
                            icon: Icon(_curtiu
                                ? Icons.favorite
                                : Icons.favorite_border),
                            color: Colors.red,
                            iconSize: 26)
                        : const SizedBox.shrink(),
                  ]))
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: PageViewDotIndicator(
              currentItem: _slideSelecionado,
              count: 3,
              unselectedColor: Colors.black26,
              selectedColor: Colors.blue,
              duration: const Duration(milliseconds: 200),
              boxShape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(_historia["descricao"],
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold))),
                    if (_historia["detalhada"] != null)
                      ...jsonDecode(_historia["detalhada"])
                          .map<Widget>((paragrafo) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  paragrafo,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ))
                          .toList(),
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
                        child: Row(children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    Text(
                                      _historia["likes"].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ]))
                        ]))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget detalhes = const SizedBox.shrink();

    if (_temHistoria == _EstadoHistoria.temHistoria) {
      detalhes = _exibirHistoria();
    } else if (_temHistoria == _EstadoHistoria.semHistoria) {
      detalhes = _exibirMensagemHistoriaInexistente();
    }

    return detalhes;
  }
}
