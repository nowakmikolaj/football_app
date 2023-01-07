import 'package:flutter/cupertino.dart';
import 'package:football_app/utils/themes.dart';
import 'package:provider/provider.dart';

extension MediaQueryExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}

extension ProviderExtension on BuildContext {
  ThemeChanger get themeChanger => Provider.of<ThemeChanger>(
        this,
        listen: false,
      );
}
