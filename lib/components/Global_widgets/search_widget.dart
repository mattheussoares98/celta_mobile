import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final bool isLoading;
  final Function onPressSearch;
  final TextEditingController consultProductController;
  final FocusNode focusNodeConsultProduct;
  final String hintText;
  final String labelText;
  final bool? useAutoScan;
  final bool? useLegacyCode;
  final Function? changeAutoScanValue;
  final Function? changeLegacyCodeValue;
  final bool useCamera;
  final bool autofocus;
  const SearchWidget({
    this.useAutoScan,
    this.useLegacyCode,
    this.autofocus = true,
    this.useCamera = true,
    this.changeAutoScanValue,
    this.changeLegacyCodeValue,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: 8,
              right: (widget.useAutoScan == null ||
                          widget.changeAutoScanValue == null) ||
                      (widget.useLegacyCode == null ||
                          widget.changeLegacyCodeValue == null)
                  ? 8
                  : 0,
              top: 8),
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
                                    widget.useAutoScan == true
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
                      hintText: widget.useLegacyCode != null &&
                              widget.useLegacyCode == true
                          ? "Código legado"
                          : widget.hintText,
                      labelText: widget.labelText,
                      hintStyle: const TextStyle(
                        fontSize: 15,
                      ),
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
              if ((widget.useAutoScan != null &&
                      widget.changeAutoScanValue != null) ||
                  (widget.useLegacyCode != null &&
                      widget.changeLegacyCodeValue != null))
                _enableConfigurationsDialog(
                  isLoading: widget.isLoading,
                  useAutoScan:
                      widget.useAutoScan != null ? widget.useAutoScan! : null,
                  useLegacyCode: widget.useLegacyCode != null
                      ? widget.useLegacyCode!
                      : null,
                  changeAutoScanValue: widget.changeAutoScanValue != null
                      ? widget.changeAutoScanValue
                      : null,
                  changeLegacyCodeValue: widget.changeLegacyCodeValue != null
                      ? widget.changeLegacyCodeValue!
                      : null,
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

  _enableConfigurationsDialog({
    bool? useAutoScan,
    bool? useLegacyCode,
    Function? changeAutoScanValue,
    Function? changeLegacyCodeValue,
    required bool isLoading,
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
                  bool? internUseAutoScan = useAutoScan;
                  bool? internUseLegacyCode = useLegacyCode;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Center(child: Text('Habilitar')),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (useAutoScan != null &&
                                  changeAutoScanValue != null)
                                _personalizedCheckboxListTile(
                                  internValue: internUseAutoScan!,
                                  changeValue: () {
                                    setState(
                                      () => {
                                        internUseAutoScan = !internUseAutoScan!,
                                        changeAutoScanValue(),
                                      },
                                    );
                                  },
                                  configurationName: "Auto Scan",
                                ),
                              if (useLegacyCode != null &&
                                  changeLegacyCodeValue != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: _personalizedCheckboxListTile(
                                    internValue: internUseLegacyCode!,
                                    changeValue: () => setState(() => {
                                          internUseLegacyCode =
                                              !internUseLegacyCode!,
                                          changeLegacyCodeValue(),
                                        }),
                                    configurationName: "Código legado",
                                  ),
                                ),
                            ],
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

  _personalizedCheckboxListTile({
    required bool internValue,
    required Function changeValue,
    required String configurationName,
  }) {
    return CheckboxListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
      activeColor: internValue ? Colors.green : null,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(configurationName),
        ],
      ),
      value: internValue,
      onChanged: (value) {
        setState(() {
          changeValue();
        });
      },
    );
  }
}
