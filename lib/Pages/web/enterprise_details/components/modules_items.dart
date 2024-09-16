import 'package:flutter/material.dart';

import '../../../../models/firebase/firebase.dart';
import '../../../../models/modules/modules.dart';
import '../../web.dart';

class ModulesItems extends StatelessWidget {
  final FirebaseEnterpriseModel client;
  const ModulesItems({
    required this.client,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const Text(
          "Módulos habilitados e desabilitados",
          style: const TextStyle(
            fontFamily: "BebasNeue",
            fontSize: 30,
          ),
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.adjustSalePrice == true,
          moduleName: "Ajuste de preços",
          module: Modules.adjustSalePrice,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.adjustStock == true,
          moduleName: "Ajuste de estoques",
          module: Modules.adjustStock,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.buyRequest == true,
          moduleName: "Pedido de compra",
          module: Modules.buyRequest,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.customerRegister == true,
          moduleName: "Cadastro de cliente",
          module: Modules.customerRegister,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.inventory == true,
          moduleName: "Inventário",
          module: Modules.inventory,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.priceConference == true,
          moduleName: "Consulta de preços",
          module: Modules.priceConference,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.productsConference == true,
          moduleName: "Conferência de produtos (expedição)",
          module: Modules.productsConference,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.receipt == true,
          moduleName: "Recebimento",
          module: Modules.receipt,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.researchPrices == true,
          moduleName: "Consulta de preços concorrentes",
          module: Modules.researchPrices,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.saleRequest == true,
          moduleName: "Pedido de vendas",
          module: Modules.saleRequest,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.transferBetweenStocks == true,
          moduleName: "Transferência entre estoques",
          module: Modules.transferBetweenStocks,
        ),
        EnableOrDisableModule(
          client: client,
          enabled: client.modules?.transferRequest == true,
          moduleName: "Pedido de transferência",
          module: Modules.transferRequest,
        ),
      ],
    );
  }
}
