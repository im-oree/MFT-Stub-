import 'package:flutter/material.dart';

/// Semantic monochrome palette. The design is strictly black / white / gray —
/// no accent color anywhere. Dark mode is the clean monochrome inversion.
class WtrPalette {
  final Color ink; // primary text + solid elements (black in light, white in dark)
  final Color onInk; // text/icons drawn on top of `ink`
  final Color block; // the strong header/CTA block (black in light, white in dark)
  final Color onBlock; // text on the block
  final Color bg; // app background
  final Color canvas; // alternate section background
  final Color card; // cards / surfaces
  final Color skeleton; // loading placeholders
  final Color muted; // secondary text + inactive nav
  final Color divider;
  final Color border;

  const WtrPalette({
    required this.ink,
    required this.onInk,
    required this.block,
    required this.onBlock,
    required this.bg,
    required this.canvas,
    required this.card,
    required this.skeleton,
    required this.muted,
    required this.divider,
    required this.border,
  });

  static const light = WtrPalette(
    ink: Color(0xFF000000),
    onInk: Color(0xFFFFFFFF),
    block: Color(0xFF000000),
    onBlock: Color(0xFFFFFFFF),
    bg: Color(0xFFFFFFFF),
    canvas: Color(0xFFF5F5F5),
    card: Color(0xFFFFFFFF),
    skeleton: Color(0xFFEFEFF1),
    muted: Color(0xFF8E8E93),
    divider: Color(0xFFE5E5EA),
    border: Color(0xFFECECEE),
  );

  static const dark = WtrPalette(
    ink: Color(0xFFFFFFFF),
    onInk: Color(0xFF000000),
    block: Color(0xFFFFFFFF),
    onBlock: Color(0xFF000000),
    bg: Color(0xFF000000),
    canvas: Color(0xFF0E0E10),
    card: Color(0xFF161617),
    skeleton: Color(0xFF232326),
    muted: Color(0xFF9A9A9F),
    divider: Color(0xFF262629),
    border: Color(0xFF2A2A2D),
  );
}

/// Resolve the active palette from the nearest theme brightness.
WtrPalette paletteOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? WtrPalette.dark : WtrPalette.light;

ThemeData get wtrLightTheme => _build(Brightness.light);
ThemeData get wtrDarkTheme => _build(Brightness.dark);

ThemeData _build(Brightness brightness) {
  const p = brightness == Brightness.dark ? WtrPalette.dark : WtrPalette.light;
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: p.bg,
    // fontFamily: 'Poppins', // ← enable when the Poppins assets are present
  );
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: p.ink,
      onPrimary: p.onInk,
      surface: p.card,
      onSurface: p.ink,
      outline: p.border,
    ),
    dividerColor: p.divider,
    appBarTheme: AppBarTheme(
      backgroundColor: p.bg,
      foregroundColor: p.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: p.ink,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.canvas,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: p.ink, width: 1.5),
      ),
      labelStyle: TextStyle(color: p.muted),
      hintStyle: TextStyle(color: p.muted),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: p.bg,
      selectedItemColor: p.ink,
      unselectedItemColor: p.muted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
    ),
  );
}
