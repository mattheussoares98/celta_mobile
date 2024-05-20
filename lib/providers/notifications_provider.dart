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

  Future<void> getLocalNotifications() async {
    try {
      _hasUnreadNotifications = await PrefsInstance.getHasUnreadNotifications();
      _notifications = await PrefsInstance.getNotifications();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> clearAllNotifications() async {
    try {
      await PrefsInstance.clearAllNotifications();
      _notifications.clear();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> addNewNotification(NotificationsModel newNotification) async {
    try {
      _notifications.add(newNotification);
      setHasUnreadNotifications(newValue: true, notify: true);
    } catch (e) {}
  }
}
