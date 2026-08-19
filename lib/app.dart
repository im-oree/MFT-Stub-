import 'package:flutter/material.dart';

import '../nav/main_shell.dart';
import '../services/app_session.dart';
import '../theme/wtr_theme.dart';

class WtrApp extends StatelessWidget {
  const WtrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: session,
      builder: (context, _) {
        return MaterialApp(
          title: 'Welcome To The Roof',
          debugShowCheckedModeBanner: false,
          theme: wtrLightTheme,
          darkTheme: wtrDarkTheme,
          themeMode: session.themeMode,
          home: const MainShell(),
        );
      },
    );
  }
}
