import 'dart:convert';

import 'package:historias_mundo/estado.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:toast/toast.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetalhesState();
  }
}

enum _EstadoHistoria { naoVerificado, temHistoria, semHistoria }

class _DetalhesState extends State<Detalhes> {
  late dynamic _feedEstatico;

  _EstadoHistoria _temHistoria = _EstadoHistoria.naoVerificado;
  late dynamic _historia;

  late PageController _controladorSlides;
  late int _slideSelecionado;

  bool _curtiu = false;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _lerFeedEstatico();
    _iniciarSlides();
  }

  void _iniciarSlides() {
    _slideSelecionado = 0;
    _controladorSlides = PageController(initialPage: _slideSelecionado);
  }

  Future<void> _lerFeedEstatico() async {
    String conteudoJson =
        await rootBundle.loadString("lib/recursos/json/feed.json");
    _feedEstatico = await json.decode(conteudoJson);

    _carregarHistoria();
  }

  void _carregarHistoria() {
    setState(() {
      _historia = _feedEstatico['historias']
          .firstWhere((historia) => historia["_id"] == estadoApp.idHistoria);

      _temHistoria = _historia != null
          ? _EstadoHistoria.temHistoria
          : _EstadoHistoria.semHistoria;
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
                        child: Text("Historias do mundo"))
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
          Text("historia inexistente :(",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red)),
          Text("selecione outra historia na tela anterior",
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
            Image.asset('lib/recursos/imagens/paises/${_historia["bandeira"]}',
                width: 38),
            Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: Text(
                  _historia["titulo"],
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
                  return Image.asset(
                    'lib/recursos/imagens/historias/${_historia["image"]}',
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
                                setState(() {
                                  _historia['likes'] = _historia['likes'] - 1;

                                  _curtiu = false;
                                });
                              } else {
                                setState(() {
                                  _historia['likes'] = _historia['likes'] + 1;

                                  _curtiu = true;
                                });

                                Toast.show("Obrigado pela avaliação",
                                    duration: Toast.lengthLong,
                                    gravity: Toast.bottom);
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
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(_historia["descricao"],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold))),
                if (_historia["detalhada"] != null)
                  ..._historia["detalhada"]
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget detalhes = const SizedBox.shrink();

    if (_temHistoria == _EstadoHistoria.naoVerificado) {
      detalhes = const SizedBox.shrink();
    } else if (_temHistoria == _EstadoHistoria.temHistoria) {
      detalhes = _exibirHistoria();
    } else {
      detalhes = _exibirMensagemHistoriaInexistente();
    }

    return detalhes;
  }
}
