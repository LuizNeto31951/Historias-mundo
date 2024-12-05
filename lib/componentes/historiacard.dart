import 'package:historias_mundo/estado.dart';
import 'package:flutter/material.dart';

class Historiacard extends StatelessWidget {
  final dynamic historia;

  const Historiacard({super.key, required this.historia});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        estadoApp.mostrarDetalhes(historia["_id"]);
      },
      child: Card(
        child: Column(children: [
          Image.asset('lib/recursos/imagens/historias/${historia['image']}',
              width: 150, height: 150, fit: BoxFit.cover),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(historia["titulo"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
              child: Text(historia["descricao"])),
          const Spacer(),
          Row(children: [
            Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 5),
                child: Row(children: [
                  const Icon(Icons.favorite_rounded,
                      color: Colors.red, size: 18),
                  Text(historia["likes"].toString())
                ])),
          ])
        ]),
      ),
    );
  }
}
