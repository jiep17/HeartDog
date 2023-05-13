

import 'package:flutter/material.dart';
import 'package:heartdog/src/pages/login_page.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case '/':return MaterialPageRoute(builder: (context)=> const LoginPage() ) ;
     
      default: return _errorRoute();

    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context){
      return Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('The provided route not exist in lib/src/route_generator.dart'),
        ),
      );
    });
  }
}