import 'package:flutter/material.dart';

import '../../../../models/firebase/firebase.dart';
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
          enabled: client.modules?.adjustSalePrice == true,
          module: "Ajuste de preços",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.adjustStock == true,
          module: "Ajuste de estoques",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.buyRequest == true,
          module: "Pedido de compra",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.customerRegister == true,
          module: "Cadastro de cliente",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.inventory == true,
          module: "Inventário",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.priceConference == true,
          module: "Consulta de preços",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.productsConference == true,
          module: "Conferência de produtos (expedição)",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.receipt == true,
          module: "Recebimento",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.researchPrices == true,
          module: "Consulta de preços concorrentes",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.saleRequest == true,
          module: "Pedido de vendas",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.transferBetweenStocks == true,
          module: "Transferência entre estoques",
        ),
        EnableOrDisableModule(
          enabled: client.modules?.transferRequest == true,
          module: "Pedido de transferência",
        ),
      ],
    );
  }
}
