// ignore_for_file: unnecessary_getters_setters

import 'package:historias_mundo/autenticador.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Situacao { mostrandoHistorias, mostrandoDetalhes }

class EstadoApp extends ChangeNotifier {
  Situacao _situacao = Situacao.mostrandoHistorias;
  Situacao get situacao => _situacao;

  GoogleSignInAccount? googleAccount;

  late int _idHistoria;
  int get idHistoria => _idHistoria;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;
  set usuario(Usuario? usuario) {
    _usuario = usuario;
  }

  void mostrarHistorias() {
    _situacao = Situacao.mostrandoHistorias;

    notifyListeners();
  }

  void mostrarDetalhes(int idHistoria) {
    _situacao = Situacao.mostrandoDetalhes;
    _idHistoria = idHistoria;

    notifyListeners();
  }

  void onLogin(Function showToast) async {
    googleAccount = await GoogleSignIn().signIn();
    if (googleAccount?.displayName != null) {
      _usuario = Usuario(googleAccount?.displayName, googleAccount?.email);
      notifyListeners();
    }
    if (_usuario?.nome != null) {
      showToast();
    }
  }

  void onLogout() async {
    googleAccount = await GoogleSignIn().signOut();
    _usuario = null;

    notifyListeners();
  }
}

late EstadoApp estadoApp;
