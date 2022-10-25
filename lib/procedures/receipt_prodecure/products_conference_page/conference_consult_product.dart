import 'package:celta_inventario/procedures/receipt_prodecure/products_conference_page/conference_provider.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';

class ConferenceConsultProduct extends StatefulWidget {
  final ConferenceProvider conferenceProvider;
  final int docCode;
  const ConferenceConsultProduct({
    required this.conferenceProvider,
    required this.docCode,
    Key? key,
  }) : super(key: key);

  @override
  State<ConferenceConsultProduct> createState() =>
      _ConferenceConsultProductState();
}

class _ConferenceConsultProductState extends State<ConferenceConsultProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _consultProductController =
      TextEditingController();

  isValid() {
    return _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController textEditingController =
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 4,
        right: 0,
        bottom: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                enabled: widget.conferenceProvider.consultingProducts ||
                        widget.conferenceProvider.isUpdatingQuantity
                    ? false
                    : true,
                autofocus: true,
                controller: _consultProductController,
                // focusNode: _consultedProductFocusNode,
                // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                onChanged: (value) {
                  if (value.isEmpty || value == '-') {
                    value = '0';
                  }
                },
                validator: (value) {
                  if (value!.isEmpty || value == "") {
                    return 'Digite O PLU, EAN ou nome';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Consultar PLU, EAN ou nome',
                  floatingLabelStyle: TextStyle(
                    color: widget.conferenceProvider.consultingProducts ||
                            widget.conferenceProvider.isUpdatingQuantity
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                  ),
                  errorStyle: const TextStyle(
                    fontSize: 17,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      style: BorderStyle.solid,
                      width: 2,
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: widget.conferenceProvider.consultingProducts ||
                            widget.conferenceProvider.isUpdatingQuantity
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                color: widget.conferenceProvider.consultingProducts ||
                        widget.conferenceProvider.isUpdatingQuantity
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
                onPressed: widget.conferenceProvider.consultingProducts ||
                        widget.conferenceProvider.isUpdatingQuantity
                    ? null
                    : () async {
                        if (!isValid()) {
                          return;
                        }

                        await widget.conferenceProvider
                            .getProductByPluEanOrName(
                          docCode: widget.docCode,
                          controllerText: _consultProductController.text,
                        );

                        if (widget.conferenceProvider.errorMessageGetProducts !=
                            "") {
                          ShowErrorMessage().showErrorMessage(
                            error: widget
                                .conferenceProvider.errorMessageGetProducts,
                            context: context,
                          );
                        }
                        if (widget.conferenceProvider.productsCount > 0) {
                          //se for maior que 0 significa que deu certo a consulta e
                          //por isso pode apagar o que foi escrito no campo de
                          //consulta
                          _consultProductController.clear();
                        }
                      },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                color: widget.conferenceProvider.consultingProducts ||
                        widget.conferenceProvider.isUpdatingQuantity
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
                onPressed: widget.conferenceProvider.consultingProducts ||
                        widget.conferenceProvider.isUpdatingQuantity
                    ? null
                    : () async {
                        _consultProductController.text =
                            await widget.conferenceProvider.scanAndConsultEan(
                          consultProductController:
                              _consultProductController.text,
                          docCode: widget.docCode,
                          eanInString: _consultProductController.text,
                        );

                        if (widget.conferenceProvider.errorMessageGetProducts !=
                            "") {
                          ShowErrorMessage().showErrorMessage(
                            error: widget
                                .conferenceProvider.errorMessageGetProducts,
                            context: context,
                          );
                        }
                        if (widget.conferenceProvider.productsCount > 0) {
                          //se for maior que 0 significa que deu certo a consulta e
                          //por isso pode apagar o que foi escrito no campo de
                          //consulta
                          _consultProductController.clear();
                        }
                      },
                icon: const Icon(Icons.photo_camera),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
