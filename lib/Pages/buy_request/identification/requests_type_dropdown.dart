import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/global_widgets/global_widgets.dart';
import '../../../models/buy_request/buy_request.dart';
import '../../../providers/providers.dart';
import 'identification.dart';

class RequestsTypeDropdown extends StatefulWidget {
  final GlobalKey<FormFieldState> requestsKey;
  final bool enabledChangeRequestsType;
  final bool showRefreshIcon;

  const RequestsTypeDropdown({
    required this.requestsKey,
    this.enabledChangeRequestsType = true,
    this.showRefreshIcon = true,
    Key? key,
  }) : super(key: key);

  @override
  State<RequestsTypeDropdown> createState() =>
      _RequestsTypeDropdownState();
}

class _RequestsTypeDropdownState
    extends State<RequestsTypeDropdown> {
  String? previousValue;
  String? atualValue;

  void onChange({
    required BuyRequestProvider buyRequestProvider,
    required dynamic value,
  }) {
    if (value == atualValue) {
      return;
    }

    BuyRequestRequestsTypeModel selectedRequestModel = buyRequestProvider
        .requestsType
        .firstWhere((element) => element.Name == value);

    widget.requestsKey.currentState?.reset();
    setState(() {
      atualValue = previousValue;
    });

    if (buyRequestProvider.enterprisesCount > 0 ||
        buyRequestProvider.productsInCartCount > 0) {
      ShowAlertDialog.showAlertDialog(
        context: context,
        title: "Alterar valor",
        subtitle:
            "Se você alterar o modelo de pedido, todas empresas e produtos serão removidos do pedido.\n\nDeseja realmente alterar o modelo de pedido?",
        function: () {
          widget.requestsKey.currentState?.reset();

          setState(() {
            atualValue = value;
          });

          buyRequestProvider.selectedRequestModel = selectedRequestModel;
        },
      );
    } else {
      setState(() {
        atualValue = value;
      });
      buyRequestProvider.selectedRequestModel = selectedRequestModel;
    }

    if (atualValue != buyRequestProvider.selectedRequestModel?.Name) {
      atualValue = buyRequestProvider.selectedRequestModel?.Name;
    }
  }

  Future<void> getRequestsType(BuyRequestProvider buyRequestProvider) async {
    widget.requestsKey.currentState?.reset();

    if (buyRequestProvider.enterprisesCount > 0 ||
        buyRequestProvider.productsInCartCount > 0) {
      ShowAlertDialog.showAlertDialog(
        context: context,
        title: "Consultar modelos",
        subtitle:
            "Se você consultar os modelos, todas empresas e produtos serão removidos do pedido.\n\nDeseja realmente alterar o modelo de pedido?",
        function: () async {
          await buyRequestProvider.getRequestsType(
            context: context,
            isSearchingAgain: true,
          );
        },
      );
    } else {
      await buyRequestProvider.getRequestsType(
        context: context,
        isSearchingAgain: true,
      );
    }

    atualValue = null;
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: true);
    atualValue = buyRequestProvider.selectedRequestModel?.Name;

    return Row(
      children: [
        Expanded(
          child: Card(
            shape: const RoundedRectangleBorder(),
            child: PersonalizedDropdownFormfield(
              onChanged: widget.enabledChangeRequestsType == false
                  ? null
                  : (value) {
                      onChange(
                        buyRequestProvider: buyRequestProvider,
                        value: value,
                      );
                    },
              value: atualValue,
              dropdownKey: widget.requestsKey,
              isLoading: buyRequestProvider.isLoadingRequestsType,
              disabledHintText: "Modelo de pedido",
              isLoadingMessage: "Consultando modelos",
              validator: (value) {
                if (value == null) {
                  return "Selecione o modelo de pedido";
                }

                return null;
              },
              items: buyRequestProvider.requestsType
                  .map(
                    (value) => DropdownMenuItem(
                      value: value.Name,
                      alignment: Alignment.center,
                      onTap: () {
                        // buyRequestProvider.selectedRequestModel = value;
                      },
                      child: FittedBox(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                value.Name.toString(),
                              ),
                            ),
                            const Divider(
                              height: 4,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        if (widget.showRefreshIcon)
          IconButton(
            onPressed: buyRequestProvider.isLoadingRequestsType
                ? null
                : () async {
                    await getRequestsType(buyRequestProvider);
                  },
            tooltip: "Pesquisar modelos de pedido novamente",
            icon: Icon(
              Icons.refresh,
              color: buyRequestProvider.isLoadingRequestsType
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }
}
