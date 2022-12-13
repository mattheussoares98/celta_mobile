import 'package:flutter/material.dart';

class SaleRequestManualDefaultRequestModelPage extends StatelessWidget {
  const SaleRequestManualDefaultRequestModelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> _steps = [
      "Acesse o BS e vá em \"Parametrizações > Gerais > Parâmetros globais por empresa\"",
      "Consulte a empresa",
      "Aperte F4",
      "Vá até a aba “Dispositivos móveis”. Caso essa aba não apareça, entre em contato com o suporte e solicite a atualização do sistema",
      "Pesquise os modelos de pedido, insira o modelo de pedido de vendas que será utilizado como padrão no aplicativo e aperte F12 para salvar",
      "No Celta Mobile, consulte novamente a empresa no processo de pedido de vendas, pois é na consulta de empresas que carrega a informação do modelo de pedido padrão",
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            "Para conseguir criar pedidos de vendas pelo Celta Mobile, precisa configurar um modelo de pedido de vendas padrão no Celta BS. Todos pedidos de venda criados através do aplicativo usarão esse modelo configurado como padrão. \n\nPara cadastrar, siga o passo a passo abaixo",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.separated(
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: FittedBox(
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 2.0,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(_steps[index]),
                        ),
                      ],
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.grey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
