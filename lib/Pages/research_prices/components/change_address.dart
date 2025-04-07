import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/models.dart';
import '../../../components/components.dart';
import '../../../providers/providers.dart';

class ChangeAddress extends StatelessWidget {
  final AddressModel? newAddress;
  const ChangeAddress({
    super.key,
    required this.newAddress,
  });

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              researchPricesProvider.selectedConcurrent?.Address?.Zip != "" &&
                      researchPricesProvider.selectedConcurrent?.Address?.Zip !=
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
                    final selectedConcurrent =
                        researchPricesProvider.selectedConcurrent;
                    researchPricesProvider.updateSelectedConcurrent(
                      ResearchPricesConcurrentsModel(
                        ConcurrentCode: selectedConcurrent?.ConcurrentCode,
                        Name: selectedConcurrent?.Name,
                        Observation: selectedConcurrent?.Observation,
                        Address: newAddress,
                      ),
                    );
                    return true;
                  },
                  addresses: [
                    if (newAddress != null) newAddress!,
                  ],
                  canInsertMoreThanOneAddress: false,
                  removeAddress: (index) {
                    final selectedConcurrent =
                        researchPricesProvider.selectedConcurrent;

                    researchPricesProvider.updateSelectedConcurrent(
                        ResearchPricesConcurrentsModel(
                      ConcurrentCode: selectedConcurrent?.ConcurrentCode,
                      Name: selectedConcurrent?.Name,
                      Observation: selectedConcurrent?.Observation,
                      Address: null,
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
