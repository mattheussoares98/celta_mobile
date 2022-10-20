import 'package:celta_inventario/procedures/receipt_prodecure/products_conference_page/conference_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConferenceConsultProduct extends StatefulWidget {
  final ConferenceProvider conferenceProvider;
  const ConferenceConsultProduct(
    this.conferenceProvider, {
    Key? key,
  }) : super(key: key);

  @override
  State<ConferenceConsultProduct> createState() =>
      _ConferenceConsultProductState();
}

class _ConferenceConsultProductState extends State<ConferenceConsultProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _consultedProductController =
      TextEditingController();

  // final _consultedProductFocusNode = FocusNode();

  // @override
  // void dispose() {
  //   super.dispose();
  //   _consultedProductFocusNode.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // TextEditingController textEditingController =
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 4,
        right: 0,
        bottom: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                enabled: widget.conferenceProvider.isLoading ? false : true,
                autofocus: true,
                controller: _consultedProductController,
                // focusNode: _consultedProductFocusNode,
                // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                onChanged: (value) {
                  if (value.isEmpty || value == '-') {
                    value = '0';
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Digite O PLU, EAN ou nome para pesquisar';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Consultar PLU, EAN ou nome',
                  errorStyle: const TextStyle(
                    fontSize: 17,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.photo_camera),
          )
        ],
      ),
    );
  }
}
