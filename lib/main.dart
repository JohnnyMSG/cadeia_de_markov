import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculo Matriz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CADEIAS DE MARKOV'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int tamanhoDaMatriz = 3;
  double soma = 0;
  List<TextEditingController> tabela1 = [];
  List<TextEditingController> listaMatriz = [];

  void aumentarMatriz() {
    setState(() {
      if (tamanhoDaMatriz < 20) {
        tamanhoDaMatriz++;
      }
    });
  }

  void diminuirMatriz() {
    setState(() {
      if (tamanhoDaMatriz > 1) {
        tamanhoDaMatriz--;
      }
    });
  }

  void iniciar() {
    tabela1.clear();
    listaMatriz.clear();

    for (int t = 0; t < tamanhoDaMatriz; t++) {
      final TextEditingController t1 = TextEditingController();
      t1.text = "0";
      tabela1.add(t1);
    }

    for (int m = 0; m < tamanhoDaMatriz * tamanhoDaMatriz; m++) {
      final TextEditingController m1 = TextEditingController();
      m1.text = "0.0";
      listaMatriz.add(m1);
    }
  }

  void calcularMatriz() {
    print(tabela1.length);
    print(listaMatriz.length);

    String resultado = '';

    double somaTempT1 = 0;
    for (int i = 0; i < tabela1.length; i++) {
      somaTempT1 += double.tryParse(tabela1[i].text)! / 100;
    }

    if (somaTempT1 != 1) {
      resultado = "Tabela 1 está diferente de 100%";
      print("Tabela1: ${somaTempT1.toStringAsFixed(2)}");
    } else {
      int numberOfRows = listaMatriz.length ~/ tamanhoDaMatriz;
      print(numberOfRows);

      for (int i = 0; i < numberOfRows; i++) {
        double somaLinha = 0;
        for (int j = 0; j < tamanhoDaMatriz; j++) {
          somaLinha += double.tryParse(listaMatriz[i * tamanhoDaMatriz + j].text) ?? 0;
        }
        print("Soma da linha ${i + 1}: ${somaLinha.toStringAsFixed(2)}");

        if (somaLinha != 1) {
          resultado = "Soma da linha ${i + 1} está diferente de 100%";
          break;
        }
      }

      // nova parte da função
      if (resultado.isEmpty) {
        List<double> resultados = List.filled(tamanhoDaMatriz, 0.0);
        for (int i = 0; i < tamanhoDaMatriz; i++) {
          for (int j = 0; j < tamanhoDaMatriz; j++) {
            double valorTabela1 = double.tryParse(tabela1[j].text)! / 100;
            double valorTabela2 = double.tryParse(listaMatriz[j * tamanhoDaMatriz + i].text) ?? 0.0;
            resultados[i] += valorTabela1 * valorTabela2;
          }
        }

        resultado = "Resultado:\n";
        resultado += "[";
        for (int i = 0; i < resultados.length; i++) {
          resultado += "${resultados[i].toStringAsFixed(2)}  ";
        }
        resultado += "]";
      }

    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Resultado'),
          content: Text(
            resultado,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    iniciar();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.transparent,
        child: Stack(
          children: [
            ListView(
              children: [
                Column(
                  children: [
                    /// Tabela 1
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Tabela 1 (%)",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              for (int i = 0; i < tamanhoDaMatriz; i++)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 5, left: 30, right: 28),
                                  child: Text(
                                    'Coluna ${i + 1}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              for (int t = 0; t < tamanhoDaMatriz; t++)
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    width: 120,
                                    child: TextField(
                                      maxLines: null,
                                      controller: tabela1[t],
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("(%)")
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// Tabela 2
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Tabela 2",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 80),
                              for (int i = 0; i < tamanhoDaMatriz; i++)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 25, right: 37),
                                  child: Text(
                                    'para ${i + 1}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          for (int i = 0; i < tamanhoDaMatriz; i++)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    "de ${i + 1}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                for (int j = 0; j < tamanhoDaMatriz; j++)
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      width: 100,
                                      child: TextField(
                                        maxLines: null,
                                        controller: listaMatriz[i * tamanhoDaMatriz + j],
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    )

                  ],
                ),
              ],
            ),

            // Adicionar
            Padding(
              padding: const EdgeInsets.only(bottom: 140, right: 10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () {
                      aumentarMatriz();
                    },
                    child: Container(
                      height: 50,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Remover
            Padding(
              padding: const EdgeInsets.only(bottom: 80, right: 10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () {
                      diminuirMatriz();
                    },
                    child: Container(
                      height: 50,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Calcular
            Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () {
                      calcularMatriz();
                    },
                    child: Container(
                      height: 50,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Text(
                          "=",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
