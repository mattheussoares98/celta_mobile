import 'package:flutter/material.dart';

import '../../../../../components/Global_widgets/global_widgets.dart';
import '../../../../../models/firebase/firebase.dart';

class EditUrlCcs extends StatefulWidget {
  final FirebaseClientModel client;
  const EditUrlCcs({
    required this.client,
    super.key,
  });

  @override
  State<EditUrlCcs> createState() => _EditUrlCcsState();
}

class _EditUrlCcsState extends State<EditUrlCcs> {
  bool showFormField = false;
  final urlCcsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    urlCcsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 8,
                child: Text("URL CCS\n${widget.client.urlCCS}"),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    urlCcsController.text = widget.client.urlCCS;
                    setState(() {
                      showFormField = !showFormField;
                    });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            ],
          ),
          Visibility(
            visible: showFormField,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: urlCcsController,
                    decoration: FormFieldHelper.decoration(
                      isLoading: false,
                      context: context,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    ShowAlertDialog.showAlertDialog(
                      context: context,
                      title: "Deseja realmente alterar a URL?",
                      subtitle: "Nova URL: \n${urlCcsController.text}",
                      function: () async {
                        try {} catch (e) {
                          e;
                        }
                      },
                    );
                  },
                  child: const Text("Alterar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
