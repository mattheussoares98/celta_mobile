import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/Components/Conference_components/conference_insert_quantity_widget.dart';
import 'package:celta_inventario/providers/conference_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConferenceItems extends StatefulWidget {
  final int docCode;
  final ConferenceProvider conferenceProvider;
  const ConferenceItems({
    required this.docCode,
    required this.conferenceProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<ConferenceItems> createState() => _ConferenceItemsState();
}

class _ConferenceItemsState extends State<ConferenceItems> {
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
    required ConferenceProvider conferenceProvider,
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

  @override
  Widget build(BuildContext context) {
    ConferenceProvider conferenceProvider = Provider.of(context, listen: true);

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: conferenceProvider.productsCount,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (conferenceProvider.isUpdatingQuantity ||
                        conferenceProvider.consultingProducts) return;
                    if (selectedIndex != index) {
                      setState(() {
                        selectedIndex = index;
                        //isso faz com que apareça os botões de "conferir" e "liberar" somente no item selecionado
                      });
                    } else {
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
                            value:
                                conferenceProvider.products[index].Nome_Produto,
                            index: index,
                            conferenceProvider: conferenceProvider,
                          ),
                          values(
                            title: "PLU",
                            value: conferenceProvider
                                .products[index].CodigoPlu_ProEmb,
                            index: index,
                            conferenceProvider: conferenceProvider,
                          ),
                          values(
                            title: "Embalagem",
                            value: conferenceProvider
                                .products[index].PackingQuantity,
                            index: index,
                            conferenceProvider: conferenceProvider,
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
                                      conferenceProvider
                                                  .products[index].AllEans !=
                                              ""
                                          ? conferenceProvider
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
                                  value: conferenceProvider.products[index]
                                              .Quantidade_ProcRecebDocProEmb ==
                                          null
                                      //se o valor for nulo, basta convertê-lo
                                      //para String. Se não for nulo, basta
                                      //alterar os pontos por vírgula e
                                      //mostrar no máximo 3 casas decimais
                                      ? conferenceProvider.products[index]
                                          .Quantidade_ProcRecebDocProEmb
                                          .toString()
                                      : double.tryParse(conferenceProvider
                                              .products[index]
                                              .Quantidade_ProcRecebDocProEmb
                                              .toString())!
                                          .toStringAsFixed(3)
                                          .replaceAll(RegExp(r'\.'), ','),
                                  index: index,
                                  conferenceProvider: conferenceProvider,
                                ),
                                const SizedBox(height: 10),
                                ConferenceInsertQuantityWidget(
                                  conferenceProvider: widget.conferenceProvider,
                                  conferenceProductModel:
                                      conferenceProvider.products[index],
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
