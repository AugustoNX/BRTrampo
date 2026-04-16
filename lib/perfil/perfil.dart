import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

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

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PERFIL
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Jorge amado",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Marceneiro • 2,4 KM • 5★",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                "https://i.pravatar.cc/150?img=3"),
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      // TRABALHOS
                      const Text(
                        "Trabalhos",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        height: 140,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _cardTrabalho(),
                            _cardTrabalho(),
                            _cardTrabalho(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // CERTIFICADOS
                      const Text(
                        "Certificados",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        height: 140,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _cardCertificado(),
                            _cardCertificado(),
                            _cardCertificado(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // BOTÃO GRANDE
                      Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: verde,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardTrabalho() {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: verde,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1581090700227-1e8e8c1c8b3d"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              "Manutenção de padrão",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          )
        ],
      ),
    );
  }

  Widget _cardCertificado() {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: verde,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1581092918056-0c4c3acd3789"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              "Certificado iso 9000",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}