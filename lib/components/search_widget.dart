import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../pages/drawer/drawer.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import 'components.dart';

class SearchWidget extends StatefulWidget {
  final bool isLoading;
  final Function()? onPressSearch;
  final TextEditingController searchProductController;
  final FocusNode searchProductFocusNode;
  final String hintText;
  final String labelText;
  final bool useCamera;
  final bool autofocus;
  final bool showConfigurationsIcon;
  final bool showOnlyConfigurationOfSearchProducts;
  const SearchWidget({
    this.autofocus = true,
    this.showOnlyConfigurationOfSearchProducts = false,
    this.useCamera = true,
    this.showConfigurationsIcon = true,
    required this.searchProductController,
    required this.isLoading,
    required this.onPressSearch,
    required this.searchProductFocusNode,
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

  Future<void> _openCamera() async {
    FocusScope.of(context).unfocus();
    widget.searchProductController.clear();

    widget.searchProductController.text =
        await ScanBarCode.scanBarcode(context);

    if (widget.searchProductController.text != "" &&
        widget.onPressSearch != null) {
      await widget.onPressSearch!();
    }
  }

  String _getHintText(ConfigurationsProvider configurationsProvider) {
    if (configurationsProvider.legacyCode?.value == true) {
      return "Código legado";
    } else if (configurationsProvider.productPersonalizedCode?.value == true) {
      return "Código personalizado";
    } else {
      return widget.hintText;
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = widget.searchProductFocusNode;
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                focusNode: focusNode,
                enabled: !widget.isLoading,
                autofocus: widget.autofocus,
                controller: widget.searchProductController,
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
                decoration: FormFieldDecoration.decoration(
                  isLoading: widget.isLoading,
                  context: context,
                  labelText: widget.labelText,
                  prefixIcon: IconButton(
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            widget.searchProductController.clear();

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
                  hintText: _getHintText(configurationsProvider),
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
                                    widget.searchProductController.text =
                                        clipboardData?.text ?? '';

                                    if (widget.onPressSearch != null) {
                                      await widget.onPressSearch!();
                                    }
                                  },
                            child: const Text(
                              "colar\ntexto",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Flexible(
                          child: InkWell(
                            focusColor: Colors.white.withOpacity(0),
                            hoverColor: Colors.white.withOpacity(0),
                            splashColor: Colors.white.withOpacity(0),
                            highlightColor: Colors.white.withOpacity(0),
                            onTap:
                                widget.isLoading || widget.onPressSearch == null
                                    ? null
                                    : () async {
                                        if (!isValid()) {
                                          return;
                                        }
                                        FocusScope.of(context).unfocus();

                                        await widget.onPressSearch!();
                                      },
                            child: Icon(
                              Icons.search,
                              size: 35,
                              color: widget.isLoading
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        if (widget.useCamera &&
                            (Platform.isIOS || Platform.isAndroid))
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: InkWell(
                                focusColor: Colors.white.withOpacity(0),
                                hoverColor: Colors.white.withOpacity(0),
                                splashColor: Colors.white.withOpacity(0),
                                highlightColor: Colors.white.withOpacity(0),
                                onTap: widget.isLoading
                                    ? null
                                    : () async {
                                        await _openCamera();
                                      },
                                child: Icon(
                                  configurationsProvider.autoScan?.value == true
                                      ? Icons.camera_alt
                                      : Icons.camera_alt_outlined,
                                  size: 40,
                                  color: widget.isLoading
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                                ),
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
                          .requestFocus(widget.searchProductFocusNode);
                    });
                    return;
                  }

                  if (widget.onPressSearch != null) {
                    await widget.onPressSearch!();
                  }
                },
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          if (widget.showConfigurationsIcon)
            _enableConfigurationsDialog(
              isLoading: widget.isLoading,
              configurationsProvider: configurationsProvider,
              showOnlyConfigurationOfSearchProducts:
                  widget.showOnlyConfigurationOfSearchProducts,
            ),
        ],
      ),
    );
  }

  _enableConfigurationsDialog({
    required bool isLoading,
    required ConfigurationsProvider configurationsProvider,
    required bool showOnlyConfigurationOfSearchProducts,
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
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        contentPadding: const EdgeInsets.all(8),
                        title: const FittedBox(
                          child: Text(
                            "Configurações de pesquisa",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        content: SingleChildScrollView(
                          primary: false,
                          child: ConfigurationsCheckbox(
                            showOnlyConfigurationOfSearch:
                                showOnlyConfigurationOfSearchProducts,
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
