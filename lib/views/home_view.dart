import 'package:dio_cep_manager/repository/cep_repository.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final String title;

  const HomeView({super.key, required this.title});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? address;
  TextEditingController cepController = TextEditingController();

  void _clearFields() {
    setState(() {
      cepController.clear();
      address = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cepRepository = CepRepository();
    final InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.deepPurple),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Consulte o CEP:", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16.0),
            // todo: fix the input field
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'CEP',
                hintText: 'Digite o CEP',
                border: inputBorder,
                focusedBorder: inputBorder,
                disabledBorder: inputBorder,
                enabledBorder: inputBorder,
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black),
                  onPressed: () {
                    cepController.clear();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String? cep = cepController.text;
                    if (cep.isNotEmpty) {
                      await cepRepository.getViaCep(cep);
                      await cepRepository.postCep(cep);
                      setState(() {});
                    }
                  },
                  child: const Text('Consultar CEP'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: const Text('Limpar'),
                ),
              ],
            ),
            if (address != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Endereço: $address',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 40.0),
            const Text("CEP's pesquisados:", style: TextStyle(fontSize: 20)),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: CepRepository().getCeps(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar CEPs'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index]),
                          // todo: add on tap to show the address
                          onTap: () {},
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
