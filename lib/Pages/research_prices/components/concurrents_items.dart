import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../models/research_prices/research_prices.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class ConcurrentsItems extends StatefulWidget {
  const ConcurrentsItems({Key? key}) : super(key: key);

  @override
  State<ConcurrentsItems> createState() => _ConcurrentsItemsState();
}

class _ConcurrentsItemsState extends State<ConcurrentsItems> {
  int selectedIndex = -1;

  String addressString(ResearchPricesConcurrentsModel concurrent) {
    String value =
        "${concurrent.Address?.Address}, ${concurrent.Address?.District}, ${concurrent.Address?.City}, ${concurrent.Address?.Number}. \nCEP: ${concurrent.Address?.Zip}";
    if (concurrent.Address?.Complement?.isEmpty == false) {
      value += "\nComplemento: ${concurrent.Address!.Complement!}";
    }
    if (concurrent.Address?.Reference?.isEmpty == false) {
      value += "\nReferência: ${concurrent.Address!.Reference!}";
    }
    return value;
  }

  Widget itemOfList({
    required int index,
    required ResearchPricesProvider researchPricesProvider,
    required AddressProvider addressProvider,
  }) {
    ResearchPricesConcurrentsModel concurrent =
        researchPricesProvider.concurrents[index];
    Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    return Container(
      child: InkWell(
        focusColor: Colors.white.withOpacity(0),
        hoverColor: Colors.white.withOpacity(0),
        splashColor: Colors.white.withOpacity(0),
        highlightColor: Colors.white.withOpacity(0),
        onTap: () async {
          researchPricesProvider.updateSelectedConcurrent(
            concurrent: concurrent,
            addressProvider: addressProvider,
          );
          await researchPricesProvider.associateConcurrentToResearchPrice(
            context: context,
            enterpriseCode: arguments?["enterpriseCode"],
          );

          if (researchPricesProvider.errorAssociateConcurrentToResearch == "") {
            ShowSnackbarMessage.showMessage(
              message: "O concorrente está associado à pesquisa",
              context: context,
              backgroundColor: Theme.of(context).colorScheme.primary,
              secondsDuration: 1,
            );
            Navigator.of(context)
                .pushNamed(APPROUTES.RESEARCH_PRICES_INSERT_PRICE);
          } else {
            ShowSnackbarMessage.showMessage(
              message:
                  researchPricesProvider.errorAssociateConcurrentToResearch,
              context: context,
            );
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TitleAndSubtitle.titleAndSubtitle(
                //   title: "Código da pesquisa",
                //   value: concurrent.ResearchOfPriceCode.toString(),
                // ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Código",
                  subtitle: concurrent.ConcurrentCode.toString(),
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  subtitle: researchPricesProvider.selectedResearch!.Concurrents
                          .contains(concurrent)
                      ? "Associado à pesquisa"
                      : "Não associado à pesquisa",
                  subtitleColor: researchPricesProvider
                          .selectedResearch!.Concurrents
                          .contains(concurrent)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.red,
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Nome",
                  subtitle: concurrent.Name?.isEmpty == false
                      ? concurrent.Name
                      : "Não há",
                ),
                TitleAndSubtitle.titleAndSubtitle(
                  title: "Observação",
                  subtitle: concurrent.Observation?.isNotEmpty == true
                      ? concurrent.Observation
                      : "Não há",
                ),

                TitleAndSubtitle.titleAndSubtitle(
                  title: "Endereços",
                  subtitle: concurrent.Address?.Zip?.isEmpty == true
                      ? "Nenhum informado"
                      : addressString(concurrent),
                ),
                TextButton.icon(
                  onPressed: () {
                    researchPricesProvider.updateSelectedConcurrent(
                      concurrent: concurrent,
                      addressProvider: addressProvider,
                    );
                    Navigator.of(context).pushNamed(
                      APPROUTES.RESERACH_PRICE_INSERT_UPDATE_CONCORRENT,
                      arguments: {
                        "enterpriseCode": arguments?["enterpriseCode"]
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(
                    "Alterar concorrente",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
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
    AddressProvider addressProvider = Provider.of(context, listen: true);
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
                      addressProvider: addressProvider,
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
