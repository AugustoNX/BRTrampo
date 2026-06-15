import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

import '../models/cliente.dart';
import '../models/endereco.dart';
import '../models/prestador.dart';
import '../models/prestador_info.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/usuario_repository.dart';

/// Estados possíveis da sessão do app.
enum AuthStatus {
  /// Carregando estado inicial.
  carregando,

  /// Nenhum usuário autenticado.
  deslogado,

  /// Autenticado, mas sem registro em `/usuarios/{uid}` (cadastro
  /// incompleto). UI deve oferecer reentrada no fluxo.
  semPerfil,

  /// Autenticado e com registro carregado.
  autenticado,
}

/// Controlador central da sessão.
///
/// Combina o stream do [AuthService] com a leitura do registro do
/// usuário em [UsuarioRepository], expondo um único [AuthStatus] e o
/// [usuario] tipado (`Cliente` ou `Prestador`) para a UI.
class AuthController extends ChangeNotifier {
  AuthController({
    AuthService? authService,
    UsuarioRepository? repository,
  })  : _auth = authService ?? AuthService(),
        _repo = repository ?? UsuarioRepository() {
    _authSub = _auth.authStateChanges.listen(_onAuthChanged);
  }

  final AuthService _auth;
  final UsuarioRepository _repo;

  StreamSubscription<User?>? _authSub;
  StreamSubscription<Usuario?>? _userSub;

  AuthStatus _status = AuthStatus.carregando;
  Usuario? _usuario;
  String? _erro;

  AuthStatus get status => _status;
  Usuario? get usuario => _usuario;
  String? get erro => _erro;

  bool get isCliente => _usuario is Cliente;
  bool get isPrestador => _usuario is Prestador;
  Cliente? get cliente => _usuario is Cliente ? _usuario! as Cliente : null;
  Prestador? get prestador =>
      _usuario is Prestador ? _usuario! as Prestador : null;

  Future<void> _onAuthChanged(User? user) async {
    await _userSub?.cancel();
    _userSub = null;

    if (user == null) {
      _usuario = null;
      _setStatus(AuthStatus.deslogado);
      return;
    }

    _setStatus(AuthStatus.carregando);
    _userSub = _repo.observarUsuario(user.uid).listen((Usuario? u) {
      _usuario = u;
      _setStatus(u == null ? AuthStatus.semPerfil : AuthStatus.autenticado);
    });
  }

  /// Login com e-mail e senha.
  Future<void> login({required String email, required String senha}) async {
    _erro = null;
    notifyListeners();
    try {
      await _auth.signIn(email: email, password: senha);
    } on AuthException catch (e) {
      _erro = e.message;
      _setStatus(AuthStatus.deslogado);
      rethrow;
    }
  }

  /// Cadastra um **Cliente** (cria no Auth e persiste no RTDB).
  Future<void> cadastrarCliente({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
    required Endereco endereco,
  }) async {
    _erro = null;
    notifyListeners();
    try {
      final User user = await _auth.signUp(email: email, password: senha);
      final Cliente novo = Cliente(
        uid: user.uid,
        nome: nome,
        email: email,
        telefone: telefone,
        endereco: endereco,
      );
      await _repo.salvarCliente(novo);
    } on AuthException catch (e) {
      _erro = e.message;
      rethrow;
    }
  }

  /// Cadastra um **Prestador** (cria no Auth, persiste em
  /// `/usuarios/{uid}` e na projeção pública `/prestadores/{uid}`).
  Future<void> cadastrarPrestador({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
    required String cidadeBase,
    required String regiaoAtendimento,
    required PrestadorInfo info,
  }) async {
    _erro = null;
    notifyListeners();
    try {
      final User user = await _auth.signUp(email: email, password: senha);
      final Prestador novo = Prestador(
        uid: user.uid,
        nome: nome,
        email: email,
        telefone: telefone,
        cidadeBase: cidadeBase,
        regiaoAtendimento: regiaoAtendimento,
        prestadorInfo: info,
      );
      await _repo.salvarPrestador(novo);
    } on AuthException catch (e) {
      _erro = e.message;
      rethrow;
    }
  }

  /// Atualiza o registro do prestador autenticado.
  ///
  /// Sobrescreve `/usuarios/{uid}` e `/prestadores/{uid}` (projeção
  /// pública) com os novos dados. O stream interno do controller
  /// reflete a mudança automaticamente.
  Future<void> atualizarPrestador(Prestador atualizado) async {
    _erro = null;
    try {
      await _repo.atualizarPrestador(atualizado);
    } on Object catch (e) {
      _erro = e.toString();
      rethrow;
    }
  }

  Future<void> logout() => _auth.signOut();

  void _setStatus(AuthStatus s) {
    _status = s;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _userSub?.cancel();
    super.dispose();
  }
}
