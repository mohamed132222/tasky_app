import 'package:flutter/material.dart';

import '../constant/app_size.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(primaryContainer: Color(0xFF282828)),

  scaffoldBackgroundColor: const Color(0xFF181818),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF181818),
    elevation: 0,
    iconTheme: const IconThemeData(color: Color(0xFFFFFCFC)),
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: AppSize.f20,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
      fontFamily: "Poppins",
    ),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color(0xFF15B86C);
      }
      return Color(0xFF6E6E6E);
    }),
    thumbColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color(0xFFFFFCFC);
      }
      return Color(0xFF9E9E9E);
    }),
    trackOutlineColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.transparent;
      }
      return Color(0xFF6E6E6E);
    }),
    trackOutlineWidth: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return 0;
      }
      return 2;
    }),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF15B86C),
      foregroundColor: Color(0xFFFFFCFC),
      textStyle: TextStyle(
        fontSize: AppSize.f14,
        fontWeight: FontWeight.w500,
        fontFamily: "Poppins",
      ),
      minimumSize: Size.fromHeight(40),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    extendedTextStyle: TextStyle(
      fontSize: AppSize.f14,
      fontWeight: FontWeight.w500,
      fontFamily: "Poppins",
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: AppSize.f32,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
      fontFamily: "Poppins",
    ),
    displayMedium: TextStyle(
      fontSize: AppSize.f28,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
      fontFamily: "Poppins",
    ),
    displaySmall: TextStyle(
      fontSize: AppSize.f24,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
      fontFamily: "Poppins",
    ),
    headlineMedium: TextStyle(
      fontSize: AppSize.f16,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
      fontFamily: "Poppins",
    ),
    headlineSmall: TextStyle(
      fontSize: AppSize.f14,
      fontWeight: FontWeight.w400,
      color: Color(0xFFC6C6C6),
      fontFamily: "Poppins",
    ),
    labelSmall: TextStyle(
      fontSize: AppSize.f18,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
      fontFamily: "Poppins",
    ),
    titleLarge: TextStyle(
      fontSize: AppSize.f20,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
      fontFamily: "Poppins",
    ),
    //task is not done
    titleMedium: TextStyle(
      overflow: TextOverflow.ellipsis,
      fontSize: AppSize.f16,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
      fontFamily: "Poppins",
    ),

    //task is done
    titleSmall: TextStyle(
      overflow: TextOverflow.ellipsis,
      fontSize: AppSize.f16,
      fontWeight: FontWeight.w400,
      color: Color(0xFFA0A0A0),
      fontFamily: "Poppins",
      decoration: TextDecoration.lineThrough,
      decorationColor: Color(0xFF6A6A6A),
      decorationThickness: 1.5,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF282828),
    hintStyle: TextStyle(
      color: Color(0xFF6D6D6D),
      fontSize: AppSize.f16,
      fontWeight: FontWeight.w400,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.r16),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.r16),
      borderSide: BorderSide(color: Colors.red, width: .5),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(AppSize.r4),
    ),
    side: BorderSide(color: Color(0xFF6E6E6E), width: 2),
  ),
  iconTheme: IconThemeData(color: Color(0xFFC6C6C6)),
  dividerColor: Color(0xFF6E6E6E),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.black,
    selectionHandleColor: Colors.white,
  ),
  listTileTheme: ListTileThemeData(
    titleTextStyle: TextStyle(
      overflow: TextOverflow.ellipsis,
      fontSize: AppSize.f16,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
      fontFamily: "Poppins",
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    unselectedItemColor: Color(0xFFC6C6C6),
    selectedItemColor: Color(0xFF15B86C),
    backgroundColor: Color(0xFF181818),
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(
      fontSize: AppSize.f12,
      fontWeight: FontWeight.w600,
      fontFamily: "Roboto",
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: AppSize.f12,
      fontWeight: FontWeight.w500,
      fontFamily: "Roboto",
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
    ),
  ),
  splashFactory: NoSplash.splashFactory,
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(AppSize.r16),
      side: BorderSide(color: Color(0xFF15B86C), width: 1.5),
    ),
    color: Color(0xFF181818),

    elevation: 10,
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(
        fontSize: AppSize.f16,
        fontWeight: FontWeight.w400,
        color: Color(0xFFFFFCFC),
        fontFamily: "Poppins",
      ),
    ),
    shadowColor: Color(0xFF000000),
  ),
);
