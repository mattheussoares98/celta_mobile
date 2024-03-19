import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../models/research_prices/research_prices.dart';
import '../../providers/providers.dart';

class ResearchPricesInsertPrices extends StatefulWidget {
  final ResearchPricesProductsModel product;
  const ResearchPricesInsertPrices({
    required this.product,
    super.key,
  });

  @override
  State<ResearchPricesInsertPrices> createState() =>
      _ResearchPricesInsertPricesState();
}

class _ResearchPricesInsertPricesState
    extends State<ResearchPricesInsertPrices> {
  Flexible personalizedField({
    required String label,
    required GlobalKey<FormState> key,
    required TextEditingController textEditingController,
  }) {
    return Flexible(
      child: TextFormField(
        key: key,
        controller: textEditingController,
        decoration: FormFieldHelper.decoration(
          isLoading: false,
          context: context,
          labelText: label,
          hintText: label,
          errorSize: 10,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormFieldHelper.validatorOfNumber(
          maxDecimalPlaces: 2,
          valueCanIsEmpty: true,
        ),
        style: FormFieldHelper.style(),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _priceRetailKey = GlobalKey<FormState>();
  final _offerRetailKey = GlobalKey<FormState>();
  final _priceWholeKey = GlobalKey<FormState>();
  final _offerWholeKey = GlobalKey<FormState>();
  final _priceEcommerceKey = GlobalKey<FormState>();
  final _offerEcommerceKey = GlobalKey<FormState>();

  final _priceRetailController = TextEditingController();
  final _offerRetailController = TextEditingController();
  final _priceWholeController = TextEditingController();
  final _offerWholeController = TextEditingController();
  final _priceEcommerceController = TextEditingController();
  final _offerEcommerceController = TextEditingController();

  bool _validateCanConfirmChanges() {
    return _priceRetailController.text.isNotEmpty ||
        _offerRetailController.text.isNotEmpty ||
        _priceWholeController.text.isNotEmpty ||
        _offerWholeController.text.isNotEmpty ||
        _priceEcommerceController.text.isNotEmpty ||
        _offerEcommerceController.text.isNotEmpty &&
            _formKey.currentState!.validate();
  }

  void _updateControllers() {
    if (widget.product.PriceRetail > 0)
      _priceRetailController.text = ConvertString.convertToBrazilianNumber(
        widget.product.PriceRetail,
      );
    if (widget.product.OfferRetail > 0)
      _offerRetailController.text = ConvertString.convertToBrazilianNumber(
        widget.product.OfferRetail,
      );
    if (widget.product.PriceWhole > 0)
      _priceWholeController.text = ConvertString.convertToBrazilianNumber(
        widget.product.PriceWhole,
      );
    if (widget.product.OfferWhole > 0)
      _offerWholeController.text = ConvertString.convertToBrazilianNumber(
        widget.product.OfferWhole,
      );
    if (widget.product.PriceECommerce > 0)
      _priceEcommerceController.text = ConvertString.convertToBrazilianNumber(
        widget.product.PriceECommerce,
      );
    if (widget.product.OfferECommerce > 0)
      _offerEcommerceController.text = ConvertString.convertToBrazilianNumber(
        widget.product.OfferECommerce,
      );
  }

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                personalizedField(
                  label: "Preço venda",
                  textEditingController: _priceRetailController,
                  key: _priceRetailKey,
                ),
                const SizedBox(width: 10),
                personalizedField(
                  label: "Venda (oferta)",
                  textEditingController: _offerRetailController,
                  key: _offerRetailKey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                personalizedField(
                  label: "Preço atacado",
                  textEditingController: _priceWholeController,
                  key: _priceWholeKey,
                ),
                const SizedBox(width: 10),
                personalizedField(
                  label: "Atacado oferta",
                  textEditingController: _offerWholeController,
                  key: _offerWholeKey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                personalizedField(
                  label: "Ecommerce",
                  textEditingController: _priceEcommerceController,
                  key: _priceEcommerceKey,
                ),
                const SizedBox(width: 10),
                personalizedField(
                  label: "Ecommerce (oferta)",
                  textEditingController: _offerEcommerceController,
                  key: _offerEcommerceKey,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                bool isValid = _validateCanConfirmChanges();
                if (!isValid) {
                  ShowSnackbarMessage.showMessage(
                    message: "Insira ao menos um preço para alterar",
                    context: context,
                  );
                } else {
                  ShowAlertDialog.showAlertDialog(
                    context: context,
                    title: "Confirmar preços",
                    subtitle:
                        "Deseja realmente confirmar os preços do concorrente?",
                    function: () async {
                      await researchPricesProvider.insertConcurrentPrices(
                        productCode: widget.product.ProductPackingCode,
                        priceLookUp: widget.product.PriceLookUp,
                        productName: widget.product.ProductName,
                        priceRetail:
                            double.tryParse(_priceRetailController.text),
                        offerRetail:
                            double.tryParse(_offerRetailController.text),
                        priceWhole: double.tryParse(_priceWholeController.text),
                        offerWhole: double.tryParse(_offerWholeController.text),
                        priceECommerce:
                            double.tryParse(_priceEcommerceController.text),
                        offerECommerce:
                            double.tryParse(_offerEcommerceController.text),
                      );
                    },
                  );
                }
              },
              icon: const Icon(Icons.check),
              label: const Text(
                "Confirmar preços do concorrente",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
