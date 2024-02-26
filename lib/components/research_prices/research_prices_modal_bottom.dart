import 'package:flutter/material.dart';

import '../../providers/providers.dart';
import '../global_widgets/global_widgets.dart';

researchPricesModalBottom({
  required BuildContext context,
  required bool isNewResearch,
  required bool isLoading,
  required String name,
  required String observations,
  required ResearchPricesProvider researchPricesProvider,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: ((context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                isNewResearch
                    ? "Nova pesquisa de preços"
                    : "Alterar pesquisa de preços",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: "OpenSans",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: FormFieldHelper.decoration(
                  isLoading: isLoading,
                  context: context,
                  labelText: "Nome",
                ),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Digite o nome";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: FormFieldHelper.decoration(
                  isLoading: isLoading,
                  context: context,
                  labelText: "Observações",
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                    onPressed: () async {
                      await researchPricesProvider.addOrUpdateResearch(
                        context: context,
                        isNewResearch: isNewResearch,
                        name: name,
                        observations: observations,
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Salvar")),
              )
            ],
          ),
        ),
      );
    }),
  );
}
