import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomerRegisterPage extends StatefulWidget {
  const CustomerRegisterPage({Key? key}) : super(key: key);

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reducedNameController = TextEditingController();

  String dateOfBirth = "";

  @override
  void dispose() {
    super.dispose();
    _cpfCnpjController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //fazer algo que quiser quando o usuário clicar no botão de voltar
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'CADASTRO DE CLIENTES',
          ),
          leading: IconButton(
            onPressed: () {
              //fazer algo que quiser quando o usuário clicar no botão de voltar
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              enabled: true,
              controller: _cpfCnpjController,
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(11)],
              // focusNode: _userFocusNode,
              // onFieldSubmitted: (_) =>
              //     FocusScope.of(context).requestFocus(_passwordFocusNode),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'CPF';
                }
                return null;
              },
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'OpenSans',
                decorationColor: Colors.black,
                color: Colors.black,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                labelStyle: const TextStyle(
                  color: Colors.grey,
                ),
                labelText: 'CPF',
                counterStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextFormField(
              enabled: true,
              controller: _nameController,
              // focusNode: _userFocusNode,
              // onFieldSubmitted: (_) =>
              //     FocusScope.of(context).requestFocus(_passwordFocusNode),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nome é obrigatório!';
                }
                return null;
              },
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'OpenSans',
                decorationColor: Colors.black,
                color: Colors.black,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                labelStyle: const TextStyle(
                  color: Colors.grey,
                ),
                labelText: 'Nome',
                counterStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextFormField(
              enabled: true,
              controller: _reducedNameController,
              // focusNode: _userFocusNode,
              // onFieldSubmitted: (_) =>
              //     FocusScope.of(context).requestFocus(_passwordFocusNode),
              validator: (value) {
                return null;
              },
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'OpenSans',
                decorationColor: Colors.black,
                color: Colors.black,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                labelStyle: const TextStyle(
                  color: Colors.grey,
                ),
                labelText: 'Nome reduzido',
                counterStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Data de nascimento: ${dateOfBirth == "" ? "nenhuma" : "$dateOfBirth"}"),
                TextButton(
                  onPressed: () async {
                    DateTime? validityDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 3650),
                      ),
                    );

                    if (validityDate != null) {
                      setState(() {
                        dateOfBirth =
                            DateFormat('dd/MM/yyyy').format(validityDate);
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Text(dateOfBirth == "" ? "Incluir" : "Alterar"),
                      const Icon(Icons.calendar_month)
                    ],
                  ),
                )
              ],
            ),
            DropdownButtonFormField<dynamic>(
              // disabledHint: transferBetweenPackageProvider
              //         .isLoadingTypeStockAndJustifications
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           const FittedBox(
              //             child: Text(
              //               "Consultando",
              //               textAlign: TextAlign.center,
              //               style: const TextStyle(
              //                 fontSize: 60,
              //               ),
              //             ),
              //           ),
              //           const SizedBox(width: 15),
              //           Container(
              //             height: 15,
              //             width: 15,
              //             child: const CircularProgressIndicator(),
              //           ),
              //         ],
              //       )
              //     : const Center(child: Text("Justificativas")),
              isExpanded: true,
              hint: Center(
                child: Text(
                  'Sexo',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              validator: (value) {
                // if (value == null) {
                //   return 'Selecione uma justificativa!';
                // }
                return null;
              },
              onChanged:
                  // transferBetweenPackageProvider
                  //             .isLoadingTypeStockAndJustifications ||
                  //         transferBetweenPackageProvider.isLoadingAdjustStock ||
                  //         transferBetweenPackageProvider.isLoadingProducts ||
                  //         transferBetweenPackageProvider.products.isEmpty
                  //     ? null
                  //     :
                  (value) {
                print(value);
              },
              items: ["Masculino", "Feminino"]
                  .map(
                    (value) => DropdownMenuItem(
                      alignment: Alignment.center,
                      onTap: () {},
                      value: value,
                      child: FittedBox(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                value,
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
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && dateOfBirth != "") {
                  print("Válido");
                } else {
                  print("Inválido");
                }
              },
              child: const Text("Cadastrar"),
            ),
          ]),
        ),
      ),
    );
  }
}
