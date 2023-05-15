

import 'package:flutter/material.dart';
import 'package:heartdog/src/pages/control_pages.dart';
import 'package:heartdog/src/pages/home_page.dart';
import 'package:heartdog/src/pages/login_page.dart';
import 'package:heartdog/src/pages/profile/edit_info_page.dart';
import 'package:heartdog/src/pages/profile/edit_mydog_page.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case '/':return MaterialPageRoute(builder: (context)=> const LoginPage() ) ;
      //case '/home': return MaterialPageRoute(builder: (context) => const HomePage());
      case '/controlpages': return MaterialPageRoute(builder: (context) => const ControlPages());
      case '/edit_info_page': return MaterialPageRoute(builder: (context) => const EditPersonalInfoPage());
      case '/edit_mydog_page': return MaterialPageRoute(builder: (context) => const EditMyDogPage());
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