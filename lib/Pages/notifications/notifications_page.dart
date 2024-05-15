import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RemoteMessage remoteMessage =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificações"),
      ),
      body: Container(
        height: 100, // Defina a altura desejada aqui
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(remoteMessage.notification!.title!),
                  Text(remoteMessage.notification!.body!),
                ],
              ),
            ),
            Container(
              height: 100,
              width: 100,
              child: Image.network(
                remoteMessage.notification!.android!.imageUrl!,
                // height: double.infinity,
                // width: 100, // Defina a largura desejada aqui
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
