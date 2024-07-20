import '../../../models/sale_request/sale_request.dart';
import '../../../providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import 'insert_customer.dart';

class CustomersItems extends StatefulWidget {
  final int enterpriseCode;
  const CustomersItems({
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomersItems> createState() => _CustomersItemsState();
}

class _CustomersItemsState extends State<CustomersItems> {
  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: true,
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: saleRequestProvider
          .customers[widget.enterpriseCode.toString()]?.length,
      itemBuilder: (context, index) {
        SaleRequestCustomerModel customer = saleRequestProvider
            .customers[widget.enterpriseCode.toString()]![index];
        if (customer.Code == 1) {
          return Card(
            child: CheckboxListTile(
                activeColor: Theme.of(context).colorScheme.primary,
                title: const Text("Cliente consumidor"),
                value: customer.selected,
                onChanged: saleRequestProvider.isLoadingCustomer
                    ? null
                    : (bool? value) {
                        setState(() {
                          saleRequestProvider.updateSelectedCustomer(
                            index: index,
                            value: value!,
                            enterpriseCode:
                                widget.enterpriseCode.toString(),
                          );
                        });
                      }),
          );
        }
        
        return Card(
          child: Column(
            children: [
              CheckboxListTile(
                value: customer.selected,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: saleRequestProvider.isLoadingCustomer
                    ? null
                    : (value) {
                        setState(() {
                          saleRequestProvider.updateSelectedCustomer(
                            index: index,
                            value: value!,
                            enterpriseCode:
                                widget.enterpriseCode.toString(),
                          );
                        });
                      },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Código",
                      subtitle: customer.Code.toString(),
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Nome",
                      subtitle: customer.Name.toString(),
                    ),
                    if (customer.ReducedName != "")
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Nome reduzido",
                        subtitle: customer.ReducedName.toString(),
                      ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "CPF/CNPJ",
                      subtitle: customer.CpfCnpjNumber,
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Código personalizado",
                      subtitle: customer.PersonalizedCode.toString(),
                    ),
                  ],
                ),
              ),
              if (customer.selected)
                CovenantsItems(
                  covenants: customer.Covenants,
                  indexOfCustomer: index,
                  enterpriseCode: widget.enterpriseCode.toString(),
                ),
            ],
          ),
        );
      },
    );
  }
}
