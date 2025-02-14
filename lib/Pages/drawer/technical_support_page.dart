import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/api.dart';
import '../../components/components.dart';

class TechnicalSupportPage extends StatelessWidget {
  const TechnicalSupportPage({Key? key}) : super(key: key);

  String _getCurrentDate() {
    DateTime now = DateTime.now();

    var formatter = DateFormat('HH:mm');
    String formattedTime = formatter.format(now);

    return formattedTime;
  }

  bool _isBusinessTime() {
    DateTime dateTime = DateTime.now();

    if (dateTime.weekday >= DateTime.monday &&
        dateTime.weekday <= DateTime.friday) {
      if (dateTime.hour >= 8 && dateTime.hour < 17) {
        return true;
      }
    }
    return false;
  }

  Widget personalizedButton({
    required BuildContext context,
    required String messageCenterButton,
    required FirebaseCallEnum firebaseCallEnum,
    String? messageLeftButton,
    required String urlBusinessTime,
    required String childTitle,
    String? urlOutsideBusinessTime,
    String? businessHours,
    String? businessDays,
  }) {
    bool isBusinessTime = _isBusinessTime();
    String currentDate = _getCurrentDate();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    childTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      fontFamily: "BebasNeue",
                    ),
                  ),
                  const Icon(Icons.call, color: Colors.green),
                ],
              ),
            ),
            if (businessDays != null && businessHours != null)
              Column(
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    subtitle: "Horário de funcionamento comercial",
                    subtitleColor: Theme.of(context).colorScheme.primary,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Dias",
                    subtitle: businessDays,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Horários",
                    subtitle: businessHours,
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: messageLeftButton != null
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
              children: [
                if (messageLeftButton != null && urlOutsideBusinessTime != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isBusinessTime) {
                          ShowAlertDialog.show(
                            context: context,
                            title: "Enviar mensagem no plantão?",
                            content: SingleChildScrollView(
                              child: Text(
                                "O PLANTÃO DEVE SER ACIONADO SOMENTE EM CASOS DE URGÊNCIA!\n\n" +
                                    "Ainda está em horário comercial. Só entre em contato com o plantão se hoje for feriado\n\n" +
                                    "Horário atual: $currentDate\n\n" +
                                    "Hoje é feriado?",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            subtitleSize: 15,
                            function: () async => {
                              await UrlLauncher.searchAndLaunchUrl(
                                url: urlOutsideBusinessTime,
                                context: context,
                              ),
                            },
                          );
                        } else {
                          await UrlLauncher.searchAndLaunchUrl(
                            url: urlOutsideBusinessTime,
                            context: context,
                          );
                        }
                        FirebaseHelper.addClickedInLink(firebaseCallEnum);
                      },
                      child: FittedBox(child: Text(messageLeftButton)),
                    ),
                  ),
                if (messageLeftButton != null) const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!isBusinessTime && urlOutsideBusinessTime != null) {
                        ShowAlertDialog.show(
                          showCloseAlertDialogButton: true,
                          showConfirmAndCancelMessage: false,
                          context: context,
                          title: "Fora do horário comercial",
                          content: SingleChildScrollView(
                            child: Text(
                              "Você está fora do horário comercial\n\nEntre em contato com o plantão\n\n" +
                                  "Horário atual: $currentDate\n\n",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          subtitleSize: 15,
                          function: () {},
                        );
                      } else {
                        await UrlLauncher.searchAndLaunchUrl(
                          url: urlBusinessTime,
                          context: context,
                        );
                      }
                      FirebaseHelper.addClickedInLink(firebaseCallEnum);
                    },
                    child: FittedBox(child: Text(messageCenterButton)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrar em contato"),
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            personalizedButton(
              childTitle: "Ligar na Celta",
              messageCenterButton: "Ligar",
              context: context,
              urlBusinessTime: "tel:+55-11-3125-6767",
              firebaseCallEnum: FirebaseCallEnum.callToCeltaNumber,
            ),
            personalizedButton(
              firebaseCallEnum: FirebaseCallEnum.pdvWhats,
              childTitle: "Whats suporte PDV",
              businessDays: "Segunda à sexta, exceto feriados",
              businessHours: "08:00 às 17:00",
              messageLeftButton: "Whats plantão",
              messageCenterButton: "Whats comercial",
              context: context,
              urlBusinessTime:
                  "https://wa.me/+551131256769/?text=Olá, preciso de ajuda no PDV com a seguinte situação: \n",
              urlOutsideBusinessTime:
                  "https://wa.me/+5511992799313/?text=Olá, estou com a seguinte urgência no PDV: \n",
            ),
            personalizedButton(
              firebaseCallEnum: FirebaseCallEnum.bsWhats,
              businessDays: "Segunda à sexta, exceto feriados",
              businessHours: "08:00 às 17:00",
              childTitle: "Whats suporte BS",
              messageLeftButton: "Whats plantão",
              messageCenterButton: "Whats comercial",
              context: context,
              urlBusinessTime:
                  "https://wa.me/+551131256762/?text=Olá, preciso de ajuda no BS com a seguinte situação: \n",
              urlOutsideBusinessTime:
                  "https://wa.me/+5511992820929/?text=Olá, estou com a seguinte urgência no BS: \n",
            ),
            personalizedButton(
              firebaseCallEnum: FirebaseCallEnum.infrastructureWhats,
              childTitle: "Whats suporte Infraestrutura",
              messageCenterButton: "Enviar mensagem no whats",
              context: context,
              urlBusinessTime:
                  "https://wa.me/+5511992784383/?text=Olá, preciso de ajuda com infraestrutura referente a seguinte situação: \n",
            ),
            personalizedButton(
              firebaseCallEnum: FirebaseCallEnum.administrativeWhats,
              childTitle: "Whats administrativo",
              messageCenterButton: "Enviar mensagem no whats",
              context: context,
              urlBusinessTime:
                  "https://wa.me/+551131256767/?text=Olá, preciso conversar sobre: \n",
            ),
          ],
        ),
      ),
    );
  }
}
