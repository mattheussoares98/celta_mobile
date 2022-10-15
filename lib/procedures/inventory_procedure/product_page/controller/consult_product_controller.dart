import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../product_provider.dart';
import 'add_quantity_controller.dart';

class ConsultProductController {
  static final ConsultProductController instance = ConsultProductController._();

  ConsultProductController._();

  Future<void> scanBarcodeNormal(
      {required String scanBarCode,
      required TextEditingController consultProductController}) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // if (!mounted) return;

    if (barcodeScanRes != '-1') {
      scanBarCode = barcodeScanRes;
    }

    consultProductController.text = scanBarCode;
  }

  Future<void> consultAndAddProduct({
    required BuildContext context,
    required String scanBarCode,
    required int codigoInternoInvCont,
    required FocusNode consultProductFocusNode,
    required bool isIndividual,
    required ProductProvider productProvider,
  }) async {
    // ProductProvider productProvider = Provider.of(context, listen: false);

    await productProvider.getProductByEan(
      ean: scanBarCode,
      enterpriseCode: productProvider.codigoInternoEmpresa!,
      inventoryProcessCode: productProvider.codigoInternoInventario!,
      inventoryCountingCode: codigoInternoInvCont,
      userIdentity: UserIdentity.identity,
    );

    //só pesquisa o PLU se não encontrar pelo EAN
    //sem esse if, de qualquer forma vai pesquisar o PLU
    if (productProvider.products.isEmpty) {
      await productProvider.getProductByPlu(
        plu: scanBarCode,
        enterpriseCode: productProvider.codigoInternoEmpresa!,
        inventoryProcessCode: productProvider.codigoInternoInventario!,
        inventoryCountingCode: codigoInternoInvCont,
        userIdentity: UserIdentity.identity,
      );
    }

    if (productProvider.productErrorMessage != '') {
      ShowErrorMessage().showErrorMessage(
        error: productProvider.productErrorMessage,
        context: context,
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultProductFocusNode);
      });
    }

    if (productProvider.productErrorMessage == '' && isIndividual) {
      //se estiver habilitado pra inserir individualmente, assim que efetuar a consulta do produto já vai tentar adicionar uma unidade
      await AddQuantityController.addQuantity(
        isIndividual: true,
        context: context,
        countingCode: codigoInternoInvCont,
        quantity: '1',
        isSubtract: false,
      );
    }
  }

  alterFocusToConsultProduct({
    required BuildContext context,
    required FocusNode consultProductFocusNode,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco, não funciona corretamente
      FocusScope.of(context).requestFocus(consultProductFocusNode);
    });
  }
}
