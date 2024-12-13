import 'package:celta_inventario/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';

class EvaluationAndSuggestionsPage extends StatelessWidget {
  const EvaluationAndSuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    EvaluationAndSuggestionsProvider evaluationAndSuggestionsProvider =
        Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(child: const Text("Avaliações e sugestões")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: evaluationAndSuggestionsProvider.evaluations.length,
              itemBuilder: (context, index) {
                final evaluate =
                    evaluationAndSuggestionsProvider.evaluations[index];

                return suggestionItem(evaluate.name);
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
              child: TextField(
                decoration: FormFieldDecoration.decoration(
                  
                  context: context,
                  hintText: "Comentários e/ou sugestões para novos módulos",
                  labelText: "Comentários e/ou sugestões para novos módulos",
                ),
                style: FormFieldStyle.style(),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}

Widget suggestionItem(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(title),
      ),
      SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return FittedBox(
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.star,
                  color: Colors.grey[350],
                ),
              ),
            );
          },
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Divider(height: 5),
      ),
    ],
  );
}
