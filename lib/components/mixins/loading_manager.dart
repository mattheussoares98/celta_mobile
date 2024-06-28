import 'package:flutter/material.dart';

import '../global_widgets/global_widgets.dart';

mixin LoadingManager {
  void handleLoading(BuildContext context, bool isLoading) {
    if (isLoading == true) {
      showLoading(context);
    } else if (ModalRoute.of(context) != null &&
        ModalRoute.of(context)?.isCurrent != true) {
      hideLoading(context);
    }
  }
}
