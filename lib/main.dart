import 'package:delivery_boy/ui/orders_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/view_model/auth_view_model/auth_view_model_provider.dart';
import 'ui/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  TextTheme _buildShrineTextTheme(TextTheme base) {
    return base
        .copyWith(
          headline5: base.headline5.copyWith(
            fontWeight: FontWeight.w500,
          ),
          headline6: base.headline6.copyWith(fontSize: 18.0),
          caption: base.caption.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
          bodyText1: base.bodyText1.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        )
        .apply(
          fontFamily: 'Rubik',
        );
  }

  @override
  Widget build(BuildContext context) {
    var user = context.read(authViewModelProvider).user;
    var base = ThemeData.light();

    ///Charcoal
    final Color accentColor = Color(0xFFFFC857);
    return MaterialApp(
      title: 'Delivery Boy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        ///Old lace
        scaffoldBackgroundColor: Color(0xFFE5E8EA),

        ///Maximum Yelllo red
        primaryColor: Color(0xFF2E4052),
        textTheme: _buildShrineTextTheme(base.textTheme),
        primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
        accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),

        ///Polished Pine
        primaryColorDark: Color(0xFF2E4052),
        backgroundColor: Colors.white,
        accentColor: accentColor,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: accentColor,
            shape: RoundedRectangleBorder(),
          ),
        ),
        chipTheme: ChipTheme.of(context).copyWith(
            selectedColor: accentColor,
            secondarySelectedColor: accentColor,
            secondaryLabelStyle: TextStyle(color: Colors.black),
            backgroundColor: Color(0xFFCBD0D4)),

        ///Honeydue
        primaryColorLight: Color(0xFFFFE4AB),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: accentColor),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          buttonColor: accentColor,
          textTheme: ButtonTextTheme.primary,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: user != null ? OrdersPage() : SignInPage(),
    );
  }
}
