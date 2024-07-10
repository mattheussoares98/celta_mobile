import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../components/Global_widgets/global_widgets.dart';
import '../../../../../models/firebase/firebase.dart';
import '../../../../providers/providers.dart';

class EditUrlCcs extends StatefulWidget {
  final FirebaseEnterpriseModel client;
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

  void _updateUrlCcs(WebProvider webProvider) {
    ShowAlertDialog.showAlertDialog(
      context: context,
      title: "Deseja realmente alterar a URL?",
      subtitle: "Nova URL: \n${urlCcsController.text}",
      function: () async {
        if (!urlCcsController.text.toLowerCase().contains("http") ||
            !urlCcsController.text.contains(":") ||
            !urlCcsController.text.contains("//") ||
            !urlCcsController.text.contains("\.") ||
            !urlCcsController.text.toLowerCase().contains("ccs")) {
          ShowSnackbarMessage.showMessage(
              message:
                  "Viiixi, acho que essa URL tá errada hein... confirma aew",
              context: context);
          return;
        }
        await webProvider.updateEnterpriseCcs(
          context: context,
          enterpriseId: widget.client.id!,
          newUrlCcs: urlCcsController.text,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

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
                    onFieldSubmitted: (_) {
                      _updateUrlCcs(webProvider);
                    },
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    _updateUrlCcs(webProvider);
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
