import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/material.dart';

class SearchProductWithEanPluOrNameWidget extends StatefulWidget {
  final bool isLoading;
  final Function onPressSearch;
  final TextEditingController consultProductController;
  final FocusNode focusNodeConsultProduct;
  const SearchProductWithEanPluOrNameWidget({
    required this.consultProductController,
    required this.isLoading,
    required this.onPressSearch,
    required this.focusNodeConsultProduct,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchProductWithEanPluOrNameWidget> createState() =>
      _SearchProductWithEanPluOrNameWidgetState();
}

class _SearchProductWithEanPluOrNameWidgetState
    extends State<SearchProductWithEanPluOrNameWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  isValid() {
    return _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = widget.focusNodeConsultProduct;
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
                    focusNode: focusNode,
                    enabled: widget.isLoading ? false : true,
                    autofocus: true,
                    controller: widget.consultProductController,
                    // focusNode: _consultedProductFocusNode,
                    // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    onChanged: (value) {
                      if (value.isEmpty || value == '-') {
                        value = '0';
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty || value == "") {
                        return 'PLU, EAN ou nome';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          widget.consultProductController.clear();

                          Future.delayed(const Duration(), () {
                            FocusScope.of(context).unfocus();
                            FocusScope.of(context).requestFocus(focusNode);
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: widget.isLoading ? Colors.grey : Colors.red,
                        ),
                      ),
                      hintText: "PLU, EAN ou nome",
                      labelText: 'Consultar produto',
                      labelStyle: TextStyle(
                        color: widget.isLoading
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: widget.isLoading
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
                    ),
                    onFieldSubmitted: (value) async {
                      if (!isValid()) {
                        Future.delayed(const Duration(), () {
                          FocusScope.of(context)
                              .requestFocus(widget.focusNodeConsultProduct);
                        });
                        return;
                      }

                      await widget.onPressSearch();
                    },
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    color: widget.isLoading
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    onPressed: widget.isLoading
                        ? null
                        : () async {
                            if (!isValid()) {
                              return;
                            }
                            FocusScope.of(context).unfocus();

                            await widget.onPressSearch();
                          },
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    color: widget.isLoading
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    onPressed: widget.isLoading
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            widget.consultProductController.clear();

                            widget.consultProductController.text =
                                await ScanBarCode.scanBarcode();

                            if (widget.consultProductController.text != "") {
                              await widget.onPressSearch();
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
