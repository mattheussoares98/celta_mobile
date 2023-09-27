import 'package:celta_inventario/Models/adjust_stock_models/adjust_stock_product_model.dart';
import 'package:celta_inventario/components/Adjust_stock/adjust_stock_all_stocks.dart';
import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Global_widgets/title_and_value.dart';
import 'adjust_stock_insert_quantity.dart';

class AdjustStockProductsItems extends StatefulWidget {
  final int internalEnterpriseCode;
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  final Function getProductWithCamera;
  const AdjustStockProductsItems({
    required this.internalEnterpriseCode,
    required this.getProductWithCamera,
    required this.consultedProductController,
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
    AdjustStockProvider adjustStockProvider = Provider.of(context);
    return Expanded(
      child: Column(
        mainAxisAlignment: adjustStockProvider.productsCount > 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: adjustStockProvider.productsCount,
              itemBuilder: (context, index) {
                AdjustStockProductModel product =
                    adjustStockProvider.products[index];

                if (adjustStockProvider.productsCount == 1) {
                  selectedIndex = index;
                }
                return GestureDetector(
                  onTap: adjustStockProvider
                              .isLoadingTypeStockAndJustifications ||
                          adjustStockProvider.isLoadingAdjustStock
                      ? null
                      : () {
                          adjustStockProvider
                                  .jsonAdjustStock["ProductPackingCode"] =
                              product.ProductPackingCode.toString();
                          adjustStockProvider.jsonAdjustStock["ProductCode"] =
                              product.ProductCode.toString();
                          if (!adjustStockProvider
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
                                adjustStockProvider.consultedProductFocusNode,
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
                                adjustStockProvider.consultedProductFocusNode,
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
                  child: Card(
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
                            otherWidget:
                                AdjustStockAllStocks.adjustStockAllStocks(
                              context: context,
                              hasStocks: product.Stocks.length > 0,
                              product: product,
                              isLoading:
                                  adjustStockProvider.isLoadingAdjustStock,
                            ),
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
                              consultedProductController:
                                  widget.consultedProductController,
                              dropDownFormKey: widget.dropDownFormKey,
                              insertQuantityFormKey:
                                  widget.insertQuantityFormKey,
                              internalEnterpriseCode:
                                  widget.internalEnterpriseCode,
                              index: index,
                              getProductWithCamera: widget.getProductWithCamera,
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
