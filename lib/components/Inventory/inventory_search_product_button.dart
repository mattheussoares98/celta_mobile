import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchProductButton extends StatefulWidget {
  final bool isIndividual;
  final Function searchProduct;
  const SearchProductButton({
    Key? key,
    required this.isIndividual,
    required this.searchProduct,
  }) : super(key: key);

  @override
  State<SearchProductButton> createState() => _SearchProductButtonState();
}

class _SearchProductButtonState extends State<SearchProductButton> {
  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              maximumSize: const Size(double.infinity, 50),
            ),
            child: inventoryProvider.isLoadingProducts ||
                    inventoryProvider.isLoadingQuantity
                ? FittedBox(
                    child: Row(
                      children: [
                        Text(
                          inventoryProvider.isLoadingQuantity
                              ? 'ADICIONANDO QUANTIDADE...'
                              : 'CONSULTANDO O PRODUTO...',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            fontSize: 100,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Container(
                          height: 100,
                          width: 100,
                          child: const CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                : FittedBox(
                    child: Row(
                      children: [
                        Text(
                          widget.isIndividual
                              ? 'CONSULTAR E INSERIR UNIDADE'
                              : 'CONSULTAR OU ESCANEAR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 50,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          widget.isIndividual
                              ? Icons.add
                              : Icons.camera_alt_outlined,
                          size: 70,
                        ),
                        if (widget.isIndividual)
                          const Text(
                            '1',
                            style: TextStyle(
                              fontSize: 70,
                            ),
                          ),
                      ],
                    ),
                  ),
            onPressed: inventoryProvider.isLoadingProducts ||
                    inventoryProvider.isLoadingQuantity
                ? null
                : () async {
                    await widget.searchProduct();
                  },
          ),
        ),
      ],
    );
  }
}
