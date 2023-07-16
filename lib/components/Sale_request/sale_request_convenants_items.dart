import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/sale_request_models/sale_request_convenant_model.dart';

class SaleRequestConvenantsItems extends StatefulWidget {
  final List<SaleRequestConvenantsModel> convenants;
  final int indexOfCustomer;
  final String enterpriseCode;
  const SaleRequestConvenantsItems({
    required this.convenants,
    required this.indexOfCustomer,
    required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestConvenantsItems> createState() =>
      _SaleRequestConvenantsItemsState();
}

class _SaleRequestConvenantsItemsState
    extends State<SaleRequestConvenantsItems> {
  int? _selectedIndex;
  bool _selectedAutomaticConvenant = false;
  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Divider(
            height: 4,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        FittedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.convenants.length == 0
                  ? "Não há convênios para esse cliente"
                  : "Convênios",
              style: TextStyle(
                fontFamily: "BebasNeue",
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: widget.convenants.length == 0
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
                fontSize: 25,
              ),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.convenants.length,
          itemBuilder: (context, index) {
            if (widget.convenants[index].selected) {
              _selectedIndex = index;
            }
            if (widget.convenants.length == 1 && !_selectedAutomaticConvenant) {
              _selectedIndex = index;
              _selectedAutomaticConvenant = true;
              saleRequestProvider.updateSelectedConvenant(
                enterpriseCode: widget.enterpriseCode,
                indexOfCustomer: widget.indexOfCustomer,
                indexOfConvenants: index,
                isSelected: _selectedIndex == index,
              );
            }
            return InkWell(
              onTap: () {
                saleRequestProvider.updateSelectedConvenant(
                  enterpriseCode: widget.enterpriseCode,
                  indexOfCustomer: widget.indexOfCustomer,
                  indexOfConvenants: index,
                  isSelected: _selectedIndex == index,
                );
                if (_selectedIndex != index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                } else {
                  setState(() {
                    _selectedIndex = null;
                  });
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: _selectedIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black12,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 0,
                color: const Color.fromARGB(255, 242, 241, 241),
                child: ListTile(
                  title: Text(
                    widget.convenants[index].name,
                    style: TextStyle(
                        color: _selectedIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    focusColor: Colors.red,
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: index,
                    groupValue: _selectedIndex,
                    toggleable: true,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedIndex = value;
                      });
                      saleRequestProvider.updateSelectedConvenant(
                        enterpriseCode: widget.enterpriseCode,
                        indexOfCustomer: widget.indexOfCustomer,
                        indexOfConvenants: index,
                        isSelected: _selectedIndex == index,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
