import 'package:celta_inventario/Components/Adjust_stock_components/adjust_stock_insert_quantity.dart';
import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:flutter/material.dart';

class AdjustStockProductsItems extends StatefulWidget {
  final AdjustStockProvider adjustStockProvider;
  final int internalEnterpriseCode;
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  const AdjustStockProductsItems({
    required this.internalEnterpriseCode,
    required this.consultedProductController,
    required this.adjustStockProvider,
    required this.dropDownFormKey,
    required this.insertQuantityFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<AdjustStockProductsItems> createState() =>
      _AdjustStockProductsItemsState();
}

class _AdjustStockProductsItemsState extends State<AdjustStockProductsItems> {
  int selectedIndex = -1;

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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: widget.adjustStockProvider.productsCount > 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.adjustStockProvider.productsCount,
              itemBuilder: (context, index) {
                var product = widget.adjustStockProvider.products[index];
                return GestureDetector(
                  onTap: widget.adjustStockProvider.isLoadingAdjustStock
                      ? null
                      : () {
                          widget.adjustStockProvider
                                  .jsonAdjustStock["ProductPackingCode"] =
                              product.ProductPackingCode.toString();
                          widget.adjustStockProvider
                                  .jsonAdjustStock["ProductCode"] =
                              product.ProductCode.toString();
                          if (!widget.adjustStockProvider
                                  .consultedProductFocusNode.hasFocus &&
                              selectedIndex == index) {
                            //só cai aqui quando está exibindo a opção de
                            //alterar/anular a quantidade de algum produto e ele
                            //não está com o foco. Ao clicar nele novamnete, ao
                            //invés de minimizá-lo, só altera o foco novamente
                            //pra ele

                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              //se não colocar em um future pra mudar o foco,
                              //não funciona corretamente
                              FocusScope.of(context).requestFocus(
                                widget.adjustStockProvider
                                    .consultedProductFocusNode,
                              );
                            });
                            return;
                          }
                          if (selectedIndex != index) {
                            widget.consultedProductController.clear();
                            //necessário apagar o campo da quantidade quando
                            //mudar de produto selecionado
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              //se não colocar em um future pra mudar o foco,
                              //não funciona corretamente
                              FocusScope.of(context).requestFocus(
                                widget.adjustStockProvider
                                    .consultedProductFocusNode,
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
                            title: "Nome",
                            value: product.Name,
                          ),
                          values(
                            title: "PLU",
                            value: product.PriceLookUp,
                          ),
                          values(
                            title: "Embalagem",
                            value: product.PackingQuantity,
                          ),
                          // values(
                          //   title: "Estoque atual",
                          //   value: product.CurrentStock,
                          // ),
                          // values(
                          //   title: "Saldo estoque de venda",
                          //   value: product.SaldoEstoqueVenda,
                          // ),
                          if (selectedIndex == index)
                            AdjustStockInsertQuantity(
                              adjustStockProvider: widget.adjustStockProvider,
                              consultedProductController:
                                  widget.consultedProductController,
                              dropDownFormKey: widget.dropDownFormKey,
                              insertQuantityFormKey:
                                  widget.insertQuantityFormKey,
                              internalEnterpriseCode:
                                  widget.internalEnterpriseCode,
                              index: index,
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
