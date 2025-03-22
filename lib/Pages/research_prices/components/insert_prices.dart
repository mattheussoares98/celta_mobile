import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../Models/research_prices/research_prices.dart';
import '../../../providers/providers.dart';
import '../../../utils/convert_string.dart';

class InsertPrices extends StatefulWidget {
  final ResearchPricesProductsModel product;
  final bool isAssociatedProducts;
  final Function showErrorMessage;
  //só funcionou dessa forma porque quando tentava chamar o contexto após dar
  //certo ou erro, ele já não existia mais
  final Function showSuccessMessage;
  //só funcionou dessa forma porque quando tentava chamar o contexto após dar
  //certo ou erro, ele já não existia mais
  const InsertPrices({
    required this.isAssociatedProducts,
    required this.product,
    required this.showErrorMessage,
    required this.showSuccessMessage,
    super.key,
  });

  @override
  State<InsertPrices> createState() => _InsertPricesState();
}

class _InsertPricesState extends State<InsertPrices> {
  Flexible personalizedField({
    required String label,
    required GlobalKey<FormState> key,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    required FocusNode? nextFocusOnSubmit,
  }) {
    return Flexible(
      child: TextFormField(
        focusNode: focusNode,
        key: key,
        controller: textEditingController,
        decoration: FormFieldDecoration.decoration(
          context: context,
          labelText: label,
          hintText: label,
          errorSize: 10,
          suffixIcon: IconButton(
            onPressed: () {
              textEditingController.clear();
              FocusScope.of(context).requestFocus(focusNode);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ),
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(nextFocusOnSubmit);
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => FormFieldValidations.number(
          value,
          maxDecimalPlaces: 2,
          valueCanIsEmpty: true,
        ),
        style: FormFieldStyle.style(),
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

  final _priceRetailFocusNode = FocusNode();
  final _offerRetailFocusNode = FocusNode();
  final _priceWholeFocusNode = FocusNode();
  final _offerWholeFocusNode = FocusNode();
  final _priceEcommerceFocusNode = FocusNode();
  final _offerEcommerceFocusNode = FocusNode();

  bool _allFieldsAreEmpty() {
    return _priceRetailController.text.isEmpty &&
        _offerRetailController.text.isEmpty &&
        _priceWholeController.text.isEmpty &&
        _offerWholeController.text.isEmpty &&
        _priceEcommerceController.text.isEmpty &&
        _offerEcommerceController.text.isEmpty;
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
  void dispose() {
    super.dispose();
    _priceRetailFocusNode.dispose();
    _offerRetailFocusNode.dispose();
    _priceWholeFocusNode.dispose();
    _offerWholeFocusNode.dispose();
    _priceEcommerceFocusNode.dispose();
    _offerEcommerceFocusNode.dispose();

    _priceRetailController.dispose();
    _offerRetailController.dispose();
    _priceWholeController.dispose();
    _offerWholeController.dispose();
    _priceEcommerceController.dispose();
    _offerEcommerceController.dispose();
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
                  focusNode: _priceRetailFocusNode,
                  key: _priceRetailKey,
                  nextFocusOnSubmit: _offerRetailFocusNode,
                ),
                const SizedBox(width: 10),
                personalizedField(
                  label: "Venda (oferta)",
                  textEditingController: _offerRetailController,
                  focusNode: _offerRetailFocusNode,
                  key: _offerRetailKey,
                  nextFocusOnSubmit: _priceWholeFocusNode,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                personalizedField(
                  label: "Atacado",
                  textEditingController: _priceWholeController,
                  focusNode: _priceWholeFocusNode,
                  key: _priceWholeKey,
                  nextFocusOnSubmit: _offerWholeFocusNode,
                ),
                const SizedBox(width: 10),
                personalizedField(
                  label: "Atacado (oferta)",
                  textEditingController: _offerWholeController,
                  focusNode: _offerWholeFocusNode,
                  key: _offerWholeKey,
                  nextFocusOnSubmit: _priceEcommerceFocusNode,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                personalizedField(
                  label: "Ecommerce",
                  textEditingController: _priceEcommerceController,
                  focusNode: _priceEcommerceFocusNode,
                  key: _priceEcommerceKey,
                  nextFocusOnSubmit: _offerEcommerceFocusNode,
                ),
                const SizedBox(width: 10),
                personalizedField(
                  label: "Ecommerce (oferta)",
                  textEditingController: _offerEcommerceController,
                  focusNode: _offerEcommerceFocusNode,
                  key: _offerEcommerceKey,
                  nextFocusOnSubmit: null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                bool isValid = _formKey.currentState!.validate();

                if (!isValid) {
                  ShowSnackbarMessage.show(
                    message: "Insira os preços corretamente!",
                    context: context,
                  );
                } else {
                  if (_allFieldsAreEmpty()) {}

                  ShowAlertDialog.show(
                    context: context,
                    title: _allFieldsAreEmpty()
                        ? "Zerar preços informados"
                        : "Confirmar preços",
                    content: SingleChildScrollView(
                      child: Text(
                        _allFieldsAreEmpty()
                            ? "Deseja realmente zerar os preços informados"
                            : "Deseja realmente confirmar os preços do concorrente?",
                        textAlign: TextAlign.center,
                      ),
                    ),
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
