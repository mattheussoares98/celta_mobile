import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final bool isLoading;
  final Function onPressSearch;
  final dynamic changeLegacyIsSelectedFunction;
  final TextEditingController consultProductController;
  final FocusNode focusNodeConsultProduct;
  final String hintText;
  final String labelText;
  final bool useCamera;
  final bool autofocus;
  final bool hasLegacyCodeSearch;
  final bool legacyIsSelected;
  const SearchWidget({
    required this.consultProductController,
    required this.isLoading,
    required this.onPressSearch,
    required this.focusNodeConsultProduct,
    this.changeLegacyIsSelectedFunction = null,
    this.hintText = "PLU-EAN-NOME",
    this.labelText = "Consultar produto",
    this.useCamera = true,
    this.autofocus = true,
    this.hasLegacyCodeSearch = false,
    this.legacyIsSelected = false,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  isValid() {
    return _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = widget.focusNodeConsultProduct;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 85,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    focusNode: focusNode,
                    enabled: widget.isLoading ? false : true,
                    autofocus: widget.autofocus,
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
                        return widget.hintText;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
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
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: widget.isLoading
                                  ? null
                                  : () async {
                                      if (!isValid()) {
                                        return;
                                      }
                                      FocusScope.of(context).unfocus();

                                      await widget.onPressSearch();
                                    },
                              child: Icon(
                                Icons.search,
                                size: 35,
                                color: widget.isLoading
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                            if (widget.useCamera)
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: InkWell(
                                  onTap: widget.isLoading
                                      ? null
                                      : () async {
                                          FocusScope.of(context).unfocus();
                                          widget.consultProductController
                                              .clear();

                                          widget.consultProductController.text =
                                              await ScanBarCode.scanBarcode();

                                          if (widget.consultProductController
                                                  .text !=
                                              "") {
                                            await widget.onPressSearch();
                                          }
                                        },
                                  child: Icon(
                                    Icons.photo_camera,
                                    size: 40,
                                    color: widget.isLoading
                                        ? Colors.grey
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      hintText: widget.legacyIsSelected
                          ? "Código legado"
                          : widget.hintText,
                      labelText: widget.labelText,
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
              if (widget.hasLegacyCodeSearch)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: GestureDetector(
                    onTap: widget.isLoading
                        ? null
                        : () {
                            widget.changeLegacyIsSelectedFunction();
                          },
                    child: Column(
                      children: [
                        const Text("código\nlegado"),
                        Icon(
                          widget.legacyIsSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: widget.isLoading
                              ? Colors.grey
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 4),
          child: Divider(
            height: 6,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
