import 'package:celta_inventario/Pages/Inicial_pages/enterprise_page.dart';
import 'package:celta_inventario/Pages/adjust_stock_pages/adjust_stock_page.dart';
import 'package:celta_inventario/Pages/buy_request/buy_request_page.dart';
import 'package:celta_inventario/Pages/customer_register/customer_register_page.dart';
import 'package:celta_inventario/Pages/drawer/configurations_page.dart';
import 'package:celta_inventario/Pages/price_conference_pages/price_conference_page.dart';
import 'package:celta_inventario/Pages/Inventory/inventory_counting_page.dart';
import 'package:celta_inventario/Pages/receipt_pages/receipt_conference_page.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_manual_default_request_model_page.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_page.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_model_page.dart';
import 'package:celta_inventario/Pages/drawer/technical_support_page.dart';
import 'package:celta_inventario/Pages/transfer_between_package/transfer_between_package_page.dart';
import 'package:celta_inventario/Pages/transfer_request/transfer_destiny_enterprise_page.dart';
import 'package:celta_inventario/Pages/transfer_request/transfer_origin_enterprise_page.dart';
import 'package:celta_inventario/Pages/transfer_request/transfer_request_model_page.dart';
import 'package:celta_inventario/Pages/transfer_between_stocks_pages/transfer_between_stocks_page.dart';
import 'package:celta_inventario/api/firebase_helper.dart';
import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:celta_inventario/Pages/Inventory/inventory_page.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:celta_inventario/Pages/Inventory/inventory_product_page.dart';
import 'package:celta_inventario/Pages/receipt_pages/receipt_page.dart';
import 'package:celta_inventario/providers/receipt_provider.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/providers/transfer_between_package_provider_SemImplementacaoAinda.dart';
import 'package:celta_inventario/providers/transfer_between_stocks_provider.dart';
import 'package:celta_inventario/providers/transfer_request_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/colors_theme.dart';
import 'package:celta_inventario/utils/responsive_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_plus/platform_plus.dart';
import 'package:provider/provider.dart';
import 'Pages/transfer_request/transfer_page.dart';
import 'pages/Inicial_pages/home_page.dart';
import 'pages/Inicial_pages/login_or_home_page.dart';
import 'pages/Inicial_pages/login_page.dart';
import 'providers/enterprise_provider.dart';
import 'providers/login_provider.dart';
import 'pages/Inicial_pages/splash_page.dart';
import 'providers/price_conference_provider.dart';

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
      ],
      child: MaterialApp(
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
        },
      ),
    );
  }
}
