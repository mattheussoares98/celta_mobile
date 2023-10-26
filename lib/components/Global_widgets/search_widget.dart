import 'package:celta_inventario/components/Configurations/configurations_checkbox.dart';
import 'package:celta_inventario/components/Global_widgets/formfield_decoration.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget {
  final bool isLoading;
  final Function onPressSearch;
  final TextEditingController consultProductController;
  final FocusNode focusNodeConsultProduct;
  final String hintText;
  final String labelText;
  final bool useCamera;
  final bool autofocus;
  const SearchWidget({
    this.autofocus = true,
    this.useCamera = true,
    required this.consultProductController,
    required this.isLoading,
    required this.onPressSearch,
    required this.focusNodeConsultProduct,
    this.hintText = "PLU-EAN-NOME-%",
    this.labelText = "Consultar produto",
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
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(8),
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
                decoration: FormFieldHelper.decoration(
                  isLoading: widget.isLoading,
                  context: context,
                  labelText: widget.labelText,
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
                  hintText: configurationsProvider.useLegacyCode == true
                      ? "Código legado"
                      : widget.hintText,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (kIsWeb)
                          TextButton(
                            onPressed: widget.isLoading
                                ? null
                                : () async {
                                    ClipboardData? clipboardData =
                                        await Clipboard.getData('text/plain');
                                    widget.consultProductController.text =
                                        clipboardData?.text ?? '';
                                  },
                            child: const Text(
                              "colar\ntexto",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        // InkWell(
                        //   onTap: widget.isLoading
                        //       ? null
                        //       : () async {
                        //           ClipboardData? clipboardData =
                        //               await Clipboard.getData('text/plain');
                        //           widget.consultProductController.text =
                        //               clipboardData?.text ?? '';
                        //         },
                        //   child: Column(
                        //     children: [
                        //       Icon(
                        //         Icons.content_paste_search_sharp,
                        //         size: 35,
                        //         color: widget.isLoading
                        //             ? Colors.grey
                        //             : Theme.of(context).primaryColor,
                        //       ),
                        //       const Text(
                        //         "colar",
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
                                      widget.consultProductController.clear();

                                      widget.consultProductController.text =
                                          await ScanBarCode.scanBarcode(
                                              context);

                                      if (widget
                                              .consultProductController.text !=
                                          "") {
                                        await widget.onPressSearch();
                                      }
                                    },
                              child: Icon(
                                configurationsProvider.useAutoScan == true
                                    ? Icons.camera_alt
                                    : Icons.camera_alt_outlined,
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
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          _enableConfigurationsDialog(
            isLoading: widget.isLoading,
            configurationsProvider: configurationsProvider,
          ),
        ],
      ),
    );
  }

  _enableConfigurationsDialog({
    required bool isLoading,
    required ConfigurationsProvider configurationsProvider,
  }) {
    return IconButton(
      icon: Icon(
        Icons.settings,
        color: widget.isLoading
            ? Colors.grey
            : Theme.of(context).colorScheme.primary,
      ),
      onPressed: isLoading
          ? null
          : () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const FittedBox(
                          child: Text(
                            "Configurações de pesquisa",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        content: const SingleChildScrollView(
                          child: ConfigurationsCheckbox(
                            showOnlyConfigurationOfSearch: true,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Fechar',
                                textAlign: TextAlign.center),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
    );
  }
}
