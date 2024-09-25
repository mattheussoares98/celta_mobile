import 'package:celta_inventario/main/routes.dart';
import 'package:celta_inventario/main/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:platform_plus/platform_plus.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';

import '../providers/providers.dart';
import '../utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PlatformPlus.platform.init();
  await FirebaseHelper.initFirebase();

  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => AdjustSalePriceProvider()),
        ChangeNotifierProvider(create: (_) => AdjustStockProvider()),
        ChangeNotifierProvider(
            create: (_) => EvaluationAndSuggestionsProvider()),
        ChangeNotifierProvider(create: (_) => BuyRequestProvider()),
        ChangeNotifierProvider(create: (_) => EnterpriseProvider()),
        ChangeNotifierProvider(create: (_) => CustomerRegisterProvider()),
        ChangeNotifierProvider(create: (_) => ConfigurationsProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => ExpeditionConferenceProvider()),
        ChangeNotifierProvider(create: (_) => ReceiptProvider()),
        ChangeNotifierProvider(create: (_) => ResearchPricesProvider()),
        ChangeNotifierProvider(create: (_) => PriceConferenceProvider()),
        ChangeNotifierProvider(create: (_) => SaleRequestProvider()),
        ChangeNotifierProvider(create: (_) => TransferRequestProvider()),
        ChangeNotifierProvider(create: (_) => TransferBetweenStocksProvider()),
        ChangeNotifierProvider(create: (_) => WebProvider()),
      ],
      child: MaterialApp(
        navigatorKey: NavigatorKey.navigatorKey,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        theme: theme(),
        debugShowCheckedModeBanner: false,
        initialRoute: APPROUTES.SPLASHPAGE,
        routes: routes(),
      ),
    );
  }
}
