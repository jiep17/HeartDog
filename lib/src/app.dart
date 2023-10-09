import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:heartdog/src/route_generator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarkBeat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Europa'
          //colorScheme: ColorScheme.fromSwatch()
          ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
         Locale('es', 'ES'),
         Locale('en', 'US'),
        // Agrega otros idiomas que desees soportar
      ],
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      //navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}
