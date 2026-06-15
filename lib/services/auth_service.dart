import 'package:firebase_auth/firebase_auth.dart';

/// Wrapper de alto nível sobre [FirebaseAuth] para operações de
/// autenticação (cadastro, login, logout, listener da sessão).
///
/// Centraliza o tratamento de [FirebaseAuthException] traduzindo-o em
/// mensagens amigáveis em português para a camada de UI.
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Stream emitido a cada mudança de sessão (login, logout, refresh).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Usuário atualmente autenticado, ou `null` se ninguém estiver logado.
  User? get currentUser => _auth.currentUser;

  /// Cria uma nova conta com e-mail e senha.
  ///
  /// Lança [AuthException] com mensagem amigável em caso de falha.
  Future<User> signUp({required String email, required String password}) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e));
    }
  }

  /// Autentica um usuário existente com e-mail e senha.
  Future<User> signIn({required String email, required String password}) async {
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e));
    }
  }

  /// Encerra a sessão atual.
  Future<void> signOut() => _auth.signOut();

  /// Envia e-mail de recuperação de senha.
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e));
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente em alguns minutos.';
      default:
        return e.message ?? 'Falha na autenticação.';
    }
  }
}

/// Exceção amigável de autenticação propagada à UI.
class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
