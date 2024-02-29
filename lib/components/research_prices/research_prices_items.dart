import 'package:celta_inventario/models/research_prices/research_prices.dart';
import 'package:celta_inventario/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../global_widgets/global_widgets.dart';

class ResearchPricesItems extends StatefulWidget {
  final int enterpriseCode;
  const ResearchPricesItems({
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<ResearchPricesItems> createState() => _ResearchPricesItemsState();
}

class _ResearchPricesItemsState extends State<ResearchPricesItems> {
  int selectedIndex = -1;

  Widget itemOfList({
    required int index,
    required ResearchPricesProvider researchPricesProvider,
  }) {
    ResearchModel research = researchPricesProvider.researchPrices[index];
    return Container(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (researchPricesProvider.isLoadingResearchPrices ||
              researchPricesProvider.isLoadingAddOrUpdateResearch) return;
          setState(() {
            if (selectedIndex == index) {
              selectedIndex = -1;
            } else {
              selectedIndex = index;
            }
          });
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Código",
                  value: research.Code.toString(),
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Data de criação",
                  value: research.CreationDate.toString(),
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Concorrentes",
                  value: research.Concurrents.isEmpty
                      ? "Não há"
                      : research.Concurrents.toString(),
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Observação",
                  value: research.Observation.isEmpty
                      ? "Não há"
                      : research.Observation,
                ),
                if (research.Products?.isNotEmpty == true)
                  TextButton(
                    onPressed: () {},
                    child: const Text("Visualizar produtos"),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          APPROUTES.INSERT_OR_UPDATE_RESEARCH_PRICE,
                          arguments: {
                            "research": research,
                            "enterpriseCode": widget.enterpriseCode,
                          },
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
