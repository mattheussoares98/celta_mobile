import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/soap/soap.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import 'insert_update_product_without_cadaster.dart';

class ReceiptInsertProductWithoutCadasterPage extends StatefulWidget {
  const ReceiptInsertProductWithoutCadasterPage({super.key});

  @override
  State<ReceiptInsertProductWithoutCadasterPage> createState() =>
      _ReceiptInsertProductWithoutCadasterPageState();
}

class _ReceiptInsertProductWithoutCadasterPageState
    extends State<ReceiptInsertProductWithoutCadasterPage> {
  final formKey = GlobalKey<FormState>();
  final eanController = TextEditingController();
  final observationsController = TextEditingController();
  final quantityController = TextEditingController();
  final eanFocusNode = FocusNode();
  final observationsFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

        if (arguments.containsKey("product")) {
          ProductWithoutCadasterModel product = arguments["product"];
          eanController.text = product.Ean_ProcRecebProNaoIden;
          observationsController.text = product.Obs_ProcRecebProNaoIden;
          quantityController.text =
              product.Quantidade_ProcRecebProNaoIden.toString();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    eanController.dispose();
    observationsController.dispose();
    eanFocusNode.dispose();
    observationsFocusNode.dispose();
    quantityFocusNode.dispose();
    quantityController.dispose();
  }

  Future<void> insertUpdateProduct({
    required ReceiptProvider receiptProvider,
    required int docCode,
    required ProductWithoutCadasterModel? product,
    required bool isInserting,
  }) async {
    bool? isValid = formKey.currentState?.validate();

    if (isValid != true) {
      return;
    }

    await receiptProvider.insertUpdateProductWithoutCadaster(
      grDocCode: docCode,
      ean: eanController.text,
      observations: observationsController.text,
      quantity: quantityController.text.toDouble(),
      context: context,
      grDocProductWithoutCadasterCode:
          product?.CodigoInterno_ProcRecebProNaoIden,
    );

    if (receiptProvider.errorInsertProductsWithoutCadaster == "") {
      Navigator.of(context).pop();
      ShowSnackbarMessage.show(
        message: isInserting
            ? "Produto inserido com sucesso"
            : "Produto alterado com sucesso",
        context: context,
        backgroundColor: Theme.of(context).colorScheme.primary,
      );
      receiptProvider.getProductWithoutCadaster(docCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    bool isInserting = arguments["isInserting"];
    int docCode = arguments["docCode"];
    ProductWithoutCadasterModel? product = arguments["product"];

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: FittedBox(
                child: Text(
                  isInserting
                      ? "Inserir produto sem cadastro"
                      : "Alterar produto sem cadastro",
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    EanField(
                      eanController: eanController,
                      observationsFocusNode: observationsFocusNode,
                    ),
                    const SizedBox(height: 8),
                    ObservationsField(
                      observationsController: observationsController,
                      observationsFocusNode: observationsFocusNode,
                      quantityFocusNode: quantityFocusNode,
                    ),
                    const SizedBox(height: 8),
                    QuantityField(
                      quantityController: quantityController,
                      quantityFocusNode: quantityFocusNode,
                      insertUpdateProduct: () async {
                        await insertUpdateProduct(
                          receiptProvider: receiptProvider,
                          docCode: docCode,
                          product: product,
                          isInserting: isInserting,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    InsertButton(
                      formKey: formKey,
                      docCode: docCode,
                      eanController: eanController,
                      observationsController: observationsController,
                      quantityController: quantityController,
                      isInserting: isInserting,
                      product: product,
                      insertUpdateProduct: () async {
                        await insertUpdateProduct(
                          receiptProvider: receiptProvider,
                          docCode: docCode,
                          product: product,
                          isInserting: isInserting,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        loadingWidget(receiptProvider.isLoadingInsertProductsWithoutCadaster),
      ],
    );
  }
}
