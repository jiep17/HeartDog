import 'package:flutter/material.dart';
import 'package:heartdog/src/route_generator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'BarkBeat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Europa'
        //colorScheme: ColorScheme.fromSwatch()
      ),
      /*localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en','US'),
        Locale('es','ES')
      ],*/
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      
    );
  }
}