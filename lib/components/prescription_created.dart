import 'prepare_foods_to_show.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../configs/colors.dart';

Widget prescriptionCreated(var meals) {
  return Expanded(
    child: ListView.builder(
      itemCount: meals.length,
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
                    child: AutoSizeText(
                      '${meals[index]['name']}',
                      style: TextStyle(
                        fontSize: 24,
                        color: Cores.white,
                      ),
                      maxLines: 1,
                      minFontSize: 18,
                    ),
                  ),
                  Text(
                    '${meals[index]['type']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Cores.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      prepareFoodsToShow(meals[index]['foods']),
                      style: TextStyle(
                        fontSize: 24,
                        color: Cores.white,
                      ),
                      maxLines: 2,
                      minFontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
