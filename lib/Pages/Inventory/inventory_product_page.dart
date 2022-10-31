import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/countings_model.dart';
import '../../providers/inventory_product_provider.dart';
import '../../Components/Inventory/inventory_consult_product_widget.dart';
import '../../Components/Inventory/inventory_consulted_product_widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _consultProductFocusNode = FocusNode();

  bool _isIndividual = false;
  bool _isSubtract = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _consultProductController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InventoryProductProvider inventoryProductProvider =
        Provider.of(context, listen: true);
    final countings =
        ModalRoute.of(context)!.settings.arguments as InventoryCountingsModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Produtos',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConsultProductWidget(
                  formKey: _formKey,
                  isIndividual: _isIndividual,
                  consultProductFocusNode: _consultProductFocusNode,
                  consultProductController: _consultProductController,
                ),
                const SizedBox(height: 8),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Inserir produto individualmente',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Switch(
                        value: _isIndividual,
                        onChanged: inventoryProductProvider.isLoading ||
                                inventoryProductProvider.isLoadingQuantity
                            ? null
                            : (value) {
                                setState(() {
                                  _isIndividual = value;
                                });
                                if (_isIndividual) {
                                  inventoryProductProvider
                                      .alterFocusToConsultProduct(
                                    context: context,
                                    consultProductFocusNode:
                                        _consultProductFocusNode,
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (inventoryProductProvider.products.isNotEmpty)
                  ConsultedProductWidget(
                    isIndividual: _isIndividual,
                    countingCode: countings.codigoInternoInvCont,
                    productPackingCode: countings.numeroContagemInvCont,
                    isSubtract: _isSubtract,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
