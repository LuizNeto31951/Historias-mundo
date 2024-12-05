# historias_mundo

Ao rodar, baixar NDK 25.1.8937393 via android studio, pois a NDK nativa do flutter estava conflitando com a biblioteca do firebase. 

Também é necessario trocar no flutter.groovy o valor do ndkVersion que vem como padrão: "23.1.7779620" para "25.1.8937393", para isso acessar
o diretorio onde o flutter está instalado:
** <flutter_dir>\flutter\packages\flutter_tools\gradle\src\main\groovy\flutter.groovy ** 