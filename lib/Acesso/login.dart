import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const Color verde = Color(0xFF2F4F3F);
  static const Color laranja = Color(0xFFF97316);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D7C3),
      body: SafeArea(
        child: Column(
          children: [
            // Topo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: verde,
              child: const Center(
                child: Text(
                  "BRTrampo",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Botões Cliente / Prestador
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _card("Cliente", Icons.person, verde, Colors.white),
                _card("Prestador", Icons.build, laranja, Colors.white),
              ],
            ),

            const SizedBox(height: 40),

            // Campos
            _input("Email"),
            const SizedBox(height: 15),
            _input("Senha"),

            const SizedBox(height: 20),

            // Botão entrar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: laranja,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              onPressed: () {},
              child: const Text("Entrar"),
            ),

            const SizedBox(height: 10),

            const Text(
              "Cadastre-se",
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // Ícones sociais
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.g_mobiledata, size: 40),
                SizedBox(width: 15),
                Icon(Icons.facebook, size: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(String texto, IconData icon, Color bg, Color textColor) {
    return Container(
      width: 140,
      height: 120,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: textColor),
          const SizedBox(height: 10),
          Text(
            texto,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        obscureText: hint == "Senha",
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: verde,
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}