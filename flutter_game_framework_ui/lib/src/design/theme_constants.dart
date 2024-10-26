// ignore_for_file: constant_identifier_names

import 'package:flex_color_scheme/flex_color_scheme.dart';
// import 'package:google_fonts/google_fonts.dart';

// /// The color of light buttons, accent text, dividers, favorites, etc.
// const COLOR_RED = Color.fromARGB(255, 128, 13, 15);

// /// The color of dark buttons, accent text, dividers, light button text, etc.
// const COLOR_WHITE = Color.fromARGB(255, 239, 235, 220);

// /// The color of dark button text
// const COLOR_DARK_RED = Color.fromARGB(255, 75, 16, 0);

// /// The color of text in light mode
// const COLOR_BLACK = Color.fromARGB(255, 0, 0, 0);

// /// The color gold for the dark mode, in light shades.
// const COLOR_DM_GOLD_LIGHT = Color.fromARGB(255, 203, 170, 17);

// /// The color gold for the light mode, in light shades.
// const COLOR_LM_GOLD_LIGHT = Color.fromARGB(255, 248, 247, 201);

// /// The color gold for the dark mode, in dark shades.
// const COLOR_DM_GOLD_DARK = Color.fromARGB(255, 128, 57, 9);

// /// The color gold for the light mode, in dark shades.
// const COLOR_LM_GOLD_DARK = Color.fromARGB(255, 232, 149, 37);

// /// The light theme
// ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   primaryColor: COLOR_RED,
//   useMaterial3: true,
// );
// // elevatedButtonTheme: ElevatedButtonThemeData(
// //   style: ButtonStyle(
// //     padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
// //       const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
// //     ),
// //     shape: MaterialStateProperty.all<OutlinedBorder>(
// //       RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(20),
// //       ),
// //     ),
// //     backgroundColor: MaterialStateProperty.all<Color>(COLOR_RED),
// //   ),
// // ),
// // inputDecorationTheme: InputDecorationTheme(
// //   border: OutlineInputBorder(
// //     borderRadius: BorderRadius.circular(20),
// //     borderSide: BorderSide.none,
// //   ),
// //   filled: true,
// //   fillColor: Colors.grey.withOpacity(0.1),
// // ),

// /// The dark theme
// ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: COLOR_RED,
//   useMaterial3: true,
// );

// Theme config for FlexColorScheme version 7.3.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.

/// The light theme
final lightTheme = FlexThemeData.light(
  scheme: FlexScheme.yellowM3,
  surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
  blendLevel: 2,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    blendTextTheme: true,
    useTextTheme: true,
    outlinedButtonOutlineSchemeColor: SchemeColor.primary,
    outlinedButtonPressedBorderWidth: 2,
    toggleButtonsBorderSchemeColor: SchemeColor.primary,
    segmentedButtonSchemeColor: SchemeColor.primary,
    segmentedButtonBorderSchemeColor: SchemeColor.primary,
    unselectedToggleIsColored: true,
    sliderValueTinted: true,
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorBackgroundAlpha: 21,
    inputDecoratorRadius: 12,
    inputDecoratorUnfocusedHasBorder: false,
    inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
    popupMenuRadius: 6,
    popupMenuElevation: 8,
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
    drawerIndicatorSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedLabel: false,
    bottomNavigationBarMutedUnselectedIcon: false,
    menuRadius: 6,
    menuElevation: 8,
    menuBarRadius: 0,
    menuBarElevation: 1,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    navigationBarMutedUnselectedLabel: false,
    navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationBarMutedUnselectedIcon: false,
    navigationBarIndicatorSchemeColor: SchemeColor.primary,
    navigationBarIndicatorOpacity: 1,
    navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
    navigationRailMutedUnselectedLabel: false,
    navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationRailMutedUnselectedIcon: false,
    navigationRailIndicatorSchemeColor: SchemeColor.primary,
    navigationRailIndicatorOpacity: 1,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  fontFamily: 'Roboto', // GoogleFonts.notoSans().fontFamily,
);

/// The dark theme
final darkTheme = FlexThemeData.dark(
  scheme: FlexScheme.yellowM3,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 25,
  darkIsTrueBlack: true,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 15,
    blendTextTheme: true,
    useTextTheme: true,
    outlinedButtonOutlineSchemeColor: SchemeColor.primary,
    outlinedButtonPressedBorderWidth: 2,
    toggleButtonsBorderSchemeColor: SchemeColor.primary,
    segmentedButtonSchemeColor: SchemeColor.primary,
    segmentedButtonBorderSchemeColor: SchemeColor.primary,
    unselectedToggleIsColored: true,
    sliderValueTinted: true,
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorBackgroundAlpha: 43,
    inputDecoratorRadius: 12,
    inputDecoratorUnfocusedHasBorder: false,
    popupMenuRadius: 6,
    popupMenuElevation: 8,
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
    drawerIndicatorSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedLabel: false,
    bottomNavigationBarMutedUnselectedIcon: false,
    menuRadius: 6,
    menuElevation: 8,
    menuBarRadius: 0,
    menuBarElevation: 1,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    navigationBarMutedUnselectedLabel: false,
    navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationBarMutedUnselectedIcon: false,
    navigationBarIndicatorSchemeColor: SchemeColor.primary,
    navigationBarIndicatorOpacity: 1,
    navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
    navigationRailMutedUnselectedLabel: false,
    navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationRailMutedUnselectedIcon: false,
    navigationRailIndicatorSchemeColor: SchemeColor.primary,
    navigationRailIndicatorOpacity: 1,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  fontFamily: 'Roboto', // GoogleFonts.notoSans().fontFamily,
);
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
