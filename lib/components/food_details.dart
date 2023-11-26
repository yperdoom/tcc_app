import 'package:Yan/components/get_based_quantity.dart';
import 'package:Yan/components/regex_date_time.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Future<dynamic> showFoodDetails(BuildContext context, var food) {
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
                const Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        'Abaixo verá informações sobre o alimento selecionado:',
                        style: TextStyle(fontSize: 18),
                        maxLines: 2,
                        minFontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        '${food['name']}',
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AutoSizeText(
                        '${food['type']}',
                        style: const TextStyle(fontSize: 18),
                        maxLines: 1,
                        minFontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        '${food['description']}',
                        style: const TextStyle(fontSize: 18),
                        maxLines: 1,
                        minFontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        'Calorias: ${food['calorie']} Kcal',
                        style: const TextStyle(fontSize: 18),
                        maxLines: 1,
                        minFontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        'Carboidratos: ${food['carbohydrate']}g',
                        style: const TextStyle(fontSize: 18),
                        maxLines: 1,
                        minFontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        'Proteinas: ${food['protein']}g',
                        style: const TextStyle(fontSize: 18),
                        maxLines: 1,
                        minFontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        'Lipídios: ${food['lipid']}g',
                        style: const TextStyle(fontSize: 18),
                        maxLines: 1,
                        minFontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        getBasedQuantity(food),
                        style: const TextStyle(fontSize: 16),
                        maxLines: 1,
                        minFontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      'Última vez atualizado em:',
                      style: TextStyle(fontSize: 18),
                      maxLines: 1,
                      minFontSize: 12,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      regexDateTime(food['updated_at']),
                      style: const TextStyle(fontSize: 18),
                      maxLines: 1,
                      minFontSize: 12,
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
