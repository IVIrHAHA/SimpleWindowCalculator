import 'dart:async';

import './Tools/DatabaseProvider.dart';
import './Util/ItemsManager.dart';
import './objects/Window.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GlobalValues.dart';
import 'Util/HexColors.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'objects/OManager.dart';

void main() {
  runApp(MyApp());
}

/// Initializing ThemeData (Colors and Textstyles)
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Window Calculator',
      theme: ThemeData(
        disabledColor: Colors.grey,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              headline5: TextStyle(
                fontFamily: 'Lato',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              bodyText1: TextStyle(
                  fontFamily: 'OpenSans', fontWeight: FontWeight.normal),
            ),
        primarySwatch: HexColors.createMaterialColor(
          '#51AFFF',
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MySplashScreen(),
    );
  }
}

/// Splash Screen which instantiates any AppData (Database and default values) the user may need
/// upon start up.
class MySplashScreen extends StatelessWidget {
  /// Replaces the SplashScreen route with MyHomePage(main page) after default data has been
  /// initialized.
  _router(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, anim, anim2) => MyHomePage(),
        transitionsBuilder: (ctx, anim, anim2, child) {
          /// Makes the splash screen fade out
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: anim.drive(Tween(begin: 0.0, end: 1.0)),
              curve: Curves.easeIn,
              reverseCurve: Curves.easeIn,
            ),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 1200),
      ),
    );
  }

  Future<void> _initData() async {
    print('INITIALIZING DATA...');
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Prepare the window list and Manager instance
    ItemsManager.init<Window>();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Initialize database if needed and fill with default values.
    bool hasDatabase = await DatabaseProvider.instance.isInitialized();
    if (!hasDatabase) {
      DatabaseProvider.instance.fillDatabase(OManager.presetWindows);
      prefs.setString(DEFAULT_WINDOW_KEY, OManager.getDefaultWindow().name);
    }

    // Set the active window as dictated by the OManager
    String defaultWindow = prefs.getString(DEFAULT_WINDOW_KEY);
    Window startingWindow = await DatabaseProvider.instance.queryWindow(
      defaultWindow,
    );

    if (startingWindow != null) {
      ItemsManager.instance.activeItem = startingWindow;
      print(
          'INSTANTIATED ACTIVE WINDOW: ${ItemsManager.instance.activeItem.name}');
      return;
    } else {
      throw Exception("FAILED TO INSTANTIATE STARTING WINDOW");
    }
  }

  @override
  Widget build(BuildContext context) {
    _initData().whenComplete(() {
      _router(context);
    });

    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.primary,
      child: Text(
        'Hello Sunshine!',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
