import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class AddEnterpriseButton extends StatelessWidget {
  final bool isAddingNewCnpj;
  const AddEnterpriseButton({
    super.key,
    this.isAddingNewCnpj = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(
        Icons.add,
        color: isAddingNewCnpj
            ? Theme.of(context).colorScheme.primary
            : Colors.white,
      ),
      label: Text(isAddingNewCnpj ? "Adicionar CNPJ" : ""),
      iconAlignment: IconAlignment.end,
      onPressed: () async {
        Navigator.of(context).pushNamed(APPROUTES.ADD_UPDATE_SUB_ENTERPRISE);
      },
    );
  }
}
