import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';

class EnterpriseField extends StatelessWidget {
  final Animation<double> animationWidth;
  final TextEditingController enterpriseNameController;
  final Future<void> Function() doLogin;
  final FocusNode urlFocusNode;
  const EnterpriseField({
    required this.animationWidth,
    required this.enterpriseNameController,
    required this.doLogin,
    required this.urlFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context);

    return SizedBox(
      width: animationWidth.value,
      child: TextFormField(
        onChanged: (value) {
          loginProvider.changedEnterpriseNameOrUrlCcs = true;
        },
        enabled: loginProvider.isLoading ? false : true,
        controller: enterpriseNameController,
        onFieldSubmitted: (_) async {
          await doLogin();
        },
        focusNode: urlFocusNode,
        style: FormFieldStyle.style(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Digite o nome da empresa!';
          } else if (ConvertString.isUrl(value)) {
            return 'Login pelo CCS desabilitado!';
          }

          return null;
        },
        decoration: FormFieldDecoration.decoration(
          context: context,
          labelText: "Nome da empresa",
        ),
      ),
    );
  }
}
