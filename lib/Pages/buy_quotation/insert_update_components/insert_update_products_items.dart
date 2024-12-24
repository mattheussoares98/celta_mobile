import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../buy_quotation.dart';

class InsertUpdateProductsItems extends StatefulWidget {
  final EnterpriseModel enterprise;
  const InsertUpdateProductsItems({
    required this.enterprise,
    super.key,
  });

  @override
  State<InsertUpdateProductsItems> createState() =>
      _InsertUpdateProductsItemsState();
}

class _InsertUpdateProductsItemsState extends State<InsertUpdateProductsItems> {
  int? selectedProductIndex;
  List<Map<int, TextEditingController>> controllers = [];
  List<Map<int, FocusNode>> focusNodes = [];
  final searchProductController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        BuyQuotationProvider buyQuotationProvider =
            Provider.of(context, listen: false);

        createControllersAndFocusNode(buyQuotationProvider);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllersAndFocusNodes();
    searchProductController.dispose();
    searchFocusNode.dispose();
  }

  void createControllersAndFocusNode(
      BuyQuotationProvider buyQuotationProvider) {
    if (buyQuotationProvider.selectedEnterprises.isEmpty == true) {
      return;
    } else {
      controllers = buyQuotationProvider.selectedEnterprises
          .map((e) => {e.Code: TextEditingController()})
          .toList();
      focusNodes = buyQuotationProvider.selectedEnterprises
          .map((e) => {e.Code: FocusNode()})
          .toList();
    }
  }

  void disposeControllersAndFocusNodes() {
    for (var controller in controllers) {
      controller.values.first.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.values.first.dispose();
    }
  }

  void updateSelectedIndex({
    required int productIndex,
    required BuyQuotationProvider buyQuotationProvider,
  }) {
    if (selectedProductIndex == productIndex) {
      setState(() {
        selectedProductIndex = null;
      });
    } else {
      setState(() {
        selectedProductIndex = productIndex;
        updateControllersQuantity(
          productIndex: productIndex,
          buyQuotationProvider: buyQuotationProvider,
          controllers: controllers,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Produtos"),
        SearchProducts(
          searchProductController: searchProductController,
          enterprise: widget.enterprise,
          searchFocusNode: searchFocusNode,
        ),
        if (buyQuotationProvider.productsWithNewValues.length == 0)
          const Text("Não há produtos na cotação"),
        ListView.builder(
          shrinkWrap: true,
          itemCount: buyQuotationProvider.productsWithNewValues.length,
          itemBuilder: (context, productIndex) {
            final product =
                buyQuotationProvider.productsWithNewValues[productIndex];

            return InsertUpdateProductItem(
              productIndex: productIndex,
              selectedProductIndex: selectedProductIndex,
              updateSelectedIndex: () {
                updateSelectedIndex(
                  productIndex: productIndex,
                  buyQuotationProvider: buyQuotationProvider,
                );
                focusNodes[0].values.first.requestFocus();
              },
              product: product,
              controllers: controllers,
              focusNodes: focusNodes,
            );
          },
        ),
      ],
    );
  }
}

void updateControllersQuantity({
  required int productIndex,
  required BuyQuotationProvider buyQuotationProvider,
  required List<Map<int, TextEditingController>> controllers,
}) {
  if (buyQuotationProvider
          .productsWithNewValues[productIndex].ProductEnterprises ==
      null) {
    return;
  }

  for (var x = 0; x < buyQuotationProvider.selectedEnterprises.length; x++) {
    //a quantidade de controllers é criado de acordo com a quantidade de empresas selecionadas
    final enterprise = buyQuotationProvider.selectedEnterprises[x];

    final productQuantity = buyQuotationProvider
        .productsWithNewValues[productIndex].ProductEnterprises!
        .where((e) => e.EnterpriseCode == enterprise.Code)
        .first
        .Quantity;

    if (productQuantity != null) {
      final index =
          controllers.indexWhere((e) => e.keys.first == enterprise.Code);

      if (index == -1) {
        continue;
      }
      controllers[index].values.first.text = productQuantity
          .toString()
          .toBrazilianNumber(3)
          .replaceAll(RegExp(r'\.'), '');
    } else {
      controllers
          .where((e) => e.keys.first == enterprise.Code)
          .first
          .values
          .first
          .text = "";
    }
  }
}
