from flask import Flask, jsonify
from urllib.request import urlopen
import mysql.connector as mysql
import json

servico = Flask("historias")

DESCRICAO = "Serviço de listagem e cadastro de histórias"
VERSAO = "1.0"

SERVIDOR_BANCO = "banco"
USUARIO_BANCO = "root"
SENHA_BANCO = "admin"
NOME_BANCO = "historias_mundo"


def get_conexao_com_bd():
    return mysql.connect(
        host=SERVIDOR_BANCO,
        user=USUARIO_BANCO,
        password=SENHA_BANCO,
        database=NOME_BANCO
    )


URL_LIKES = "http://likes:5000/likes_por_historia/"

def get_quantidade_de_likes(historia_id):
    try:
        url = f"{URL_LIKES}{historia_id}"
        resposta = urlopen(url).read()
        resposta = json.loads(resposta)
        return resposta.get("curtidas", 0)
    except Exception:
        return 0


@servico.get("/")
def get_info():
    return jsonify(descricao=DESCRICAO, versao=VERSAO)


@servico.get("/historias/<int:ultimo_historia>/<int:tamanho_da_pagina>")
def get_historias(ultimo_historia, tamanho_da_pagina):
    conexao = get_conexao_com_bd()
    cursor = conexao.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT feeds.id AS historia_id, DATE_FORMAT(feeds.data, '%Y-%m-%d %H:%i') AS data,
               paises.id AS pais_id, paises.nome AS nome_pais, paises.bandeira,
               historias.titulo AS titulo_historia, historias.descricao, historias.detalhada, historias.imagem
        FROM feeds
        JOIN historias ON historias.id = feeds.historia
        JOIN paises ON paises.id = historias.pais
        WHERE feeds.id > %s
        ORDER BY historia_id ASC, data DESC
        LIMIT %s
        """,
        (ultimo_historia, tamanho_da_pagina)
    )
    historias = cursor.fetchall()
    conexao.close()

    for historia in historias:
        historia["likes"] = get_quantidade_de_likes(historia["historia_id"])

    return jsonify(historias)


@servico.get("/historias/<int:ultimo_feed>/<int:tamanho_da_pagina>/<string:titulo_da_historia>")
def find_historias(ultimo_feed, tamanho_da_pagina, titulo_da_historia):
    conexao = get_conexao_com_bd()
    cursor = conexao.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT feeds.id AS historia_id, DATE_FORMAT(feeds.data, '%Y-%m-%d %H:%i') AS data,
               paises.id AS pais_id, paises.nome AS nome_pais, paises.bandeira,
               historias.titulo AS titulo_historia, historias.descricao, historias.detalhada, historias.imagem
        FROM feeds
        JOIN historias ON historias.id = feeds.historia
        JOIN paises ON paises.id = historias.pais
        WHERE historias.titulo LIKE %s
        AND feeds.id > %s
        ORDER BY historia_id ASC, data DESC
        LIMIT %s
        """,
        (f"%{titulo_da_historia}%", ultimo_feed, tamanho_da_pagina)
    )
    historias = cursor.fetchall()
    conexao.close()

    for historia in historias:
        historia["curtidas"] = get_quantidade_de_likes(historia['historia_id'])

    return jsonify(historias)


@servico.get("/historia/<int:id>")
def find_historia(id):
    conexao = get_conexao_com_bd()
    cursor = conexao.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT feeds.id AS historia_id, DATE_FORMAT(feeds.data, '%Y-%m-%d %H:%i') AS data,
               paises.id AS pais_id, paises.nome AS nome_pais, paises.bandeira,
               historias.titulo AS titulo_historia, historias.descricao, historias.detalhada, historias.imagem
        FROM feeds
        JOIN historias ON historias.id = feeds.historia
        JOIN paises ON paises.id = historias.pais
        WHERE feeds.id = %s
        """,
        (id,)
    )
    historia = cursor.fetchone()
    conexao.close()

    if historia:
        historia["likes"] = get_quantidade_de_likes(id)

    return jsonify(historia or {})


if __name__ == "__main__":
    servico.run(host="0.0.0.0", debug=True)
