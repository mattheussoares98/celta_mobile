import 'package:celta_inventario/api/api.dart';
import 'package:flutter/material.dart';

import '../../models/notifications/notifications.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoadingLocalNotifications = false;
  List<NotificationsModel> notifications = [];

  Future<List<NotificationsModel>> _getNotificationsModel() async {
    return await PrefsInstance.getNotifications();
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_isLoaded) {
      setState(() {
        _isLoadingLocalNotifications = true;
      });
      notifications = await _getNotificationsModel();
      setState(() {
        _isLoadingLocalNotifications = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notificações"),
        ),
        body: _isLoadingLocalNotifications
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                reverse: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 0.3,
                      ),
                    ),
                    shadowColor: Colors.black,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if (notification.title != null)
                            Text(
                              notification.title! +
                                  "um pouco grande pra ver como fica aqui",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (notification.subtitle != null)
                                Expanded(child: Text(notification.subtitle!)),
                              if (notification.imageUrl != null)
                                Container(
                                  height: 100,
                                  width: 150,
                                  child: Image.network(
                                    notification.imageUrl!,
                                    // height: double.infinity,
                                    width:
                                        150, // Defina a largura desejada aqui
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
