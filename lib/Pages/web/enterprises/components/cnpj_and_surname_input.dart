import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';

class CnpjAndSurnameInput extends StatelessWidget {
  final TextEditingController cnpjController;
  final FocusNode cnpjFocusNode;
  final TextEditingController surnameController;
  final FocusNode surnameFocusNode;

  const CnpjAndSurnameInput({
    required this.cnpjController,
    required this.cnpjFocusNode,
    required this.surnameController,
    required this.surnameFocusNode,
    super.key,
  });

  static final cnpjFormKey = GlobalKey<FormState>();

  void addSubEnterprise(WebProvider webProvider) {
    bool? isValid = cnpjFormKey.currentState?.validate();

    if (isValid != true) {
      return;
    }

    webProvider.addNewCnpj(
      SubEnterpriseModel(
          surname: surnameController.text,
          cnpj: cnpjController.text.toInt(),
          modules: [
            ModuleModel(
              module: Modules.adjustSalePrice.name,
              enabled: true,
              name: "Ajuste de preços",
            ),
            ModuleModel(
              module: Modules.adjustStock.name,
              enabled: true,
              name: "Ajuste de estoques",
            ),
            ModuleModel(
              module: Modules.buyQuotation.name,
              enabled: true,
              name: "Cotação de compras",
            ),
            ModuleModel(
              module: Modules.buyRequest.name,
              enabled: true,
              name: "Pedido de compra",
            ),
            ModuleModel(
              module: Modules.customerRegister.name,
              enabled: true,
              name: "Cadastro de cliente",
            ),
            ModuleModel(
              module: Modules.inventory.name,
              enabled: true,
              name: "Inventário",
            ),
            ModuleModel(
              module: Modules.priceConference.name,
              enabled: true,
              name: "Consulta de preços",
            ),
            ModuleModel(
              module: Modules.productsConference.name,
              enabled: true,
              name: "Conferência de produtos (expedição)",
            ),
            ModuleModel(
              module: Modules.receipt.name,
              enabled: true,
              name: "Recebimento",
            ),
            ModuleModel(
              module: Modules.researchPrices.name,
              enabled: true,
              name: "Consulta de preços concorrentes",
            ),
            ModuleModel(
              module: Modules.saleRequest.name,
              enabled: true,
              name: "Pedido de vendas",
            ),
            ModuleModel(
              module: Modules.transferBetweenStocks.name,
              enabled: true,
              name: "Transferência entre estoques",
            ),
            ModuleModel(
              module: Modules.transferRequest.name,
              enabled: true,
              name: "Pedido de transferência",
            ),
          ]),
    );
    surnameController.clear();
    cnpjController.clear();
    Future.delayed(Duration.zero, () {
      cnpjFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return Form(
      key: cnpjFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cnpjController,
                    focusNode: cnpjFocusNode,
                    validator: (value) {
                      if (value != null &&
                          webProvider
                                  .enterprises[
                                      webProvider.indexOfSelectedEnterprise]
                                  .subEnterprises!
                                  .indexWhere((e) => e.cnpj == value.toInt()) !=
                              -1) {
                        return "CNPJ já adicionado";
                      }
                      return FormFieldValidations.cpfOrCnpj(value);
                    },
                    onFieldSubmitted: (value) async {
                      if (value.isEmpty) {
                        Future.delayed(Duration.zero, () {
                          cnpjFocusNode.requestFocus();
                        });
                      } else {
                        surnameFocusNode.requestFocus();
                      }
                    },
                    decoration: FormFieldDecoration.decoration(
                      context: context,
                      hintText: "Somente números",
                      labelText: "CNPJ",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: surnameController,
                    focusNode: surnameFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      addSubEnterprise(webProvider);
                    },
                    decoration: FormFieldDecoration.decoration(
                      context: context,
                      hintText: "Apelido",
                      labelText: "Apelido",
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    addSubEnterprise(webProvider);
                  },
                  label: Text("Adicionar"),
                  icon: Icon(
                    Icons.verified_sharp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              webProvider.subEnterprises.isEmpty
                  ? "Adicione pelo menos um CNPJ"
                  : "CNPJs adicionados",
            ),
          ),
          Card(
            child: ListView.builder(
              itemCount: webProvider.subEnterprises.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        index % 2 == 0 ? Colors.grey[200] : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text((webProvider.subEnterprises[index].surname ??
                                      "") +
                                  " -"),
                              const SizedBox(width: 8),
                              Text(webProvider.subEnterprises[index].cnpj
                                  .toString()),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          webProvider.removeCnpj(index);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
