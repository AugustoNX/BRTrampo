import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color verde = Color(0xFF2F4F3F);
  static const Color laranja = Color(0xFFF97316);
  static const Color fundo = Color(0xFFE5E7E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              color: verde,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.menu, color: Colors.white),
                  const SizedBox(width: 10),
                  const Text(
                    "BR",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const Text(
                    "Trampo",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
            ),

            // BUSCA
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar serviço...",
                  suffixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: laranja),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: laranja),
                  ),
                ),
              ),
            ),

            // CATEGORIAS
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _categoria("Eletricista", Icons.flash_on),
                  _categoria("Carpinteiro", Icons.handyman),
                  _categoria("Mecânico", Icons.car_repair),
                  _categoria("Pintor", Icons.format_paint),
                  _categoria("Piscineiro", Icons.pool),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // LISTA
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _secao("Eletricista"),
                    _listaCards(),
                    _secao("Marceneiro"),
                    _listaCards(),
                    const SizedBox(height: 30),
                    Container(
                      height: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: verde,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoria(String nome, IconData icon) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: verde,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 5),
          Text(
            nome,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          )
        ],
      ),
    );
  }

  Widget _secao(String titulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Text(
            titulo,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Divider(thickness: 1),
          )
        ],
      ),
    );
  }

  Widget _listaCards() {
    return SizedBox(
      height: 190,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _card(),
          _card(),
          _card(),
        ],
      ),
    );
  }

  Widget _card() {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: verde,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // IMAGEM
          Container(
            height: 100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(
                    "https://i.pravatar.cc/150?img=3"), // placeholder
                fit: BoxFit.cover,
              ),
            ),
          ),

          // INFO
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Jorge amado",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  "Eletricista",
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("5★",
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                    Text("1,2 KM",
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}