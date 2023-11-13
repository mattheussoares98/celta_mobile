import 'package:celta_inventario/components/Buy_request/buy_request_buyers_dropdown.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_requests_type_dropdown.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_suppliers.dart';
import 'package:flutter/material.dart';

class BuyRequestIdentificationPage extends StatefulWidget {
  const BuyRequestIdentificationPage({Key? key}) : super(key: key);

  @override
  State<BuyRequestIdentificationPage> createState() =>
      _BuyRequestIdentificationPageState();
}

class _BuyRequestIdentificationPageState
    extends State<BuyRequestIdentificationPage> {
  final GlobalKey<FormState> _dropDownFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _dropDownFormKey,
      child: const Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuyRequestBuyersDropwodn(),
                  SizedBox(height: 20),
                  BuyRequestRequestsTypeDropdown(),
                  SizedBox(height: 20),
                  BuyRequestSuplliers(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
