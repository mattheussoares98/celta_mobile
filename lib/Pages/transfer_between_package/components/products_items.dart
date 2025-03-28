// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../Models/soap/products/products.dart';
// import '../../../providers/providers.dart';
// import '../../../utils/utils.dart';
// import '../../../components/components.dart';
// import 'components.dart';

// class ProductsItems extends StatefulWidget {
//   final int internalEnterpriseCode;
//   final TextEditingController consultedProductController;
//   final GlobalKey<FormState> dropDownFormKey;
//   final GlobalKey<FormState> insertQuantityFormKey;
//   const ProductsItems({
//     required this.internalEnterpriseCode,
//     required this.consultedProductController,
//     required this.dropDownFormKey,
//     required this.insertQuantityFormKey,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<ProductsItems> createState() => _ProductsItemsState();
// }

// class _ProductsItemsState extends State<ProductsItems> {
//   int selectedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     TransferBetweenPackageProvider transferBetweenPackageProvider =
//         Provider.of(context);
//     return Expanded(
//       child: Column(
//         mainAxisAlignment: transferBetweenPackageProvider.productsCount > 1
//             ? MainAxisAlignment.center
//             : MainAxisAlignment.start,
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: transferBetweenPackageProvider.productsCount,
//               itemBuilder: (context, index) {
//                 GetProductCmxJson product =
//                     transferBetweenPackageProvider.products[index];
//                 return InkWell(
//                   focusColor: Colors.white.withOpacity(0),
//                   hoverColor: Colors.white.withOpacity(0),
//                   splashColor: Colors.white.withOpacity(0),
//                   highlightColor: Colors.white.withOpacity(0),
//                   onTap: transferBetweenPackageProvider
//                               .isLoadingTypeStockAndJustifications ||
//                           transferBetweenPackageProvider.isLoadingAdjustStock
//                       ? null
//                       : () {
//                           transferBetweenPackageProvider
//                                   .jsonAdjustStock["ProductPackingCode"] =
//                               product.ProductPackingCode;
//                           transferBetweenPackageProvider
//                                   .jsonAdjustStock["ProductCode"] =
//                               product.ProductCode;
//                           if (!transferBetweenPackageProvider
//                                   .consultedProductFocusNode.hasFocus &&
//                               selectedIndex == index) {
//                             //só cai aqui quando está exibindo a opção de
//                             //alterar/anular a quantidade de algum produto e ele
//                             //não está com o foco. Ao clicar nele novamnete, ao
//                             //invés de minimizá-lo, só altera o foco novamente
//                             //pra ele

//                             Future.delayed(const Duration(milliseconds: 100),
//                                 () {
//                               //se não colocar em um future pra mudar o foco,
//                               //não funciona corretamente
//                               FocusScope.of(context).requestFocus(
//                                 transferBetweenPackageProvider
//                                     .consultedProductFocusNode,
//                               );
//                             });
//                             return;
//                           }
//                           if (selectedIndex != index) {
//                             widget.consultedProductController.clear();
//                             //necessário apagar o campo da quantidade quando
//                             //mudar de produto selecionado
//                             Future.delayed(const Duration(milliseconds: 100),
//                                 () {
//                               //se não colocar em um future pra mudar o foco,
//                               //não funciona corretamente
//                               FocusScope.of(context).requestFocus(
//                                 transferBetweenPackageProvider
//                                     .consultedProductFocusNode,
//                               );
//                             });

//                             setState(() {
//                               selectedIndex = index;
//                               //isso faz com que apareça os botões de "conferir"
//                               //e "liberar" somente no item selecionado
//                             });
//                           } else {
//                             FocusScope.of(context).unfocus();
//                             //quando clica no mesmo produto, fecha o teclado. Se
//                             //não fizer isso, o foco volta para o de consulta de
//                             //produtos
//                             setState(() {
//                               selectedIndex = -1;
//                             });
//                           }
//                         },
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           TitleAndSubtitle.titleAndSubtitle(
//                             title: "Nome",
//                             value: product.Name,
//                           ),
//                           TitleAndSubtitle.titleAndSubtitle(
//                             title: "PLU",
//                             value: product.PriceLookUp,
//                             otherWidget: AllStocks.allStocks(
//                               context: context,
//                               hasStocks: product.Stocks.length > 0,
//                               product: product,
//                               isLoading: transferBetweenPackageProvider
//                                   .isLoadingAdjustStock,
//                             ),
//                           ),
//                           TitleAndSubtitle.titleAndSubtitle(
//                             title: "Embalagem",
//                             value: product.PackingQuantity,
//                           ),
//                           TitleAndSubtitle.titleAndSubtitle(
//                             title: "Estoque atual",
//                             value: ConvertString.convertToBrazilianNumber(
//                               product.CurrentStock,
//                             ),
//                           ),
//                           TitleAndSubtitle.titleAndSubtitle(
//                             title: "Saldo estoque de venda",
//                             value: ConvertString.convertToBrazilianNumber(
//                               product.SaldoEstoqueVenda,
//                             ),
//                             otherWidget: Icon(
//                               selectedIndex != index
//                                   ? Icons.arrow_drop_down_sharp
//                                   : Icons.arrow_drop_up_sharp,
//                               color: Theme.of(context).colorScheme.primary,
//                               size: 30,
//                             ),
//                           ),
//                           if (selectedIndex == index)
//                             InsertQuantity(
//                               consultedProductController:
//                                   widget.consultedProductController,
//                               dropDownFormKey: widget.dropDownFormKey,
//                               insertQuantityFormKey:
//                                   widget.insertQuantityFormKey,
//                               internalEnterpriseCode:
//                                   widget.internalEnterpriseCode,
//                               index: index,
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
