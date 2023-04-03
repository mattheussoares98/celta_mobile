import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import '../Global_widgets/title_and_value.dart';
import 'adjust_stock_insert_quantity.dart';

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
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Nome",
                            value: product.Name,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "PLU",
                            value: product.PriceLookUp,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Embalagem",
                            value: product.PackingQuantity,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Estoque atual",
                            value: ConvertString.convertToBrazilianNumber(
                              product.CurrentStock,
                            ),
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Saldo estoque de venda",
                            value: ConvertString.convertToBrazilianNumber(
                              product.SaldoEstoqueVenda,
                            ),
                            otherWidget: Icon(
                              selectedIndex != index
                                  ? Icons.arrow_drop_down_sharp
                                  : Icons.arrow_drop_up_sharp,
                              color: Theme.of(context).colorScheme.primary,
                              size: 30,
                            ),
                          ),
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
