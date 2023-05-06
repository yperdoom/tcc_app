

{
  Future<dynamic> _addMeal() async {
    var prescriptionUpdated = {};

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: AutoSizeText(
                          'Adaptar refeição: ',
                          style: TextStyle(fontSize: 18),
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<Object>(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.home_outlined),
                            label: const Text('Prescrição'),
                            labelStyle: TextStyle(
                              color: Cores.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          isExpanded: true,
                          value: prescriptionUpdated['prescription_id'],
                          items: prescriptionReceived.map<DropdownMenuItem<Object>>((prescription) {
                            return DropdownMenuItem(
                              value: prescription['prescription_id'],
                              child: Text('${prescription['name']}'),
                            );
                          }).toList(),
                          hint: const Text('Selecione uma prescrição'),
                          onChanged: (newValue) {
                            prescriptionUpdated['prescription_id'] = newValue;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.person_outlined),
                            label: const Text('Nome'),
                            labelStyle: TextStyle(
                              color: Cores.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            prescriptionUpdated['name'] = value;
                          },
                          maxLength: 30,
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _editMeals(index),
                          child: Container(
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
                                        '${mealReceived[index]['name']}',
                                        style: const TextStyle(fontSize: 24),
                                        maxLines: 1,
                                        minFontSize: 18,
                                      ),
                                    ),
                                    Text('${mealReceived[index]['type']}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${mealReceived[index]['calorie']} Kcal'),
                                    Text(
                                        'Atualizado em: ${mealReceived[index]['updated_at']}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Cores.blue),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(
                                color: Cores.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Cores.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => {},
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Cores.blue),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(
                                color: Cores.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          child: Text(
                            'Salvar',
                            style: TextStyle(
                              color: Cores.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }   
}
