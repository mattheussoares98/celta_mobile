import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_plus/platform_plus.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../configurations/configurations.dart';
import './global_widgets.dart';

class SearchWidget extends StatefulWidget {
  final bool isLoading;
  final Function onPressSearch;
  final TextEditingController consultProductController;
  final FocusNode focusNodeConsultProduct;
  final String hintText;
  final String labelText;
  final bool useCamera;
  final bool autofocus;
  final bool showConfigurationsIcon;
  final bool showOnlyConfigurationOfSearch;
  const SearchWidget({
    this.autofocus = true,
    this.showOnlyConfigurationOfSearch = false,
    this.useCamera = true,
    this.showConfigurationsIcon = true,
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

  Future<void> _openCamera() async {
    if (PlatformPlus.platform.isAndroidWeb) {
      ShowAlertDialog.showAlertDialog(
        context: context,
        title: "Instalar aplicativo?",
        subtitle:
            "Você está usando um dispositivo android. O ideal é utilizar o aplicativo\n\nDeseja instalar o aplicativo?",
        function: () async {
          await UrlLauncher.searchAndLaunchUrl(
            url:
                "https://play.google.com/store/apps/details?id=br.com.celtaware.inventario",
            context: context,
          );
        },
      );
    } else if (PlatformPlus.platform.isWindowsWeb) {
      ShowSnackbarMessage.showMessage(
        message: "A câmera não funciona na versão web",
        context: context,
      );
    } else if (PlatformPlus.platform.isIOSWeb) {
      _showMessageToOpenIosApp(context);
    } else {
      FocusScope.of(context).unfocus();
      widget.consultProductController.clear();

      widget.consultProductController.text =
          await ScanBarCode.scanBarcode(context);

      if (widget.consultProductController.text != "") {
        await widget.onPressSearch();
      }
    }
  }

  static Future<void> _showMessageToOpenIosApp(BuildContext context) async {
    bool showMessageAgain =
        await PrefsInstance.getShowMessageToUseCameraInWebVersion();

    if (!showMessageAgain) {
      await UrlLauncher.searchAndLaunchUrl(
        url: "https://apps.apple.com/pt/app/quick-barcode-scanner/id1237149717",
        context: context,
      );
    } else {
      ShowAlertDialog.showAlertDialog(
        context: context,
        subtitleSize: 15,
        title: "LEIA COM ATENÇÃO!",
        titleSize: 35,
        subtitle:
            "Como você está usando um dispositivo iOS, não conseguimos acessar a câmera do celular para ler o código de barras.\n\nVocê pode instalar QUALQUER aplicativo de leitura de código de barras, fazer a leitura do código de barras pelo aplicativo, copiar esse código de barras, retornar para o site e colar o código de barras copiado.\n\nDeseja abrir um aplicativo de leitura de código de barras?",
        function: () async {
          await UrlLauncher.searchAndLaunchUrl(
            url:
                "https://apps.apple.com/pt/app/quick-barcode-scanner/id1237149717",
            context: context,
          );
        },
        otherWidgetAction: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 20),
                child: TextButton(
                  onPressed: () async {
                    await PrefsInstance
                        .setToNoShowAgainMessageToUseCameraInWebVersion();

                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Fechar mensagem e não exibir novamente",
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
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
                enabled: !widget.isLoading,
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
                    onPressed: widget.isLoading
                        ? null
                        : () {
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

                                    await widget.onPressSearch();
                                  },
                            child: const Text(
                              "colar\ntexto",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                                      await _openCamera();
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
          if (widget.showConfigurationsIcon)
            _enableConfigurationsDialog(
              isLoading: widget.isLoading,
              configurationsProvider: configurationsProvider,
              showOnlyConfigurationOfSearch:
                  widget.showOnlyConfigurationOfSearch,
            ),
        ],
      ),
    );
  }

  _enableConfigurationsDialog({
    required bool isLoading,
    required ConfigurationsProvider configurationsProvider,
    required bool showOnlyConfigurationOfSearch,
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
                        content: SingleChildScrollView(
                          child: ConfigurationsCheckbox(
                            showOnlyConfigurationOfSearch:
                                showOnlyConfigurationOfSearch,
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
