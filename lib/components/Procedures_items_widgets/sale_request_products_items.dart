import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestProductsItems extends StatefulWidget {
  // final int internalEnterpriseCode;
  // final TextEditingController consultedProductController;
  // final GlobalKey<FormState> dropDownFormKey;
  // final GlobalKey<FormState> insertQuantityFormKey;
  const SaleRequestProductsItems({
    // required this.internalEnterpriseCode,
    // required this.consultedProductController,
    // required this.dropDownFormKey,
    // required this.insertQuantityFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestProductsItems> createState() =>
      _SaleRequestProductsItemsState();
}

class _SaleRequestProductsItemsState extends State<SaleRequestProductsItems> {
  int selectedIndex = -1;
  double _quantityToAdd = 1;
  TextEditingController _consultedProductController = TextEditingController();

  TextStyle _fontStyle = const TextStyle(
    fontSize: 17,
    color: Colors.black,
    fontFamily: 'OpenSans',
  );
  TextStyle _fontBoldStyle = const TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  Widget values({
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "${title}: ",
          style: _fontStyle,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: _fontBoldStyle,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  GlobalKey<FormState> consultedProductFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double? _controllerInDouble =
        double.tryParse(_consultedProductController.text);

    SaleRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: true,
    );

    return Expanded(
      child: Column(
        mainAxisAlignment: saleRequestProvider.productsCount > 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: saleRequestProvider.productsCount,
              itemBuilder: (context, index) {
                var product = saleRequestProvider.products[index];
                return GestureDetector(
                  onTap: saleRequestProvider.isLoadingProducts
                      ? null
                      : () {
                          if (!saleRequestProvider
                                  .consultedProductFocusNode.hasFocus &&
                              selectedIndex == index) {
                            //só cai aqui quando está exibindo a opção de
                            //alterar/anular a quantidade de algum produto e ele
                            //não está com o foco. Ao clicar nele novamnete, ao
                            //invés de minimizá-lo, só altera o foco novamente
                            //pra ele

                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              FocusScope.of(context).requestFocus(
                                saleRequestProvider.consultedProductFocusNode,
                              );
                            });
                            return;
                          }
                          if (selectedIndex != index) {
                            _consultedProductController.clear();
                            //necessário apagar o campo da quantidade quando
                            //mudar de produto selecionado

                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              FocusScope.of(context).requestFocus(
                                saleRequestProvider.consultedProductFocusNode,
                              );
                            });
                            setState(() {
                              selectedIndex = index;
                              //isso faz com que apareça os botões de "conferir"
                              //e "liberar" somente no item selecionado
                            });
                          } else {
                            FocusScope.of(context).unfocus();
                            //quando clica no mesmo produto, fecha o teclado. Se
                            //não fizer isso, o foco volta para o de consulta de
                            //produtos
                            setState(() {
                              selectedIndex = -1;
                            });
                          }
                        },
                  child: PersonalizedCard.personalizedCard(
                    context: context,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          values(
                            title: "PLU",
                            value: product.PLU.toString(),
                          ),
                          values(
                            title: "Produto",
                            value: product.Name.toString() +
                                " (${product.PackingQuantity})",
                          ),
                          // values(
                          //   title: "Embalagem",
                          //   value: product.PackingQuantity.toString(),
                          // ),
                          values(
                            title: "Preço praticado",
                            value: product.RetailPracticedPrice.toString()
                                    .replaceFirst(RegExp(r'\.'), ',') +
                                "R\$",
                          ),
                          // values(
                          //   title: "Preço de varejo",
                          //   value:
                          //       double.parse(product.RetailSalePrice.toString())
                          //               .toStringAsFixed(2)
                          //               .toString()
                          //               .replaceFirst(RegExp(r'\.'), ',') +
                          //           "R\$",
                          // ),
                          // values(
                          //   title: "Preço de oferta",
                          //   value: double.parse(
                          //               product.RetailOfferPrice.toString())
                          //           .toStringAsFixed(2)
                          //           .toString()
                          //           .replaceFirst(RegExp(r'\.'), ',') +
                          //       "R\$",
                          // ),
                          values(
                            title: "Preço de atacado",
                            value: double.parse(
                                        product.WholePracticedPrice.toString())
                                    .toStringAsFixed(2)
                                    .toString()
                                    .replaceFirst(RegExp(r'\.'), ',') +
                                "R\$",
                          ),
                          // values(
                          //   title: "WholeSalePrice",
                          //   value: product.WholeSalePrice.toString()
                          //           .replaceFirst(RegExp(r'\.'), ',') +
                          //       "R\$",
                          // ),
                          // values(
                          //   title: "WholeOfferPrice",
                          //   value: product.WholeOfferPrice.toString()
                          //           .replaceFirst(RegExp(r'\.'), ',') +
                          //       "R\$",
                          // ),
                          values(
                            title: "Quantidade mínima para atacado",
                            value: product.MinimumWholeQuantity.toString(),
                          ),
                          // values(
                          //   title: "BalanceStockSale",
                          //   value: product.BalanceStockSale.toString(),
                          // ),
                          Container(
                            // color: Colors.amber,
                            height: 22,
                            child: Row(
                              // mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Saldo estoque de venda: ",
                                      style: _fontStyle,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      product.BalanceStockSale.toString(),
                                      style: _fontBoldStyle,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                Icon(
                                  selectedIndex != index
                                      ? Icons.arrow_drop_down_sharp
                                      : Icons.arrow_drop_up_sharp,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                          if (selectedIndex == index)
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: Colors.grey,
                                    height: 3,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      onPressed: _quantityToAdd == 1
                                          ? null
                                          : () {
                                              setState(() {
                                                _quantityToAdd--;

                                                _consultedProductController
                                                        .text =
                                                    _quantityToAdd.toString();
                                              });
                                              _consultedProductController
                                                      .selection =
                                                  TextSelection.collapsed(
                                                offset:
                                                    _consultedProductController
                                                        .text.length,
                                              );
                                            },
                                      icon: const Icon(
                                        Icons.remove,
                                      ),
                                    ),
                                    Form(
                                      key: consultedProductFormKey,
                                      child: Expanded(
                                        child: TextFormField(
                                          focusNode: saleRequestProvider
                                              .consultedProductFocusNode,
                                          controller:
                                              _consultedProductController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (text) {
                                            _quantityToAdd = double.tryParse(
                                              _consultedProductController.text,
                                            )!;
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                style: BorderStyle.solid,
                                                width: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    IconButton(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      onPressed: () {
                                        setState(() {
                                          _quantityToAdd++;
                                          _consultedProductController.text =
                                              _quantityToAdd.toString();
                                        });
                                        _consultedProductController.selection =
                                            TextSelection.collapsed(
                                          offset: _consultedProductController
                                              .text.length,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  // mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("valor"),
                                              const Text("Adicionar"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
