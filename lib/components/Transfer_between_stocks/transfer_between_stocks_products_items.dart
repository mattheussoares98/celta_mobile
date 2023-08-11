import 'package:celta_inventario/Models/transfer_between_stocks_models%20copy/transfer_between_stock_product_model.dart';
import 'package:celta_inventario/components/Transfer_between_stocks/transfer_between_stocks_all_stocks.dart';
import 'package:celta_inventario/components/Transfer_between_stocks/transfer_between_stocks_insert_quantity.dart';
import 'package:celta_inventario/providers/transfer_between_stocks_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:provider/provider.dart';
import '../Global_widgets/title_and_value.dart';

class TransferBetweenStocksProductsItems extends StatefulWidget {
  final int internalEnterpriseCode;
  final TextEditingController consultedProductController;
  final GlobalKey<FormState> dropDownFormKey;
  final GlobalKey<FormState> insertQuantityFormKey;
  const TransferBetweenStocksProductsItems({
    required this.internalEnterpriseCode,
    required this.consultedProductController,
    required this.dropDownFormKey,
    required this.insertQuantityFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferBetweenStocksProductsItems> createState() =>
      _TransferBetweenStocksProductsItemsState();
}

class _TransferBetweenStocksProductsItemsState
    extends State<TransferBetweenStocksProductsItems> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    TransferBetweenStocksProvider transferBetweenStocksProvider =
        Provider.of(context);
    return Expanded(
      child: Column(
        mainAxisAlignment: transferBetweenStocksProvider.productsCount > 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transferBetweenStocksProvider.productsCount,
              itemBuilder: (context, index) {
                TransferBetweenStocksProductModel product =
                    transferBetweenStocksProvider.products[index];
                return GestureDetector(
                  onTap: transferBetweenStocksProvider
                          .isLoadingTypeStockAndJustifications
                      ? null
                      : () {
                          transferBetweenStocksProvider
                                  .jsonAdjustStock["ProductPackingCode"] =
                              product.ProductPackingCode;
                          transferBetweenStocksProvider
                                  .jsonAdjustStock["ProductCode"] =
                              product.ProductCode;
                          if (!transferBetweenStocksProvider
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
                                transferBetweenStocksProvider
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
                                transferBetweenStocksProvider
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
                            otherWidget: TransferBetweenStocksAllStocks
                                .transferBetweenStocksAllStocks(
                              context: context,
                              hasStocks: product.Stocks.length > 0,
                              product: product,
                              isLoading: transferBetweenStocksProvider
                                  .isLoadingAdjustStock,
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
                            TransferBetweenStocksInsertQuantity(
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
