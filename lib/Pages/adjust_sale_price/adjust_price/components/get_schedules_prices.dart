import 'package:celta_inventario/components/components.dart';
import 'package:celta_inventario/models/enterprise/enterprise.dart';
import 'package:celta_inventario/models/soap/products/products.dart';
import 'package:celta_inventario/providers/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GetSchedulesPrices extends StatelessWidget {
  final EnterpriseModel enterprise;
  final GetProductJsonModel product;
  const GetSchedulesPrices({
    required this.enterprise,
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider =
        Provider.of(context, listen: false);

    return Column(
      children: [
        TextButton(
          onPressed: () async {
            await adjustSalePriceProvider.getProductSchedules(
              enterpriseCode: enterprise.codigoInternoEmpresa,
              productCode: product.productCode!,
              productPackingCode: product.productPackingCode!,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(adjustSalePriceProvider.schedules.isEmpty
                  ? "Obter agendamentos de preços"
                  : "Atualizar agendamentos"),
              const SizedBox(width: 5),
              const Icon(Icons.timer_sharp)
            ],
          ),
        ),
        if (adjustSalePriceProvider.errorMessageSchedule.isNotEmpty)
          ErrorMessage(
            errorMessage: adjustSalePriceProvider.errorMessageSchedule,
            fontSize: 12,
          ),
        if (adjustSalePriceProvider.schedules.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: adjustSalePriceProvider.schedules.length,
            itemBuilder: (context, index) {
              final schedule = adjustSalePriceProvider.schedules[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Usuário",
                        subtitle: schedule.User.toString(),
                      ),
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Tipo de preço",
                        subtitle: schedule.PriceTypeString.toString(),
                      ),
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Origem",
                        subtitle: schedule.OriginString.toString(),
                      ),
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Novo preço",
                        subtitle: schedule.OriginalPrice.toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin(),
                      ),
                      if (schedule.AlteredByClass == true)
                        TitleAndSubtitle.titleAndSubtitle(
                          subtitle: "Altera a classe",
                        ),
                      if (schedule.UpdateEnterpriseOperationalGroup == true)
                        TitleAndSubtitle.titleAndSubtitle(
                          subtitle: "Altera o agrupamento operacional",
                        ),
                      if (schedule.AlteredByGrid == true)
                        TitleAndSubtitle.titleAndSubtitle(
                          subtitle: "Altera a grade",
                        ),
                      if (schedule.AlteredByPackings == true)
                        TitleAndSubtitle.titleAndSubtitle(
                          subtitle: "Altera as embalagens",
                        ),
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Finalizado",
                        subtitle: schedule.IsFinished == true ? "Sim" : "Não",
                      ),
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Data do agendamento",
                        subtitle: DateFormat("dd/MM/yyyy HH:mm").format(
                          DateTime.parse(schedule.Date.toString()),
                        ),
                      ),
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Data de execução",
                        subtitle: DateFormat("dd/MM/yyyy HH:mm").format(
                          DateTime.parse(schedule.ExecutionDate.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
      ],
    );
  }
}
