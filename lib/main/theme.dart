import 'package:flutter/material.dart';

import '../utils/utils.dart';

ThemeData theme() {
  return ThemeData(
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
  );
}
