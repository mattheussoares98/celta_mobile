import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../models/research_prices/research_prices.dart';
import '../../providers/providers.dart';

class ResearchPricesInsertPrices extends StatefulWidget {
  final ResearchPricesProductsModel product;
  final bool isAssociatedProducts;
  final Function showErrorMessage;
  //só funcionou dessa forma porque quando tentava chamar o contexto após dar
  //certo ou erro, ele já não existia mais
  final Function showSuccessMessage;
  //só funcionou dessa forma porque quando tentava chamar o contexto após dar
  //certo ou erro, ele já não existia mais
  const ResearchPricesInsertPrices({
    required this.isAssociatedProducts,
    required this.product,
    required this.showErrorMessage,
    required this.showSuccessMessage,
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
    return (_priceRetailController.text.isNotEmpty ||
            _offerRetailController.text.isNotEmpty ||
            _priceWholeController.text.isNotEmpty ||
            _offerWholeController.text.isNotEmpty ||
            _priceEcommerceController.text.isNotEmpty ||
            _offerEcommerceController.text.isNotEmpty) &&
        _formKey.currentState!.validate();
  }

  void _updateControllers() {
    if (widget.product.PriceRetail > 0)
      _priceRetailController.text = ConvertString.convertToBrazilianNumber(
        widget.product.PriceRetail,
        decimalHouses: 2,
      );
    if (widget.product.OfferRetail > 0)
      _offerRetailController.text = ConvertString.convertToBrazilianNumber(
        widget.product.OfferRetail,
        decimalHouses: 2,
      );
    if (widget.product.PriceWhole > 0)
      _priceWholeController.text = ConvertString.convertToBrazilianNumber(
        widget.product.PriceWhole,
        decimalHouses: 2,
      );
    if (widget.product.OfferWhole > 0)
      _offerWholeController.text = ConvertString.convertToBrazilianNumber(
        widget.product.OfferWhole,
        decimalHouses: 2,
      );
    if (widget.product.PriceECommerce > 0)
      _priceEcommerceController.text = ConvertString.convertToBrazilianNumber(
        widget.product.PriceECommerce,
        decimalHouses: 2,
      );
    if (widget.product.OfferECommerce > 0)
      _offerEcommerceController.text = ConvertString.convertToBrazilianNumber(
        widget.product.OfferECommerce,
        decimalHouses: 2,
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
                  label: "Venda",
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
                  label: "Atacado",
                  textEditingController: _priceWholeController,
                  key: _priceWholeKey,
                ),
                const SizedBox(width: 10),
                personalizedField(
                  label: "Atacado (oferta)",
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
                    message: "Insira os preços corretamente!",
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
                        isAssociatedProducts: widget.isAssociatedProducts,
                        productCode: widget.product.ProductPackingCode,
                        priceLookUp: widget.product.PriceLookUp,
                        productName: widget.product.ProductName,
                        priceRetail: double.tryParse(_priceRetailController.text
                            .replaceAll(RegExp(','), '.')),
                        offerRetail: double.tryParse(_offerRetailController.text
                            .replaceAll(RegExp(','), '.')),
                        priceWhole: double.tryParse(_priceWholeController.text
                            .replaceAll(RegExp(','), '.')),
                        offerWhole: double.tryParse(_offerWholeController.text
                            .replaceAll(RegExp(','), '.')),
                        priceECommerce: double.tryParse(
                            _priceEcommerceController.text
                                .replaceAll(RegExp(','), '.')),
                        offerECommerce: double.tryParse(
                            _offerEcommerceController.text
                                .replaceAll(RegExp(','), '.')),
                      );

                      if (researchPricesProvider.errorInsertConcurrentPrices ==
                          "") {
                        widget.showSuccessMessage();
                        //só funcionou dessa forma porque quando tentava chamar
                        //o contexto após dar certo ou erro, ele já não existia
                        //mais
                      } else {
                        widget.showErrorMessage();
                        //só funcionou dessa forma porque quando tentava chamar
                        //o contexto após dar certo ou erro, ele já não existia
                        //mais
                      }
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
