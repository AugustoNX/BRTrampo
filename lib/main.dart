import 'package:flutter/material.dart';

// IMPORTS DAS TELAS
import 'Acesso/login.dart';
import 'home.dart';
import 'perfil/perfil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color verde = Color(0xFF2F4F3F);
  static const Color laranja = Color(0xFFF97316);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BRTrampo',

      // TEMA GLOBAL
      theme: ThemeData(
        primaryColor: verde,
        colorScheme: ColorScheme.fromSeed(
          seedColor: verde,
          primary: verde,
          secondary: laranja,
        ),
      ),

      // TELA INICIAL
      initialRoute: '/login',

      // ROTAS
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/perfil': (context) => const PerfilPage(),
      },
    );
  }
}