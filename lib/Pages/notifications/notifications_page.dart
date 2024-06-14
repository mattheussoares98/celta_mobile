import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../providers/providers.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      _isLoaded = true;
      NotificationsProvider notificationsProvider =
          Provider.of(context, listen: false);
      notificationsProvider.setHasUnreadNotifications(
          newValue: false, notify: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    NotificationsProvider notificationsProvider = Provider.of(context);

    return PopScope(
      onPopInvoked: (_) {
        notificationsProvider.setHasUnreadNotifications(
            newValue: false, notify: true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notificações"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 35,
                width: 35,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    child: Text(
                      notificationsProvider.notificationsLength.toString(),
                      style: const TextStyle(
                          // color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: notificationsProvider.notifications.length,
          itemBuilder: (context, index) {
            if (notificationsProvider.notifications.isEmpty) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: Text(
                    "Não há notificações",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 17,
                    ),
                  ),
                ),
              );
            }

            final notification =
                notificationsProvider.notifications.reversed.toList()[index];

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
                        notification.title!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (notification.subtitle != null)
                      Text(notification.subtitle!),
                    if (notification.urlToLaunch != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                await UrlLauncher.searchAndLaunchUrl(
                                  url: notification.urlToLaunch!,
                                  context: context,
                                );
                              },
                              child: const Text("Ir para o site"),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(
                                      text: notification.urlToLaunch!),
                                );
                              },
                              child: const Text("Copiar URL"),
                            ),
                          ),
                        ],
                      ),
                    if (notification.imageUrl != null)
                      Container(
                        width: double.infinity,
                        child: Image.network(
                          notification.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
