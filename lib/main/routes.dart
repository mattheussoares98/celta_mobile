import 'package:flutter/material.dart';

import '../pages/evaluation_and_suggestions/evaluation_and_suggestions_page.dart';
import '../pages/expedition_conference/expedition_controls_to_conference_page.dart';
import '../pages/adjust_sale_price/adjust_sale_price.dart';
import '../pages/web/web.dart';
import '../pages/adjust_stock/adjust_stock.dart';
import '../pages/buy_request/buy_request.dart';
import '../pages/customer_register/customer_register.dart';
import '../pages/drawer/drawer.dart';
import '../Pages/inicial_pages/inicial_pages.dart';
import '../Pages/inventory/inventory.dart';
import '../pages/price_conference/price_conference.dart';
import '../pages/receipt/receipt.dart';
import '../pages/research_prices/research_prices.dart';
import '../pages/notifications/notifications_page.dart';
import '../pages/transfer_between_stocks/transfer_between_stocks.dart';
import '../pages/transfer_request/transfer_request.dart';
import '../pages/sale_request/sale_request.dart';
import '../utils/utils.dart';

Map<String, Widget Function(BuildContext)> routes() => {
      APPROUTES.EVALUATION_AND_SUGGESTIONS: (ctx) =>
          const EvaluationAndSuggestionsPage(),
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
      APPROUTES.EXPEDITION_CONTROLS_TO_CONFERENCE: (ctx) =>
          const ExpeditionControlsToConferencePage(),
      APPROUTES.ADJUST_STOCK: (ctx) => const AdjustStockPage(),
      APPROUTES.SALE_REQUEST: (ctx) => const SaleRequestPage(),
      APPROUTES.SALE_REQUEST_MODEL: (ctx) => const RequestsPage(),
      APPROUTES.SALE_REQUEST_MANUAL_DEFAULT_REQUEST_MODEL: (ctx) =>
          const ManualDefaultRequestModelPage(),
      APPROUTES.TRANSFER_REQUEST_MODEL: (ctx) => const RequestsModelPage(),
      APPROUTES.TRANSFER_ORIGIN_ENTERPRISE: (ctx) =>
          const OriginEnterprisePage(),
      APPROUTES.TRANSFER_DESTINY_ENTERPRISE: (ctx) =>
          const DestinyEnterprisePage(),
      APPROUTES.TRANSFER: (ctx) => const TransferPage(),
      APPROUTES.TRANSFER_BETWEEN_STOCK: (ctx) =>
          const TransferBetweenStockPage(),
      // APPROUTES.TRANSFER_BETWEEN_PACKAGE: (ctx) =>
      //     const TransferBetweenPackagePage(),
      APPROUTES.CUSTOMER_REGISTER: (ctx) => const CustomerRegisterPage(),
      APPROUTES.TECHNICAL_SUPPORT: (ctx) => const TechnicalSupportPage(),
      APPROUTES.CONFIGURATIONS: (ctx) => const ConfigurationsPage(),
      APPROUTES.BUYERS: (ctx) => const BuyRequestPage(),
      APPROUTES.RESEARCH_PRICES: (ctx) => const ResearchPricesPage(),
      APPROUTES.RESEARCH_PRICES_INSERT_UPDATE_RESEARCH_PRICE: (ctx) =>
          const ResearchPricesInsertOrUpdateResearchPrice(),
      APPROUTES.RESEARCH_PRICES_CONCURRENTS: (ctx) =>
          const ResearchPricesConcurrentsPage(),
      APPROUTES.RESERACH_PRICE_INSERT_UPDATE_CONCORRENT: (ctx) =>
          const ResearchPricesInsertOrUpdateConcurrentPage(),
      APPROUTES.RESEARCH_PRICES_INSERT_PRICE: (ctx) =>
          const ResearchPricesProductsPage(),
      APPROUTES.NOTIFICATIONS: (ctx) => const NotificationsPage(),
      APPROUTES.WEB_LOGIN: (ctx) => const WebLoginPage(),
      APPROUTES.WEB_HOME: (ctx) => const WebHomePage(),
      APPROUTES.WEB_ENTERPRISE_DETAILS: (ctx) =>
          const WebEnterpriseDetailsPage(),
      APPROUTES.WEB_SOAP_DETAILS: (ctx) => const SoapDetailsPage(),
      APPROUTES.ADJUST_SALE_PRICE_PRODUCTS: (ctx) =>
          const AdjustSalePriceProductsPage(),
      APPROUTES.ADJUST_SALE_PRICE: (ctx) => const AdjustSalePricePage(),
    };
