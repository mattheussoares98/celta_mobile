import 'package:celta_inventario/Models/buy_request_models/buy_request_supplier_model.dart';
import 'package:celta_inventario/components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestSuplliers extends StatefulWidget {
  const BuyRequestSuplliers({Key? key}) : super(key: key);

  @override
  State<BuyRequestSuplliers> createState() => _BuyRequestSuplliersState();
}

class _BuyRequestSuplliersState extends State<BuyRequestSuplliers> {
  TextEditingController searchValueController = TextEditingController();
  FocusNode focusNodeConsultProduct = FocusNode();
  int _groupValue = -1;

  void updateSelectedSupplier({
    required int? value,
    required BuyRequestProvider buyRequestProvider,
    required BuyRequestSupplierModel supplier,
  }) {
    if (buyRequestProvider.selectedSupplier != null &&
        (buyRequestProvider.enterprisesCount > 0 ||
            buyRequestProvider.productsInCartCount > 0)) {
      ShowAlertDialog.showAlertDialog(
        context: context,
        title: "Alterar fornecedor",
        subtitle:
            "Se você alterar o fornecedor, todas empresas e produtos serão removidos do pedido de compras.\n\nDeseja realmente alterar o fornecedor?",
        function: () {
          setState(() {
            _groupValue = value!;
          });
          buyRequestProvider.selectedSupplier = supplier;
        },
      );
    } else {
      setState(() {
        _groupValue = value!;
      });
      buyRequestProvider.selectedSupplier = supplier;
    }
  }

  Future<void> getSuppliers(BuyRequestProvider buyRequestProvider) async {
    _groupValue = -1;
    await buyRequestProvider.getSuppliers(
      context: context,
      searchValue: searchValueController.text,
    );
    if (buyRequestProvider.suppliersCount > 0) {
      searchValueController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    _groupValue = buyRequestProvider.suppliers.indexWhere((element) =>
        element.CnpjCpfNumber ==
        buyRequestProvider.selectedSupplier?.CnpjCpfNumber);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchWidget(
          showConfigurationsIcon: false,
          hintText: "Fornecedor",
          labelText: "Consultar fornecedor",
          useCamera: false,
          autofocus: false,
          consultProductController: searchValueController,
          isLoading: buyRequestProvider.isLoadingSupplier,
          onPressSearch: () async {
            if (buyRequestProvider.enterprisesCount > 0) {
              ShowAlertDialog.showAlertDialog(
                context: context,
                title: "Pesquisar fornecedores",
                subtitle:
                    "Se você consultar os fornecedores novamente, todas empresas e produtos serão removidos.\n\nDeseja realmente pesquisar novamente?",
                function: () async {
                  await getSuppliers(buyRequestProvider);
                },
              );
            } else {
              await getSuppliers(buyRequestProvider);
            }
          },
          focusNodeConsultProduct: focusNodeConsultProduct,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: buyRequestProvider.suppliersCount,
          itemBuilder: (context, index) {
            BuyRequestSupplierModel supplier =
                buyRequestProvider.suppliers[index];

            return Card(
              child: RadioListTile(
                selected: supplier.CnpjCpfNumber ==
                    buyRequestProvider.selectedSupplier?.CnpjCpfNumber,
                groupValue: _groupValue,
                value: index,
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
                onChanged: (int? value) {
                  updateSelectedSupplier(
                    value: value,
                    buyRequestProvider: buyRequestProvider,
                    supplier: supplier,
                  );
                },
                subtitle: Column(
                  children: [
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Código",
                      value: supplier.Code.toString(),
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Nome",
                      value: supplier.Name,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Nome fantasia",
                      value: supplier.FantasizesName,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "CPF/CNPJ",
                      value: supplier.CnpjCpfNumber,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Tipo de comércio",
                      value: supplier.SupplierType,
                    ),
                    if (supplier.Addresses != null)
                      Text(supplier.Addresses.toString()),
                    if (supplier.Telephones != null)
                      Text(supplier.Telephones.toString()),
                    if (supplier.Emails != null)
                      Text(supplier.Emails.toString()),
                  ],
                ),
              ),
            );
          },
        ),
        if (buyRequestProvider.isLoadingSupplier)
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Text(
                      "Consultando fornecedores",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        if (buyRequestProvider.errorMessageSupplier != "")
          Text(
            buyRequestProvider.errorMessageSupplier,
            style: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}