import 'package:celta_inventario/Components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestCostumersItems extends StatefulWidget {
  final int enterpriseCode;
  const SaleRequestCostumersItems({
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestCostumersItems> createState() =>
      _SaleRequestCostumersItemsState();
}

class _SaleRequestCostumersItemsState extends State<SaleRequestCostumersItems> {
  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: true,
    );
    var costumer =
        saleRequestProvider.costumers(widget.enterpriseCode.toString());

    int costumersCount =
        saleRequestProvider.costumersCount(widget.enterpriseCode.toString());

    return Expanded(
      child: Column(
        mainAxisAlignment: costumersCount > 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: costumersCount,
              itemBuilder: (context, index) {
                if (costumer[index].Code == 1) {
                  return PersonalizedCard.personalizedCard(
                    context: context,
                    child: CheckboxListTile(
                        activeColor: Theme.of(context).colorScheme.primary,
                        title: const Text("Cliente consumidor"),
                        value: costumer[index].selected,
                        onChanged: (bool? value) {
                          setState(() {
                            saleRequestProvider.updateSelectedCostumer(
                              index: index,
                              value: value!,
                              enterpriseCode: widget.enterpriseCode.toString(),
                            );
                          });
                        }),
                  );
                }

                return PersonalizedCard.personalizedCard(
                  context: context,
                  child: CheckboxListTile(
                    value: costumer[index].selected,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) {
                      setState(() {
                        saleRequestProvider.updateSelectedCostumer(
                          index: index,
                          value: value!,
                          enterpriseCode: widget.enterpriseCode.toString(),
                        );
                      });
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Código",
                            value: costumer[index].Code.toString(),
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Nome",
                            value: costumer[index].Name.toString(),
                          ),
                          if (costumer[index].ReducedName != "")
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Nome reduzido",
                              value: costumer[index].ReducedName.toString(),
                            ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "CPF/CNPJ",
                            value: costumer[index].CpfCnpjNumber,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Código personalizado",
                            value: costumer[index].PersonalizedCode.toString(),
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
      ),
    );
  }
}
