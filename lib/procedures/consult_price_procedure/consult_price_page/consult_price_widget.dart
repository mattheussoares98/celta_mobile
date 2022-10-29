import 'package:celta_inventario/procedures/consult_price_procedure/consult_price_page/consult_price_provider.dart';
import 'package:flutter/material.dart';

import '../../../utils/show_error_message.dart';

class ConsultPriceWidget extends StatefulWidget {
  final ConsultPriceProvider consultPriceProvider;
  final int docCode;
  const ConsultPriceWidget({
    required this.consultPriceProvider,
    required this.docCode,
    Key? key,
  }) : super(key: key);

  @override
  State<ConsultPriceWidget> createState() => _ConsultPriceWidgetState();
}

class _ConsultPriceWidgetState extends State<ConsultPriceWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _consultProductController =
      TextEditingController();

  isValid() {
    return _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController textEditingController =
    return Column(
      children: [
        Padding(
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
                    enabled: widget.consultPriceProvider.isLoading ||
                            widget.consultPriceProvider.isSendingToPrint
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
                        color: widget.consultPriceProvider.isLoading ||
                                widget.consultPriceProvider.isSendingToPrint
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
                        color: widget.consultPriceProvider.isLoading ||
                                widget.consultPriceProvider.isSendingToPrint
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
                    color: widget.consultPriceProvider.isLoading ||
                            widget.consultPriceProvider.isSendingToPrint
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    onPressed: widget.consultPriceProvider.isLoading ||
                            widget.consultPriceProvider.isSendingToPrint
                        ? null
                        : () async {
                            if (!isValid()) {
                              return;
                            }
                            FocusScope.of(context).unfocus();

                            await widget.consultPriceProvider
                                .getProductByPluEanOrName(
                              enterpriseCode: widget.docCode,
                              controllerText: _consultProductController.text,
                            );

                            if (widget.consultPriceProvider.errorMessage !=
                                "") {
                              ShowErrorMessage().showErrorMessage(
                                error: widget.consultPriceProvider.errorMessage,
                                context: context,
                              );
                            }
                            if (widget.consultPriceProvider.productsCount > 0) {
                              //se for maior que 0 significa que deu certo a consulta e
                              //por isso pode apagar o que foi escrito no campo de
                              //consulta
                              _consultProductController.clear();
                            }
                          },
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    color: widget.consultPriceProvider.isLoading ||
                            widget.consultPriceProvider.isSendingToPrint
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    onPressed: widget.consultPriceProvider.isLoading ||
                            widget.consultPriceProvider.isSendingToPrint
                        ? null
                        : () async {
                            _consultProductController.clear();
                            FocusScope.of(context).unfocus();
                            _consultProductController.text =
                                await widget.consultPriceProvider.scanBarcode();

                            if (_consultProductController.text != "") {
                              await widget.consultPriceProvider
                                  .getProductByPluEanOrName(
                                enterpriseCode: widget.docCode,
                                controllerText: _consultProductController.text,
                              );

                              if (widget.consultPriceProvider.errorMessage !=
                                  "") {
                                ShowErrorMessage().showErrorMessage(
                                  error:
                                      widget.consultPriceProvider.errorMessage,
                                  context: context,
                                );
                              }
                              if (widget.consultPriceProvider.productsCount >
                                  0) {
                                //se for maior que 0 significa que deu certo a consulta e
                                //por isso pode apagar o que foi escrito no campo de
                                //consulta
                                _consultProductController.clear();
                              }
                            }
                          },
                    icon: const Icon(Icons.photo_camera),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Divider(
            height: 6,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
