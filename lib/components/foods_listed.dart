import 'package:Yan/components/food_details.dart';
import 'package:Yan/configs/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget foodsListed(var foods) {
  if (foods.isNotEmpty) {
    // retorna os cartões
    return Expanded(
      child: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => showFoodDetails(context, foods[index]),
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
              decoration: BoxDecoration(color: Cores.blueDark, borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          '${foods[index]['name']}',
                          style: TextStyle(
                            fontSize: 24,
                            color: Cores.white,
                          ),
                          maxLines: 1,
                          minFontSize: 18,
                        ),
                      ),
                      Text(
                        '${foods[index]['type']}',
                        style: TextStyle(
                          color: Cores.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          '${foods[index]['description']}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Cores.white,
                          ),
                          maxLines: 3,
                          minFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${foods[index]['calorie']} Kcal em ${foods[index]['weight']}g',
                        style: TextStyle(
                          color: Cores.white,
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
  return Expanded(
    child: Text(
      'Não temos nada aqui no momento :(',
      style: TextStyle(
        color: Cores.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
