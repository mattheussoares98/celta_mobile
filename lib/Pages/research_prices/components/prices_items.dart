import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/research_prices/research_prices.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class PricesItems extends StatefulWidget {
  final int enterpriseCode;
  const PricesItems({
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<PricesItems> createState() => _PricesItemsState();
}

class _PricesItemsState extends State<PricesItems> {
  int selectedIndex = -1;

  Widget itemOfList({
    required int index,
    required ResearchPricesProvider researchPricesProvider,
  }) {
    ResearchPricesResearchModel research =
        researchPricesProvider.researchPrices[index];
    return InkWell(
      focusColor: Colors.white.withOpacity(0),
      hoverColor: Colors.white.withOpacity(0),
      splashColor: Colors.white.withOpacity(0),
      highlightColor: Colors.white.withOpacity(0),
      onTap: () {
        researchPricesProvider.updateSelectedResearch(research);
        researchPricesProvider.loadAssociatedsConcurrents();
        Navigator.of(context).pushNamed(
          APPROUTES.RESEARCH_PRICES_CONCURRENTS,
          arguments: {"enterpriseCode": widget.enterpriseCode},
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleAndSubtitle.titleAndSubtitle(
                title: "Código",
                subtitle: research.Code.toString(),
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Nome",
                subtitle:
                    research.Name?.isEmpty == true ? "Não há" : research.Name,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Observação",
                subtitle: research.Observation?.isEmpty == true
                    ? "Não há"
                    : research.Observation,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Produtos restringidos",
                subtitle: research.RestrictProducts ? "Sim" : "Não",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Data de criação",
                subtitle: research.CreationDate.toString(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      researchPricesProvider.updateSelectedResearch(research);
                      Navigator.of(context).pushNamed(
                        APPROUTES.RESEARCH_PRICES_INSERT_UPDATE_RESEARCH_PRICE,
                        arguments: {"enterpriseCode": widget.enterpriseCode},
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Alterar pesquisa"),
                  ),
                ],
              )
            ],
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
    int researchsCount = researchPricesProvider.researchPricesCount;

    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: ResponsiveItems.itemCount(
            itemsCount: researchsCount,
            context: context,
          ),
          itemBuilder: (context, index) {
            final startIndex = index * itensPerLine;
            final endIndex = (startIndex + itensPerLine <= researchsCount)
                ? startIndex + itensPerLine
                : researchsCount;

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
