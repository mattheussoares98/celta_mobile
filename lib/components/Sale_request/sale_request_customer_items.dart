import 'package:celta_inventario/Components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_customer_model.dart';
import 'package:celta_inventario/components/Sale_request/sale_request_covenants_items.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestCustomersItems extends StatefulWidget {
  final int enterpriseCode;
  const SaleRequestCustomersItems({
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestCustomersItems> createState() =>
      _SaleRequestCustomersItemsState();
}

class _SaleRequestCustomersItemsState extends State<SaleRequestCustomersItems> {
  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: true,
    );

    return Expanded(
      child: Column(
        mainAxisAlignment: saleRequestProvider
                    .customers[widget.enterpriseCode.toString()]!.length >
                1
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: saleRequestProvider
                  .customers[widget.enterpriseCode.toString()]?.length,
              itemBuilder: (context, index) {
                SaleRequestCustomerModel customer = saleRequestProvider
                    .customers[widget.enterpriseCode.toString()]![index];
                if (customer.Code == 1) {
                  return PersonalizedCard.personalizedCard(
                    context: context,
                    child: CheckboxListTile(
                        activeColor: Theme.of(context).colorScheme.primary,
                        title: const Text("Cliente consumidor"),
                        value: customer.selected,
                        onChanged: (bool? value) {
                          setState(() {
                            saleRequestProvider.updateSelectedCustomer(
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
                  child: Column(
                    children: [
                      CheckboxListTile(
                        value: customer.selected,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (value) {
                          setState(() {
                            saleRequestProvider.updateSelectedCustomer(
                              index: index,
                              value: value!,
                              enterpriseCode: widget.enterpriseCode.toString(),
                            );
                          });
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Código",
                              value: customer.Code.toString(),
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Nome",
                              value: customer.Name.toString(),
                            ),
                            if (customer.ReducedName != "")
                              TitleAndSubtitle.titleAndSubtitle(
                                title: "Nome reduzido",
                                value: customer.ReducedName.toString(),
                              ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "CPF/CNPJ",
                              value: customer.CpfCnpjNumber,
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Código personalizado",
                              value: customer.PersonalizedCode.toString(),
                            ),
                          ],
                        ),
                      ),
                      if (customer.selected)
                        SaleRequestCovenantsItems(
                          covenants: customer.Covenants,
                          indexOfCustomer: index,
                          enterpriseCode: widget.enterpriseCode.toString(),
                        ),
                    ],
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
