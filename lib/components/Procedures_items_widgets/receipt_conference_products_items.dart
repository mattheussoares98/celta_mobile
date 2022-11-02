import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/Components/Conference_components/conference_insert_quantity_widget.dart';
import 'package:celta_inventario/providers/receipt_conference_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptConferenceProductsItems extends StatefulWidget {
  final int docCode;
  final ReceiptConferenceProvider receiptConferenceProvider;
  const ReceiptConferenceProductsItems({
    required this.docCode,
    required this.receiptConferenceProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<ReceiptConferenceProductsItems> createState() =>
      _ReceiptConferenceProductsItemsState();
}

class _ReceiptConferenceProductsItemsState
    extends State<ReceiptConferenceProductsItems> {
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

  Column values({
    required String title,
    required String value,
    required int index,
    required ReceiptConferenceProvider receiptConferenceProvider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              "${title}: ",
              style: _fontStyle,
            ),
            // const SizedBox(width: 5),
            Expanded(
              child: Text(
                value,
                style: _fontBoldStyle,
                maxLines: 2,
              ),
            ),
          ],
        ),
        // const SizedBox(height: 5),
      ],
    );
  }

  static final TextEditingController _consultedProductController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    ReceiptConferenceProvider receiptConferenceProvider =
        Provider.of(context, listen: true);

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: receiptConferenceProvider.productsCount,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: receiptConferenceProvider.isUpdatingQuantity ||
                          receiptConferenceProvider.consultingProducts
                      ? null
                      : () {
                          if (!receiptConferenceProvider
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
                                receiptConferenceProvider
                                    .consultedProductFocusNode,
                              );
                            });
                            return;
                          }
                          if (selectedIndex != index) {
                            _consultedProductController.clear();
                            //necessário apagar o campo da quantidade quando
                            //mudar de produto selecionado
                            receiptConferenceProvider
                                .consultedProductFocusNode = FocusNode();
                            //se não fizer isso, a mudança de foco abaixo não da
                            //certo. Dessa forma o teclado nem está fechando
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              //se não colocar em um future pra mudar o foco,
                              //não funciona corretamente
                              FocusScope.of(context).requestFocus(
                                receiptConferenceProvider
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
                        children: [
                          values(
                            title: "Nome",
                            value: receiptConferenceProvider
                                .products[index].Nome_Produto,
                            index: index,
                            receiptConferenceProvider:
                                receiptConferenceProvider,
                          ),
                          values(
                            title: "PLU",
                            value: receiptConferenceProvider
                                .products[index].CodigoPlu_ProEmb,
                            index: index,
                            receiptConferenceProvider:
                                receiptConferenceProvider,
                          ),
                          values(
                            title: "Embalagem",
                            value: receiptConferenceProvider
                                .products[index].PackingQuantity,
                            index: index,
                            receiptConferenceProvider:
                                receiptConferenceProvider,
                          ),
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
                                      "EANs: ",
                                      style: _fontStyle,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      receiptConferenceProvider
                                                  .products[index].AllEans !=
                                              ""
                                          ? receiptConferenceProvider
                                              .products[index].AllEans
                                          : "Nenhum",
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
                            //só aparece a quantidade contada se o usuário clicar
                            //no produto para ele não saber quais produtos já
                            //foram contados também só aparece a opção de inserir
                            //a quantidade quando clica no produto
                            Column(
                              children: [
                                values(
                                  title: "Quantidade contada",
                                  value: receiptConferenceProvider
                                              .products[index]
                                              .Quantidade_ProcRecebDocProEmb ==
                                          null
                                      //se o valor for nulo, basta convertê-lo
                                      //para String. Se não for nulo, basta
                                      //alterar os pontos por vírgula e
                                      //mostrar no máximo 3 casas decimais
                                      ? "nula"
                                      : double.tryParse(
                                              receiptConferenceProvider
                                                  .products[index]
                                                  .Quantidade_ProcRecebDocProEmb
                                                  .toString())!
                                          .toStringAsFixed(3)
                                          .replaceAll(RegExp(r'\.'), ','),
                                  index: index,
                                  receiptConferenceProvider:
                                      receiptConferenceProvider,
                                ),
                                const SizedBox(height: 10),
                                ConferenceInsertQuantityWidget(
                                  consultedProductController:
                                      _consultedProductController,
                                  receiptConferenceProvider:
                                      widget.receiptConferenceProvider,
                                  conferenceProductModel:
                                      receiptConferenceProvider.products[index],
                                  docCode: widget.docCode,
                                  index: index,
                                ),
                              ],
                            ),
                          const SizedBox(height: 5),
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
