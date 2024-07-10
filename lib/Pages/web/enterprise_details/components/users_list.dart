import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/firebase/firebase.dart';

class UsersList extends StatelessWidget {
  final FirebaseEnterpriseModel client;
  const UsersList({
    required this.client,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: client.usersInformations!.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Text(
                  "Usuários que já utilizaram o APP");
            }

            final clientInformation = client.usersInformations![index - 1];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 220, 218, 218)),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: Color(0x33000000),
                      offset: Offset(-3, -1),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            maxRadius: 15,
                            minRadius: 15,
                            child: Text(
                              (index).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(
                            clientInformation.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ],
                      ),
                      Text("Dispositivo: ${clientInformation.deviceType}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Última atualização: " +
                                DateFormat('dd/MM/yyyy').format(
                                  clientInformation.dateOfLastUpdatedInFirebase,
                                ),
                          ),
                          Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message:
                                "A data é atualizada a cada 7 dias",
                            child: Icon(
                              Icons.info,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
