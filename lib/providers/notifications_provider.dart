import 'package:flutter/material.dart';

import '../api/api.dart';
import '../models/notifications/notifications.dart';

class NotificationsProvider with ChangeNotifier {
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<NotificationsModel> _notifications = [];
  List<NotificationsModel> get notifications => [..._notifications];
  int get notificationsLength => notifications.length;

  bool _hasUnreadNotifications = false;
  bool get hasUnreadNotifications => _hasUnreadNotifications;
  void setHasUnreadNotifications({
    required bool newValue,
    required bool notify,
  }) {
    _hasUnreadNotifications = newValue;
    PrefsInstance.setHasUnreadNotifications(newValue);
    if (notify) {
      notifyListeners();
    }
  }
}
