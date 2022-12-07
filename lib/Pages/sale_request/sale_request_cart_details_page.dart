import 'package:celta_inventario/Components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestCartDetailsPage extends StatefulWidget {
  const SaleRequestCartDetailsPage({Key? key}) : super(key: key);

  @override
  State<SaleRequestCartDetailsPage> createState() =>
      _SaleRequestCartDetailsPageState();
}

final GlobalKey<FormFieldState> _formKey = GlobalKey();
final TextEditingController searchCostumerController = TextEditingController();
final FocusNode searchCostumerFocusNode = FocusNode();

class _SaleRequestCartDetailsPageState
    extends State<SaleRequestCartDetailsPage> {
  bool _useDefaultCostumer = false;
  String _selectedCostumer = "";

  Widget titleAndSubtitle({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(255, 100, 97, 97),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos do carrinho"),
      ),
      body: Column(
        children: [
          SearchWidget(
            consultProductController: searchCostumerController,
            isLoading: saleRequestProvider.isLoadingCostumer,
            onPressSearch: () async {
              await saleRequestProvider.getCostumers(
                context: context,
                searchValueControllerText: searchCostumerController.text,
              );
            },
            focusNodeConsultProduct: searchCostumerFocusNode,
            hintText: "Código, nome ou CPF",
            labelText: "Consultar cliente",
            useCamera: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Card(
              elevation: 5,
              shape: Border.all(
                color: const Color.fromARGB(255, 214, 214, 214),
              ),
              child: CheckboxListTile(
                  activeColor: Colors.black,
                  title: const Text("Cliente consumidor"),
                  value: _useDefaultCostumer,
                  onChanged: (bool? value) {
                    setState(() {
                      _useDefaultCostumer = value!;
                    });
                    if (_useDefaultCostumer) {
                      _selectedCostumer = "1-Consumidor";
                    }
                  }),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: saleRequestProvider.cartProducts.length,
                    itemBuilder: (context, index) {
                      var product = saleRequestProvider.cartProducts[index];

                      return PersonalizedCard.personalizedCard(
                        context: context,
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: FittedBox(
                                            child: Text(
                                              (index + 1).toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                    offset: Offset(0, 0),
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product["Name"] +
                                                  " (${product["PackingQuantity"]})",
                                              style: const TextStyle(
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 25,
                                                fontFamily: 'BebasNeue',
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    titleAndSubtitle(
                                                      title: "Qtd",
                                                      subtitle:
                                                          product["Quantity"]
                                                              .toStringAsFixed(
                                                                  3)
                                                              .replaceAll(
                                                                  RegExp(r'\.'),
                                                                  ','),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    titleAndSubtitle(
                                                      title: "Preço",
                                                      subtitle: ConvertString
                                                          .convertToBRL(
                                                        product["Value"]
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    titleAndSubtitle(
                                                      title: "Total",
                                                      subtitle: ConvertString
                                                          .convertToBRL(
                                                        "${(product["Quantity"] * product["Value"])} ",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.edit,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
          ),
          if (MediaQuery.of(context).viewInsets.bottom ==
              0) //só exibe o botão se o teclado estiver fechado
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                maximumSize: const Size(double.infinity, 50),
                shape: const RoundedRectangleBorder(),
                // primary: Colors.red,
              ),
              onPressed: () {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text("Itens"),
                      Text(
                        saleRequestProvider.cartProducts.length.toString(),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Total"),
                      Text(
                        ConvertString.convertToBRL(
                          saleRequestProvider.totalCartPrice,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "SALVAR PEDIDO",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 242, 0),
                      fontSize: 17,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 2.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
