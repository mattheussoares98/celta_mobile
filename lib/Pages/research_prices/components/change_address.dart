import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class ChangeAddress extends StatelessWidget {
  const ChangeAddress({super.key});

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              researchPricesProvider.selectedConcurrent?.Address!.Zip != "" &&
                      researchPricesProvider.selectedConcurrent?.Address!.Zip !=
                          null
                  ? "Alterar endereço"
                  : "Inserir endereço",
              style: const TextStyle(
                color: Color.fromARGB(255, 126, 126, 126),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(
              color: Colors.grey,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: Column(
              children: [
                AddressComponent(
                  addAddress: (address) {
                    return false;
                  }, //TODO create function to add new address
                  addresses: [], //TODO test this a lot
                  canInsertMoreThanOneAddress: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
