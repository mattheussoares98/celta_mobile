import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../global_widgets/global_widgets.dart';

mixin LoadingManager {
  void handleLoading(BuildContext context, bool isLoading) {
    if (isLoading == true) {
      showLoading(NavigatorKey.navigatorKey.currentState?.context ?? context);
    } else if (ModalRoute.of(context)?.isCurrent != true) {
        hideLoading(NavigatorKey.navigatorKey.currentState?.context ?? context);
    }
  }
}
