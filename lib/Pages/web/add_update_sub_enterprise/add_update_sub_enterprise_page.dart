import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import '../../../providers/providers.dart';
import 'components/components.dart';

class AddUpdateSubEnterprisePage extends StatefulWidget {
  const AddUpdateSubEnterprisePage({super.key});

  @override
  State<AddUpdateSubEnterprisePage> createState() =>
      _AddUpdateSubEnterprisePageState();
}

class _AddUpdateSubEnterprisePageState
    extends State<AddUpdateSubEnterprisePage> {
  final _enterpriseController = TextEditingController();
  final _urlCcsController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _surnameController = TextEditingController();
  final _ccsFocusNode = FocusNode();
  final _enterpriseFocusNode = FocusNode();
  final _cnpjFocusNode = FocusNode();
  final _surnameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final modules = [
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
  ];

  @override
  void dispose() {
    super.dispose();
    _enterpriseController.dispose();
    _urlCcsController.dispose();
    _cnpjController.dispose();
    _surnameController.dispose();
    _ccsFocusNode.dispose();
    _enterpriseFocusNode.dispose();
    _cnpjFocusNode.dispose();
    _surnameFocusNode.dispose();
  }

  Future<void> addUpdateEnterprise(WebProvider webProvider) async {
    bool? isValid = _formKey.currentState?.validate();

    if (isValid != true) {
      return;
    }

    await webProvider.addUpdateEnterprise(
      context: context,
      enterpriseNameController: _enterpriseController,
      urlCcsController: _urlCcsController,
      subEnterpriseToAdd: SubEnterpriseModel(
        modules: modules,
        cnpj: _cnpjController.text.toInt(),
        surname: _surnameController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (webProvider.indexOfSelectedEnterprise == -1)
                        EnterpriseNameInput(
                          enterpriseController: _enterpriseController,
                          enterpriseFocusNode: _enterpriseFocusNode,
                          ccsFocusNode: _ccsFocusNode,
                        ),
                      if (webProvider.indexOfSelectedEnterprise == -1)
                        CcsUrlInput(
                          urlCcsController: _urlCcsController,
                          ccsFocusNode: _ccsFocusNode,
                          cnpjFocusNode: _cnpjFocusNode,
                        ),
                      CnpjAndSurnameInput(
                        cnpjController: _cnpjController,
                        cnpjFocusNode: _cnpjFocusNode,
                        surnameController: _surnameController,
                        surnameFocusNode: _surnameFocusNode,
                      ),
                      EnableOrDisableModule(
                        modules: modules,
                        updateEnabled: (index) {
                          final oldModule = modules[index];
                          setState(() {
                            modules[index] = ModuleModel(
                              name: oldModule.name,
                              enabled: !oldModule.enabled,
                              module: oldModule.module,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancelar",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await addUpdateEnterprise(webProvider);
                      },
                      child: const Text("Adicionar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
