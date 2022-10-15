import 'package:celta_inventario/procedures/inventory_procedure/provider/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/countings_model.dart';
import 'controller/consult_product_controller.dart';
import 'product_provider.dart';
import 'widgets/consult_product_widget.dart';
import 'widgets/consulted_product_widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _consultProductFocusNode = FocusNode();

  bool isIndividual = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _consultProductController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  alterFocusToConsultProduct() {
    ConsultProductController.instance.alterFocusToConsultProduct(
      consultProductFocusNode: _consultProductFocusNode,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of(context, listen: true);
    QuantityProvider quantityProvider = Provider.of(context, listen: true);
    final countings =
        ModalRoute.of(context)!.settings.arguments as CountingsModel;

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
                  isIndividual: isIndividual,
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
                        value: isIndividual,
                        onChanged: productProvider.isLodingEanOrPlu ||
                                quantityProvider.isLoadingQuantity
                            ? null
                            : (value) {
                                setState(() {
                                  isIndividual = value;
                                });
                                if (isIndividual) {
                                  alterFocusToConsultProduct();
                                }
                              },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (productProvider.products.isNotEmpty)
                  ConsultedProductWidget(
                    isIndividual: isIndividual,
                    countingCode: countings.codigoInternoInvCont,
                    productPackingCode: countings.numeroContagemInvCont,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
