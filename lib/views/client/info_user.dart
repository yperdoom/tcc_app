import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../configs/session.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

class InfoUser extends StatefulWidget {
  const InfoUser({super.key});

  @override
  State<InfoUser> createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  var infoReceived = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'dash',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    Color(0xff1E4CFF),
                    Color(0xff517AFF),
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: const Text(
                          'Informações',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Expanded(
                        child: Text(
                          'Aqui voce encontra informações relacionadas a nutrição.',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Color(0xffBDD6D8),
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xff1E2429),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.search_rounded),
                              hintText: 'Pesquise por informações',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            backgroundColor: const Color(0xff1E4CFF),
                          ),
                          onPressed: () => {},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 3,
                            ),
                            child: Text(
                              'Buscar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          _FindList(),
        ],
      ),
    );
  }

  Widget _FindList() {
    _getInfos();

    if (infoReceived.isNotEmpty) {
      // retorna os cartões
      return Expanded(
        child: ListView.builder(
          itemCount: infoReceived.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: showInfoDetails,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 12,
                  bottom: 10,
                  right: 12,
                ),
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 5,
                  bottom: 8,
                  right: 10,
                ),
                decoration: const BoxDecoration(
                    color: Color(0xff1E2429),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            '${infoReceived[index]['name']}',
                            style: const TextStyle(fontSize: 24),
                            maxLines: 1,
                            minFontSize: 18,
                          ),
                        ),
                          Text('Atualizado em: ${infoReceived[index]['updated_at']}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            '${infoReceived[index]['description']}',
                            style: const TextStyle(fontSize: 18),
                            maxLines: 3,
                            minFontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    // retorna mensagem que não tem nada
    return const Expanded(
      child: Text(
        'Não temos nada aqui no momento :(',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _getInfos() async {
    if (Session.env == 'local') {
      const infos = [
        {
          "food_id": 1,
          "name": "Caloria",
          "description":
              "arroz branco cozido em temperatura média para testar o tamanho de palavras porque pode caber muitas palavras aqui e ainda ter espaço para mais palavras meu deus como tem muitas palavras",
          "updated_at": '05/10/2020'
        },
        {
          "food_id": 2,
          "name": "Proteina",
          "description": "feijao branco cozido",
          "updated_at": '05/10/2020'
        },
        {
          "food_id": 3,
          "name": "Carboidrato",
          "description": "peito de frango cozido",
          "updated_at": '05/10/2028'
        },
        {
          "food_id": 4,
          "name": "Lipídio",
          "description": "cozido",
          "updated_at": '05/10/2028'
        }
      ];

      infoReceived = infos;
    } else {
      http.Response response = await http.get(
        Uri.parse('$baseUrl/prescriptions'),
      );
      print(response);
      if (response.body.isNotEmpty) {
        // infoReceived = response;
      }
    }
  }

  void showInfoDetails() async {
    return showDialog(context: context, builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18)
      ),
      child: Scaffold()
      ),
    );
  }
}
