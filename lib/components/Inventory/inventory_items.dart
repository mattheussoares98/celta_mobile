import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory_provider.dart';

class InventoryItems extends StatelessWidget {
  const InventoryItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context);
    final codigoInternoEmpresa =
        ModalRoute.of(context)!.settings.arguments as int;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Selecione o inventário',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: inventoryProvider.inventoryCount,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    APPROUTES.COUNTINGS,
                    arguments: {
                      "codigoInternoInventario": inventoryProvider
                          .inventorys[index].codigoInternoInventario,
                      "codigoInternoEmpresa":
                          codigoInternoEmpresa, //passando o código da empresa também porque vai precisar na tela de consulta de produtos
                    },
                  );
                },
                //sem esse Card, não funciona o gesture detector no campo inteiro
                child: PersonalizedCard.personalizedCard(
                  context: context,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Empresa",
                          value:
                              inventoryProvider.inventorys[index].nomeempresa,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Tipo de estoque",
                          value: inventoryProvider
                              .inventorys[index].nomeTipoEstoque,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Responsável",
                          value: inventoryProvider
                              .inventorys[index].nomefuncionario,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Congelado em",
                          value: formatDate(
                            inventoryProvider
                                .inventorys[index].dataCongelamentoInventario,
                            [dd, '/', mm, '/', yyyy, ' ', HH, ':', mm, ':', ss],
                          ),
                        ),

                        //data de criação do inventário
                        // const SizedBox(height: 5),
                        // Row(children: [
                        //   Text(
                        //     'Criado em: ',
                        //     style: _fontStyle,
                        //   ),
                        //   const SizedBox(height: 25),
                        //   Text(
                        //     formatDate(
                        //       inventoryProvider
                        //           .inventorys[index].dataCriacaoInventario,
                        //       [dd, '-', mm, '-', yyyy, ' ', hh, ':', mm, ':', ss],
                        //     ),
                        //     style: _fontBoldStyle,
                        //   ),
                        // ]),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Observações",
                          value: inventoryProvider
                                  .inventorys[index].obsInventario.isEmpty
                              ? 'Não há observações'
                              : inventoryProvider
                                  .inventorys[index].obsInventario,
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
    );
  }
}
