import 'package:celta_inventario/api/prefs_instance.dart';
import 'package:celta_inventario/api/url_launcher.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanBarCode {
  static Future<String> scanBarcode(BuildContext context) async {
    if (kIsWeb) {
      _showMessageToOpenIosApp(context);

      return "";
    } else {
      String barcodeScanRes;
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
      } on PlatformException {
        barcodeScanRes = 'Failed to get platform version.';
      }

      if (barcodeScanRes != '-1') {
        return barcodeScanRes;
      } else {
        return "";
      }
    }
  }

  static void _showMessageToOpenIosApp(BuildContext context) async {
    bool showMessageAgain =
        await PrefsInstance.getShowMessageToUseCameraInWebVersion();

    if (!showMessageAgain) {
      UrlLauncher.searchAndLaunchUrl(
          url:
              "https://apps.apple.com/pt/app/quick-barcode-scanner/id1237149717",
          context: context);
    } else {
      ShowAlertDialog.showAlertDialog(
        context: context,
        title: "LEIA COM ATENÇÃO CASO ESTEJA USANDO UM DISPOSITIVO iOS!",
        titleSize: 35,
        subtitle:
            "Caso esteja usando um dispositivo iOS, não conseguimos acessar a câmera do celular para ler o código de barras.\n\nVocê pode instalar QUALQUER aplicativo de leitura de código de barras, fazer a leitura do código de barras pelo aplicativo, copiar esse código de barras, retornar para o site e colar o código de barras copiado\n\nDeseja abrir um aplicativo de leitura de código de barras?",
        function: () {
          UrlLauncher.searchAndLaunchUrl(
            url:
                "https://apps.apple.com/pt/app/quick-barcode-scanner/id1237149717",
            context: context,
          );
        },
        otherWidgetAction: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: TextButton(
                onPressed: () async {
                  await PrefsInstance
                      .setToNoShowAgainMessageToUseCameraInWebVersion();
                },
                child: const Text(
                  "Fechar mensagem e não exibir novamente",
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
