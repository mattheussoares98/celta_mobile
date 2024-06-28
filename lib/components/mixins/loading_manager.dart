import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../global_widgets/global_widgets.dart';

mixin LoadingManager {
  handleLoading(BuildContext context, bool isLoading) {
    if (isLoading == true) {
      showLoading(NavigatorKey.navigatorKey.currentState?.context ?? context);
    } else {
      hideLoading(NavigatorKey.navigatorKey.currentState?.context ?? context);
    }
  }
}
