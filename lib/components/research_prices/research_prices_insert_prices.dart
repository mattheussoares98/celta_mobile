import 'package:flutter/material.dart';

import '../../components/global_widgets/global_widgets.dart';

class ResearchPricesInsertPrices extends StatefulWidget {
  const ResearchPricesInsertPrices({super.key});

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
        onChanged: (_) {
          setState(() {
            _canConfirmChanges = _validateCanConfirmChanges();
          });
        },
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

  bool _canConfirmChanges = false;

  bool _validateCanConfirmChanges() {
    return _priceRetailController.text.isNotEmpty ||
        _offerRetailController.text.isNotEmpty ||
        _priceWholeController.text.isNotEmpty ||
        _offerWholeController.text.isNotEmpty ||
        _priceEcommerceController.text.isNotEmpty ||
        _offerEcommerceController.text.isNotEmpty &&
            _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton.icon(
              onPressed: _canConfirmChanges
                  ? () async {
                      _formKey.currentState!.validate();
                    }
                  : null,
              icon: const Icon(Icons.check),
              label: Text(
                _canConfirmChanges ? "Confirmar preços" : "Insira algum preço",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
