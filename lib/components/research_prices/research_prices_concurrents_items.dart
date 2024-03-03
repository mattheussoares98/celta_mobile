import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global_widgets/global_widgets.dart';
import '../../models/research_prices/research_prices.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

class ConcurrentsItems extends StatefulWidget {
  const ConcurrentsItems({Key? key}) : super(key: key);

  @override
  State<ConcurrentsItems> createState() => _ConcurrentsItemsState();
}

class _ConcurrentsItemsState extends State<ConcurrentsItems> {
  int selectedIndex = -1;

  Widget itemOfList({
    required int index,
    required ResearchPricesProvider researchPricesProvider,
  }) {
    ConcurrentsModel concurrent = researchPricesProvider.concurrents[index];
    int? enterpriseCode = ModalRoute.of(context)!.settings.arguments as int?;

    return Container(
      child: InkWell(
        onTap: () {
          researchPricesProvider.updateSelectedConcurrent(concurrent);
          Navigator.of(context).pushNamed(APPROUTES.RESEARCH_PRICES_INSERT_PRICE);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Código da pesquisa",
                  value: concurrent.ResearchOfPriceCode.toString(),
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Código do concorrente",
                  value: concurrent.ConcurrentCode.toString(),
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Nome",
                  value: concurrent.Name,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Observação",
                  value: concurrent.Observation,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Endereços",
                  value: concurrent.Address.Zip?.isEmpty == true
                      ? "Nenhum informado"
                      : "${concurrent.Address.Address.toString()}, ${concurrent.Address.District}, ${concurrent.Address.City}, ${concurrent.Address.Number}. \nCEP: ${concurrent.Address.Zip}",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        researchPricesProvider
                            .updateSelectedConcurrent(concurrent);
                        Navigator.of(context).pushNamed(
                          APPROUTES.RESERACH_PRICE_INSERT_UPDATE_CONCORRENT,
                          arguments: enterpriseCode,
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Alterar concorrente"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider =
        Provider.of(context, listen: true);
    int itensPerLine = ResponsiveItems.getItensPerLine(context);
    int concurrentsCount = researchPricesProvider.concurrentsCount;

    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: ResponsiveItems.itemCount(
            itemsCount: concurrentsCount,
            context: context,
          ),
          itemBuilder: (context, index) {
            final startIndex = index * itensPerLine;
            final endIndex = (startIndex + itensPerLine <= concurrentsCount)
                ? startIndex + itensPerLine
                : concurrentsCount;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = startIndex; i < endIndex; i++)
                  Expanded(
                    child: itemOfList(
                      index: i,
                      researchPricesProvider: researchPricesProvider,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
