import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../global_widgets/global_widgets.dart';

class ConcurrentsModalBottom extends StatefulWidget {
  const ConcurrentsModalBottom({super.key});

  @override
  State<ConcurrentsModalBottom> createState() => _ConcurrentsModalBottomState();
}

class _ConcurrentsModalBottomState extends State<ConcurrentsModalBottom> {
  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return AlertDialog(
      contentPadding:const EdgeInsets.all(0),
      content: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                // isNewResearch
                //     ? "Nova pesquisa de preços"
                //     :
                "Criar concorrente",
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
                  isLoading: false,
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
                  isLoading: false,
                  context: context,
                  labelText: "Observações",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: FormFieldHelper.decoration(
                  isLoading: false,
                  context: context,
                  labelText: "Endereço",
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                    onPressed: () async {
                      await researchPricesProvider.createConcurrentPrices(
                          context: context);

                      if (researchPricesProvider.errorConcurrents != "") {
                        ShowSnackbarMessage.showMessage(
                          message: researchPricesProvider.errorConcurrents,
                          context: context,
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text(
                      "Salvar",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

concurrentsModalBottom({
  required BuildContext context,
}) {
  ResearchPricesProvider researchPricesProvider = Provider.of(context);
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            children: [
              const Text(
                // isNewResearch
                //     ? "Nova pesquisa de preços"
                //     :
                "Criar concorrente",
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
                  isLoading: false,
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
                  isLoading: false,
                  context: context,
                  labelText: "Observações",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: FormFieldHelper.decoration(
                  isLoading: false,
                  context: context,
                  labelText: "Endereço",
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                    onPressed: () async {
                      await researchPricesProvider.createConcurrentPrices(
                          context: context);

                      if (researchPricesProvider.errorConcurrents != "") {
                        ShowSnackbarMessage.showMessage(
                          message: researchPricesProvider.errorConcurrents,
                          context: context,
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text(
                      "Salvar",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              )
            ],
          ),
        );
      });
  // return showModalBottomSheet(
  //   context: context,
  //   isScrollControlled: true,
  //   useSafeArea: true,
  //   builder: ((context) {
  //     return SingleChildScrollView(
  //       child: Container(
  //         height: MediaQuery.of(context).size.height * 0.75,
  //         child: ListView(
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.fromLTRB(
  //                   8, 8, 8, MediaQuery.of(context).viewInsets.bottom),
  //               child: Column(
  //                 children: [
  //                   const Text(
  //                     // isNewResearch
  //                     //     ? "Nova pesquisa de preços"
  //                     //     :
  //                     "Criar concorrente",
  //                     textAlign: TextAlign.center,
  //                     style: const TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                       fontStyle: FontStyle.italic,
  //                       fontFamily: "OpenSans",
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   TextFormField(
  //                     decoration: FormFieldHelper.decoration(
  //                       isLoading: false,
  //                       context: context,
  //                       labelText: "Nome da pesquisa",
  //                     ),
  //                     validator: (value) {
  //                       if (value?.isEmpty == true) {
  //                         return "Digite o nome";
  //                       }

  //                       return null;
  //                     },
  //                   ),
  //                   const SizedBox(height: 8),
  //                   TextFormField(
  //                     decoration: FormFieldHelper.decoration(
  //                       isLoading: false,
  //                       context: context,
  //                       labelText: "Observações",
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   TextFormField(
  //                     decoration: FormFieldHelper.decoration(
  //                       isLoading: false,
  //                       context: context,
  //                       labelText: "Endereço",
  //                     ),
  //                   ),
  //                   Align(
  //                     alignment: Alignment.topRight,
  //                     child: TextButton.icon(
  //                         onPressed: () async {
  //                           await researchPricesProvider.createConcurrentPrices(
  //                               context: context);
  //                         },
  //                         icon: const Icon(Icons.save),
  //                         label: const Text(
  //                           false ? "Salvando" : "Salvar",
  //                           style: const TextStyle(
  //                             fontSize: 20,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         )),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }),
  // );
}
