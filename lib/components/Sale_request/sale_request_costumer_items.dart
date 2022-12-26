import 'package:celta_inventario/Components/Global_widgets/personalized_card.dart';
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
  TextStyle _fontStyle({Color? color = Colors.black}) => TextStyle(
        fontSize: 17,
        color: color,
        fontFamily: 'OpenSans',
      );
  TextStyle _fontBoldStyle({Color? color = Colors.black}) => TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: color,
      );

  Widget values({
    Color? titleColor,
    Color? subtitleColor,
    Widget? otherWidget,
    String? title,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          title == null ? "" : "${title}: ",
          style: _fontStyle(color: titleColor),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: _fontBoldStyle(color: subtitleColor),
            maxLines: 2,
          ),
        ),
        if (otherWidget != null) otherWidget,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: true,
    );
    var costumer =
        saleRequestProvider.costumers(widget.enterpriseCode.toString());

    return Expanded(
      child: Column(
        mainAxisAlignment: costumer.length > 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: costumer.length,
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
                          values(
                            title: "Código",
                            value: costumer[index].Code.toString(),
                          ),
                          values(
                            title: "Nome",
                            value: costumer[index].Name.toString(),
                          ),
                          if (costumer[index].ReducedName != "")
                            values(
                              title: "Nome reduzido",
                              value: costumer[index].ReducedName.toString(),
                            ),
                          values(
                            title: "CPF/CNPJ",
                            value: costumer[index].CpfCnpjNumber,
                          ),
                          values(
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
