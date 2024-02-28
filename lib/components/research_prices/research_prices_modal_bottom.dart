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
  required int enterpriseCode,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: ((context) {
      return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    8, 8, 8, MediaQuery.of(context).viewInsets.bottom),
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
                        labelText: "Nome da pesquisa",
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
                          onPressed: isLoading
                              ? null
                              : () async {
                                  await researchPricesProvider
                                      .addOrUpdateResearch(
                                    context: context,
                                    isNewResearch: isNewResearch,
                                    name: name,
                                    observations: observations,
                                    enterpriseCode: enterpriseCode,
                                  );
                                },
                          icon: const Icon(Icons.save),
                          label: Text(
                            isLoading ? "Salvando" : "Salvar",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }),
  );
}
