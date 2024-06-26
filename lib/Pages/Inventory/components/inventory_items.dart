import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../components/global_widgets/global_widgets.dart';

class InventoryItems extends StatelessWidget {
  const InventoryItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: inventoryProvider.inventoryCount,
            itemBuilder: (context, index) {
              return InkWell(
          focusColor: Colors.white.withOpacity(0),
          hoverColor: Colors.white.withOpacity(0),
          splashColor: Colors.white.withOpacity(0),
          highlightColor: Colors.white.withOpacity(0),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    APPROUTES.COUNTINGS,
                    arguments: {
                      "codigoInternoInventario": inventoryProvider
                          .inventorys[index].codigoInternoInventario,
                      "codigoInternoEmpresa": arguments[
                          "CodigoInterno_Empresa"], //passando o código da empresa também porque vai precisar na tela de consulta de produtos
                    },
                  );
                },
                //sem esse Card, não funciona o gesture detector no campo inteiro
                child: Card(
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
