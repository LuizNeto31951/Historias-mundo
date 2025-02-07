import 'package:historias_mundo/estado.dart';
import 'package:flutter/material.dart';
import 'package:historias_mundo/apis/api.dart';

class Historiacard extends StatelessWidget {
  final dynamic historia;

  const Historiacard({super.key, required this.historia});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        estadoApp.mostrarDetalhes(historia["historia_id"]);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  formatarCaminhoArquivo(historia["imagem"]),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 150,
                      color: Colors.grey),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.network(
                          formatarCaminhoArquivo(historia["bandeira"])),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    historia["nome_pais"] ?? "Sem país",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                historia["titulo_historia"] ?? "Sem título",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                historia["descricao"] ?? "Sem descrição",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_rounded,
                      color: Colors.red, size: 18),
                  const SizedBox(width: 4),
                  Text((historia["likes"] ?? 0).toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
