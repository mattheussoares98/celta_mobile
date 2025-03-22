import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../Models/models.dart';
import '../../../providers/providers.dart';
import './components/components.dart';

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
  List<ModuleModel> modules = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;
      SubEnterpriseModel? selectedSubEnterprise =
          arguments?["selectedSubEnterprise"];

      if (selectedSubEnterprise != null) {
        _cnpjController.text = selectedSubEnterprise.cnpj.toString();
        _surnameController.text = selectedSubEnterprise.surname.toString();
      }

      setState(() {
        modules = [
          ModuleModel(
            module: Modules.adjustSalePrice.name,
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.adjustSalePrice.name)
                    .first
                    .enabled ??
                false,
            name: "Ajuste de preços",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.adjustStock.name)
                    .first
                    .enabled ??
                false,
            module: Modules.adjustStock.name,
            name: "Ajuste de estoques",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.buyQuotation.name)
                    .first
                    .enabled ??
                false,
            module: Modules.buyQuotation.name,
            name: "Cotação de compras",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.buyRequest.name)
                    .first
                    .enabled ??
                false,
            module: Modules.buyRequest.name,
            name: "Pedido de compra",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.customerRegister.name)
                    .first
                    .enabled ??
                false,
            module: Modules.customerRegister.name,
            name: "Cadastro de cliente",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.inventory.name)
                    .first
                    .enabled ??
                false,
            module: Modules.inventory.name,
            name: "Inventário",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.priceConference.name)
                    .first
                    .enabled ??
                false,
            module: Modules.priceConference.name,
            name: "Consulta de preços",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.productsConference.name)
                    .first
                    .enabled ??
                false,
            module: Modules.productsConference.name,
            name: "Conferência de produtos (expedição)",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.receipt.name)
                    .first
                    .enabled ??
                false,
            module: Modules.receipt.name,
            name: "Recebimento",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.researchPrices.name)
                    .first
                    .enabled ??
                false,
            module: Modules.researchPrices.name,
            name: "Consulta de preços concorrentes",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.saleRequest.name)
                    .first
                    .enabled ??
                false,
            module: Modules.saleRequest.name,
            name: "Pedido de vendas",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where(
                        (e) => e.module == Modules.transferBetweenStocks.name)
                    .first
                    .enabled ??
                false,
            module: Modules.transferBetweenStocks.name,
            name: "Transferência entre estoques",
          ),
          ModuleModel(
            enabled: selectedSubEnterprise?.modules
                    ?.where((e) => e.module == Modules.transferRequest.name)
                    .first
                    .enabled ??
                false,
            module: Modules.transferRequest.name,
            name: "Pedido de transferência",
          ),
        ];
      });
    });
  }

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

    Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    SubEnterpriseModel? selectedSubEnterprise =
        arguments?["selectedSubEnterprise"];
    bool updatingAllSubenterprises =
        arguments?["updatingAllSubenterprises"] ?? false;

    if (updatingAllSubenterprises) {
      ShowAlertDialog.show(
          context: context,
          title: 'Atualizar todas empresas',
          content: Text(
              "Deseja realmente igualar todos módulos em todas as sub empresas?"),
          function: () async {
            await webProvider.updateModulesInAllSubEnterprises(modules);
          });
    } else {
      await webProvider.addUpdateEnterprise(
        context: context,
        enterpriseNameController: _enterpriseController,
        urlCcsController: _urlCcsController,
        isAddinSubEnterprise: selectedSubEnterprise == null,
        subEnterpriseToAdd: SubEnterpriseModel(
          modules: modules,
          cnpj: _cnpjController.text,
          surname: _surnameController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);
    Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    SubEnterpriseModel? selectedSubEnterprise =
        arguments?["selectedSubEnterprise"];
    bool updatingAllSubenterprises =
        arguments?["updatingAllSubenterprises"] ?? false;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: FittedBox(
              child: Text(
                updatingAllSubenterprises
                    ? "Atualizando todas sub empresas"
                    : selectedSubEnterprise == null
                        ? "Adicionando sub empresa"
                        : "Editando sub empresa",
              ),
            ),
          ),
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
                          if (!updatingAllSubenterprises)
                            CnpjAndSurnameInput(
                              cnpjController: _cnpjController,
                              cnpjFocusNode: _cnpjFocusNode,
                              surnameController: _surnameController,
                              surnameFocusNode: _surnameFocusNode,
                              selectedSubEnterprise: selectedSubEnterprise,
                            ),
                          EnableOrDisableModule(
                            modules: modules,
                            updateEnabled:
                                webProvider.isGeneratingVersionToAdministration
                                    ? (index) {
                                        final oldModule = modules[index];
                                        setState(() {
                                          modules[index] = ModuleModel(
                                            name: oldModule.name,
                                            enabled: !oldModule.enabled,
                                            module: oldModule.module,
                                          );
                                        });
                                      }
                                    : null,
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
                          child: Text(
                            updatingAllSubenterprises
                                ? "Alterando todas sub empresas"
                                : selectedSubEnterprise == null
                                    ? "Adicionando sub empresa"
                                    : "Alterar",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        loadingWidget(webProvider.isLoading),
      ],
    );
  }
}
