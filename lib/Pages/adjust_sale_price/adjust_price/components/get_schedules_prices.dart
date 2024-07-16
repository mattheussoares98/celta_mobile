import 'package:celta_inventario/models/enterprise/enterprise.dart';
import 'package:celta_inventario/models/soap/products/products.dart';
import 'package:celta_inventario/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetSchedulesPrices extends StatelessWidget {
  final EnterpriseModel enterprise;
  final GetProductJsonModel product;
  const GetSchedulesPrices({
    required this.enterprise,
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        await adjustSalePriceProvider.getProductSchedules(
          enterpriseCode: enterprise.codigoInternoEmpresa,
          productCode: product.productCode!,
          productPackingCode: product.productPackingCode!,
        );
      },
      child: const Text("Obter agendamentos de preços"),
    );
  }
}
