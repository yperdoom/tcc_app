import 'package:Yan/components/auto_sized_text.dart';
import 'package:flutter/material.dart';
import '../configs/colors.dart';

Widget prescriptionAdapted(var foods) {
  print('foods :: $foods');
  return Expanded(
    child: ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) {
        return Container(
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
          decoration: BoxDecoration(
            color: Cores.blueDark,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: autoSizedText('${foods[index]['name']}'),
                  ),
                  autoSizedText('${foods[index]['type']}')
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: autoSizedText('${foods[index]['description']}'),
                  ),
                  autoSizedText('Necessário consumir: ${foods[index]['weight']}g'),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
