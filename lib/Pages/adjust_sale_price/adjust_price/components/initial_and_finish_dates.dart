import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/providers.dart';

class InitialAndFinishDates extends StatefulWidget {
  final String initialDate;
  final String finishDate;
  final Function() updateInitialDate;
  final Function() updateFinishDate;
  const InitialAndFinishDates({
    required this.initialDate,
    required this.finishDate,
    required this.updateInitialDate,
    required this.updateFinishDate,
    super.key,
  });

  @override
  State<InitialAndFinishDates> createState() => _InitialAndFinishDatesState();
}

class _InitialAndFinishDatesState extends State<InitialAndFinishDates> {
  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return Column(
      children: [
        const Divider(),
        IntrinsicHeight(
          child: Row(
            children: [
              _updateDateWidget(
                date: widget.initialDate,
                updateDate: widget.updateInitialDate,
                isInitialDate: true,
              ),
              if (adjustSalePriceProvider.offerPriceIsSelected())
                Expanded(
                  child: Row(
                    children: [
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 0.2,
                      ),
                      _updateDateWidget(
                        date: widget.finishDate,
                        updateDate: widget.updateFinishDate,
                        isInitialDate: false,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _updateDateWidget({
  required String date,
  required Function() updateDate,
  required bool isInitialDate,
}) {
  return Expanded(
    child: Column(
      children: [
        Text(
          isInitialDate ? "Data de início" : "Data de término",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Text(date),
        TextButton(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Alterar data",
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 10),
              Icon(Icons.date_range)
            ],
          ),
          onPressed: updateDate,
        ),
      ],
    ),
  );
}
