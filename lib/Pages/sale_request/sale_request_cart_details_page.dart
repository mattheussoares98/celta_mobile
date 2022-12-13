import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestCartDetailsPage extends StatefulWidget {
  final int enterpriseCode;
  final int requestTypeCode;
  const SaleRequestCartDetailsPage({
    required this.enterpriseCode,
    required this.requestTypeCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestCartDetailsPage> createState() =>
      _SaleRequestCartDetailsPageState();
}

class _SaleRequestCartDetailsPageState
    extends State<SaleRequestCartDetailsPage> {
  Widget titleAndSubtitle({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 100, 97, 97),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: saleRequestProvider.cartProducts.length,
                    itemBuilder: (context, index) {
                      var product = saleRequestProvider.cartProducts[index];

                      return Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3, top: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          child: FittedBox(
                                            child: Text(
                                              (index + 1).toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                    offset: Offset(0, 0),
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                product["Name"] +
                                                    " (${product["PackingQuantity"]})",
                                                style: const TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                saleRequestProvider
                                                    .removeProductFromCart(
                                                  product["ProductPackingCode"],
                                                );

                                                ShowErrorMessage
                                                    .showErrorMessage(
                                                  error: "Produto removido",
                                                  context: context,
                                                  functionSnackBarAction: () {
                                                    saleRequestProvider
                                                        .restoreProductRemoved();
                                                  },
                                                  labelSnackBarAction:
                                                      "Restaurar produto",
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      titleAndSubtitle(
                                                        title: "Qtd",
                                                        subtitle: product[
                                                                "Quantity"]
                                                            .toStringAsFixed(3)
                                                            .replaceAll(
                                                                RegExp(r'\.'),
                                                                ','),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      titleAndSubtitle(
                                                        title: "Preço",
                                                        subtitle: ConvertString
                                                            .convertToBRL(
                                                          product["Value"]
                                                              .toString(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      titleAndSubtitle(
                                                        title: "Total",
                                                        subtitle: ConvertString
                                                            .convertToBRL(
                                                          "${(product["Quantity"] * product["Value"])} ",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30),
                                              child: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.grey[400],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "ITENS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          saleRequestProvider.cartProducts.length.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "TOTAL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          ConvertString.convertToBRL(
                            saleRequestProvider.totalCartPrice,
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: saleRequestProvider.isLoadingSaveSaleRequest ||
                              saleRequestProvider.costumerCode == -1
                          ? null
                          : () async {
                              await saleRequestProvider.saveSaleRequest(
                                enterpriseCode: widget.enterpriseCode,
                                requestTypeCode: widget.requestTypeCode,
                                context: context,
                              );
                            },
                      child: saleRequestProvider.costumerCode == -1
                          ? const Text("INSIRA UM CLIENTE")
                          : const Text(
                              "SALVAR PEDIDO",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                // color: Theme.of(context).colorScheme.primary,
                                fontSize: 17,
                                shadows: <Shadow>[
                                  const Shadow(
                                    offset: Offset(1.5, 1.5),
                                    blurRadius: 2.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
