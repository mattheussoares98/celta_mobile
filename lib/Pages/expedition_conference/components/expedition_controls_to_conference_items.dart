import 'package:celta_inventario/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class ExpeditionControlsToConferenceItems extends StatelessWidget {
  const ExpeditionControlsToConferenceItems({super.key});

  @override
  Widget build(BuildContext context) {
    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount:
          expeditionConferenceProvider.expeditionControlsToConference.length,
      itemBuilder: (context, index) {
        final expeditionControl =
            expeditionConferenceProvider.expeditionControlsToConference[index];

        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              APPROUTES.EXPEDITION_CONFERENCE_PRODUCTS,
              arguments: expeditionControl,
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Documento",
                    subtitle: expeditionControl.DocumentNumber,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Nome da etapa",
                    subtitle: expeditionControl.StepName,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Origem",
                    subtitle: expeditionControl.OriginTypeString,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
