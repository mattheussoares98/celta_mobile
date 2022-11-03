import 'package:celta_inventario/components/personalized_card.dart';
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

    TextStyle _fontStyle = const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontFamily: 'OpenSans',
    );
    TextStyle _fontBoldStyle = const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

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
                        Row(
                          children: [
                            Text(
                              'Empresa: ',
                              style: _fontStyle,
                            ),
                            const SizedBox(height: 25),
                            Expanded(
                              child: Text(
                                inventoryProvider.inventorys[index].nomeempresa,
                                style: _fontBoldStyle,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        FittedBox(
                          child: Row(
                            children: [
                              Text(
                                'Tipo de estoque: ',
                                style: _fontStyle,
                              ),
                              Text(
                                inventoryProvider
                                    .inventorys[index].nomeTipoEstoque,
                                style: _fontBoldStyle,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        FittedBox(
                          child: Row(
                            children: [
                              Text(
                                'Responsável: ',
                                style: _fontStyle,
                              ),
                              const SizedBox(height: 25),
                              Text(
                                inventoryProvider
                                    .inventorys[index].nomefuncionario,
                                style: _fontBoldStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        FittedBox(
                          child: Row(children: [
                            Text(
                              'Congelado em: ',
                              style: _fontStyle,
                            ),
                            const SizedBox(height: 25),
                            Text(
                              formatDate(
                                inventoryProvider.inventorys[index]
                                    .dataCongelamentoInventario,
                                [
                                  dd,
                                  '/',
                                  mm,
                                  '/',
                                  yyyy,
                                  ' ',
                                  HH,
                                  ':',
                                  mm,
                                  ':',
                                  ss
                                ],
                              ),
                              style: _fontBoldStyle,
                            ),
                          ]),
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
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Observações: ',
                              style: _fontStyle,
                            ),
                            if (inventoryProvider
                                    .inventorys[index].obsInventario.length <
                                19)
                              //se houver poucos caracteres na observação, exibe na mesma linha...
                              Expanded(
                                child: Text(
                                  inventoryProvider.inventorys[index]
                                          .obsInventario.isEmpty
                                      ? 'Não há observações'
                                      : inventoryProvider
                                          .inventorys[index].obsInventario,
                                  style: _fontBoldStyle,
                                ),
                              ),
                          ],
                        ),
                        if (inventoryProvider
                                .inventorys[index].obsInventario.length >
                            19)
                          //se houver bastante caracteres, quebra a linha pra exibir melhor
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  inventoryProvider
                                      .inventorys[index].obsInventario,
                                  style: _fontBoldStyle,
                                ),
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
    );
  }
}
