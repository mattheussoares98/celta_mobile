import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:platform_plus/platform_plus.dart';
import 'package:provider/provider.dart';

import 'pages/adjust_stock/adjust_stock.dart';
import 'pages/buy_request/buy_request.dart';
import 'pages/customer_register/customer_register.dart';
import 'pages/drawer/drawer.dart';
import 'pages/inicial_pages/inicial_pages.dart';
import 'pages/inventory/inventory.dart';
import 'pages/price_conference/price_conference.dart';
import 'pages/receipt/receipt.dart';
import 'pages/research_prices/research_prices.dart';
import 'pages/sale_request/sale_request.dart';
import 'pages/transfer_between_package/transfer_between_package.dart';
import 'pages/transfer_between_stocks/transfer_between_stocks.dart';
import 'pages/transfer_request/transfer_request.dart';
import 'api/api.dart';
import 'providers/providers.dart';
import 'utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PlatformPlus.platform.init();
  await FirebaseHelper.initFirebase();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => EnterpriseProvider()),
        ChangeNotifierProvider(create: (_) => ReceiptProvider()),
        ChangeNotifierProvider(create: (_) => PriceConferenceProvider()),
        ChangeNotifierProvider(create: (_) => AdjustStockProvider()),
        ChangeNotifierProvider(create: (_) => SaleRequestProvider()),
        ChangeNotifierProvider(create: (_) => TransferRequestProvider()),
        ChangeNotifierProvider(create: (_) => TransferBetweenStocksProvider()),
        ChangeNotifierProvider(create: (_) => TransferBetweenStocksProvider()),
        ChangeNotifierProvider(create: (_) => TransferBetweenPackageProvider()),
        ChangeNotifierProvider(create: (_) => CustomerRegisterProvider()),
        ChangeNotifierProvider(create: (_) => ConfigurationsProvider()),
        ChangeNotifierProvider(create: (_) => BuyRequestProvider()),
        ChangeNotifierProvider(
            create: (_) => ResearchPricesProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: ColorsTheme.principalColor,
          inputDecorationTheme: const InputDecorationTheme(
            //usado no dropdown
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          dialogBackgroundColor: Colors.white,
          cardTheme: CardTheme(
            color: Colors.grey[50],
            surfaceTintColor: Colors.amber[100],
            shadowColor: ColorsTheme.principalColor,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: ColorsTheme.principalColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            elevation: 5,
          ),
          secondaryHeaderColor: ColorsTheme.text,
          appBarTheme: ThemeData().appBarTheme.copyWith(
                actionsIconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                iconTheme: const IconThemeData(color: Colors.white),
                toolbarHeight: ResponsiveItems.appBarToolbarHeight,
                backgroundColor: ColorsTheme.principalColor,
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  letterSpacing: 0.7,
                  color: ColorsTheme.appBarText,
                  fontFamily: 'BebasNeue',
                  fontSize: 30,
                ),
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorsTheme.text,
              backgroundColor: ColorsTheme.principalColor,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: ColorsTheme.elevatedButtonTextColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          datePickerTheme: const DatePickerThemeData(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            dividerColor: Colors.amberAccent,
            headerBackgroundColor: ColorsTheme.principalColor,
            surfaceTintColor: Colors.white,
            headerForegroundColor: Colors.white,
          ),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: ColorsTheme.principalColor,
            onPrimary: ColorsTheme.principalColor,
            secondary: const Color.fromARGB(255, 92, 152, 94),
            onSecondary: const Color.fromARGB(255, 92, 152, 94),
            error: Colors.red,
            onError: Colors.red,
            background: Colors.white,
            onBackground: Colors.white,
            surface: Colors.white,
            onSurface: Colors.white,
          ),
        ).copyWith(
          textTheme: ThemeData.light().textTheme.copyWith(
                titleLarge: const TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: ColorsTheme.headline6,
                  fontSize: ResponsiveItems.headline6,
                  fontFamily: 'BebasNeue',
                ),
                displayMedium: const TextStyle(
                  // letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: ColorsTheme.headline2,
                  fontSize: 17,
                  fontFamily: 'OpenSans',
                ),
                bodyLarge: const TextStyle(
                  fontFamily: 'OpenSans',
                  color: ColorsTheme.headline6,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: ColorsTheme.principalColor,
                secondary: ColorsTheme.text,
                onSecondary: ColorsTheme.principalColor,
              ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: APPROUTES.SPLASHPAGE,
        routes: {
          APPROUTES.LOGIN_OR_HOME_PAGE: (ctx) => const AuthOrHoMePage(),
          APPROUTES.LOGIN_PAGE: (ctx) => const LoginPage(),
          APPROUTES.INVENTORY: (ctx) => const InventoryPage(),
          APPROUTES.COUNTINGS: (ctx) => const CountingPage(),
          APPROUTES.INVENTORY_PRODUCTS: (ctx) => const InventoryProductsPage(),
          APPROUTES.SPLASHPAGE: (ctx) => SplashPage(),
          APPROUTES.HOME_PAGE: (ctx) => const HomePage(),
          APPROUTES.RECEIPT: (ctx) => const ReceiptPage(),
          APPROUTES.RECEIPT_CONFERENCE: (ctx) => const ReceiptConferencePage(),
          APPROUTES.PRICE_CONFERENCE: (ctx) => const PriceConferencePage(),
          APPROUTES.ENTERPRISE: (ctx) => const EnterprisePage(),
          APPROUTES.ADJUST_STOCK: (ctx) => const AdjustStockPage(),
          APPROUTES.SALE_REQUEST: (ctx) => const SaleRequestPage(),
          APPROUTES.SALE_REQUEST_MODEL: (ctx) => const SaleRequestModelPage(),
          APPROUTES.SALE_REQUEST_MANUAL_DEFAULT_REQUEST_MODEL: (ctx) =>
              const SaleRequestManualDefaultRequestModelPage(),
          APPROUTES.TRANSFER_REQUEST_MODEL: (ctx) =>
              const TransferRequestModelPage(),
          APPROUTES.TRANSFER_ORIGIN_ENTERPRISE: (ctx) =>
              const TransferOriginEnterprisePage(),
          APPROUTES.TRANSFER_DESTINY_ENTERPRISE: (ctx) =>
              const TransferDestinyEnterprisePage(),
          APPROUTES.TRANSFER: (ctx) => const TransferPage(),
          APPROUTES.TRANSFER_BETWEEN_STOCK: (ctx) =>
              const TransferBetweenStockPage(),
          APPROUTES.TRANSFER_BETWEEN_PACKAGE: (ctx) =>
              const TransferBetweenPackagePage(),
          APPROUTES.CUSTOMER_REGISTER: (ctx) => const CustomerRegisterPage(),
          APPROUTES.TECHNICAL_SUPPORT: (ctx) => const TechnicalSupportPage(),
          APPROUTES.CONFIGURATIONS: (ctx) => const ConfigurationsPage(),
          APPROUTES.BUYERS: (ctx) => const BuyRequestPage(),
          APPROUTES.SEARCH_CONCURRENT_PRICES: (ctx) =>
              const ResearchConcurrentPricesPage(),
        },
      ),
    );
  }
}
