import 'package:celta_inventario/Components/Global_widgets/insert_quantity_textformfield.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestCartItems extends StatefulWidget {
  final TextEditingController textEditingController;
  const SaleRequestCartItems({
    required this.textEditingController,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestCartItems> createState() => _SaleRequestCartItemsState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SaleRequestCartItemsState extends State<SaleRequestCartItems> {
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

  // TextEditingController _textEditingController = TextEditingController();

  int _selectedIndex = -1;

  FocusNode _focusNode = FocusNode();

  changeFocus({
    required SaleRequestProvider saleRequestProvider,
    required int index,
  }) async {
    if (!_focusNode.hasFocus && _selectedIndex == index) {
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(
          _focusNode,
        );
      });
      return;
    }
    if (_selectedIndex != index) {
      widget.textEditingController.text = "";
      widget.textEditingController.clear();

      setState(() {
        _selectedIndex = index;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(
          _focusNode,
        );
      });
    } else {
      FocusScope.of(context).unfocus();
      //quando clica no mesmo produto, fecha o teclado
      setState(() {
        _selectedIndex = -1;
      });
    }
  }

  TextStyle hasMinimumWholeQuantity({
    required double minimumWholeQuantity,
    required bool isSaleRetailPrice,
  }) {
    var green = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 15,
    );
    var black = const TextStyle(
      color: Colors.black,
      fontSize: 15,
    );
    double? controllerInDouble =
        double.tryParse(widget.textEditingController.text);

    if (isSaleRetailPrice) {
      if (controllerInDouble == null) {
        return green;
      } else if (controllerInDouble < minimumWholeQuantity) {}
    } else {
      if (controllerInDouble >= minimumWholeQuantity) {
        return green;
      } else {
        return black;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: saleRequestProvider.cartProductsCount,
                itemBuilder: (context, index) {
                  var product = saleRequestProvider.cartProducts[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  await changeFocus(
                                    saleRequestProvider: saleRequestProvider,
                                    index: index,
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, top: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6),
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
                                                        " (${product["PackingQuantity"]})" +
                                                        '\nplu: ${product["PLU"]}',
                                                    style: const TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    saleRequestProvider
                                                        .removeProductFromCart(
                                                      product[
                                                          "ProductPackingCode"],
                                                    );

                                                    ShowErrorMessage
                                                        .showErrorMessage(
                                                      error: "Produto removido",
                                                      context: context,
                                                      functionSnackBarAction:
                                                          () {
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
                                                                .toStringAsFixed(
                                                                    3)
                                                                .replaceAll(
                                                                    RegExp(
                                                                        r'\.'),
                                                                    ','),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          titleAndSubtitle(
                                                            title: "Preço",
                                                            subtitle:
                                                                ConvertString
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
                                                            subtitle:
                                                                ConvertString
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      changeFocus(
                                                        saleRequestProvider:
                                                            saleRequestProvider,
                                                        index: index,
                                                      );
                                                    },
                                                    icon: _selectedIndex != -1
                                                        ? Icon(
                                                            Icons.expand_less,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          )
                                                        : Icon(
                                                            Icons.edit,
                                                            color: Theme.of(
                                                                    context)
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
                              if (_selectedIndex == index)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InsertQuantityTextFormField(
                                        focusNode: _focusNode,
                                        textEditingController:
                                            widget.textEditingController,
                                        formKey: _formKey,
                                        onChanged: () {
                                          setState(() {});
                                        },
                                        labelText: "Digite a nova quantidade",
                                        hintText: "Digite a nova quantidade",
                                      ),
                                      Text(
                                        "Mín. atacado : ${product["MinimumWholeQuantity"]}",
                                        style: hasMinimumWholeQuantity(
                                            product["MinimumWholeQuantity"]),
                                      ),
                                      Text(
                                        "Preço atacado: ${product["WholePracticedPrice"]}",
                                        style: hasMinimumWholeQuantity(
                                            product["MinimumWholeQuantity"]),
                                      ),
                                      Text(
                                        "Preço venda: ${ConvertString.convertToBRL(product["RetailPracticedPrice"])}",
                                        style: hasMinimumWholeQuantity(
                                            product["MinimumWholeQuantity"]),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (index == saleRequestProvider.cartProductsCount - 1 &&
                          saleRequestProvider.cartProductsCount > 1)
                        TextButton(
                          onPressed: () {
                            ShowAlertDialog().showAlertDialog(
                              context: context,
                              title: "Limpar carrinho",
                              subtitle:
                                  "Deseja realmente limpar todos produtos do carrinho?",
                              function: () {
                                saleRequestProvider.clearCart();
                              },
                            );
                          },
                          child: const Text(
                            "Limpar carrinho",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
