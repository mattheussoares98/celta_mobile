import 'package:celta_inventario/Pages/Inicial_pages/enterprise_page.dart';
import 'package:celta_inventario/Pages/adjust_stock_page.dart';
import 'package:celta_inventario/Pages/enterprise_json_page.dart';
import 'package:celta_inventario/Pages/price_conference_page.dart';
import 'package:celta_inventario/Pages/Inventory/inventory_counting_page.dart';
import 'package:celta_inventario/Pages/receipt_conference_page.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_page.dart';
import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:celta_inventario/providers/enterprise_json_provider.dart';
import 'package:celta_inventario/providers/inventory_counting_provider.dart';
import 'package:celta_inventario/Pages/Inventory/inventory_page.dart';
import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:celta_inventario/Pages/Inventory/inventory_product_page.dart';
import 'package:celta_inventario/providers/inventory_product_provider.dart';
import 'package:celta_inventario/providers/receipt_conference_provider.dart';
import 'package:celta_inventario/Pages/receipt_page.dart';
import 'package:celta_inventario/providers/receipt_provider.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/colors_theme.dart';
import 'package:celta_inventario/utils/responsive_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'pages/Inicial_pages/home_page.dart';
import 'pages/Inicial_pages/login_or_home_page.dart';
import 'pages/Inicial_pages/login_page.dart';
import 'providers/enterprise_provider.dart';
import 'providers/login_provider.dart';
import 'pages/Inicial_pages/splash_page.dart';
import 'providers/price_conference_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
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
        ChangeNotifierProvider(create: (_) => InventoryCountingProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProductProvider()),
        ChangeNotifierProvider(create: (_) => ReceiptProvider()),
        ChangeNotifierProvider(create: (_) => ReceiptConferenceProvider()),
        ChangeNotifierProvider(create: (_) => PriceConferenceProvider()),
        ChangeNotifierProvider(create: (_) => AdjustStockProvider()),
        ChangeNotifierProvider(create: (_) => SaleRequestProvider()),
        ChangeNotifierProvider(create: (_) => EnterpriseJsonProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: ColorsTheme.principalColor,
          secondaryHeaderColor: ColorsTheme.text,
          backgroundColor: Colors.lightGreen[100],
          appBarTheme: ThemeData().appBarTheme.copyWith(
                actionsIconTheme: const IconThemeData(
                  color: Colors.black,
                ),
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
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: ColorsTheme.elevatedButtonTextColor,
              ),
              primary: ColorsTheme.principalColor,
              onPrimary: ColorsTheme.text,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ).copyWith(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: ColorsTheme.headline6,
                  fontSize: ResponsiveItems.headline6,
                  fontFamily: 'BebasNeue',
                ),
                headline2: const TextStyle(
                  // letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: ColorsTheme.headline2,
                  fontSize: 17,
                  fontFamily: 'OpenSans',
                ),
                bodyText1: const TextStyle(
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
          APPROUTES.ENTERPRISE_JSON: (ctx) => const EnterpriseJsonPage(),
        },
      ),
    );
  }
}
