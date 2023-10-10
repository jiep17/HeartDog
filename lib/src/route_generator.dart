import 'package:flutter/material.dart';
import 'package:heartdog/src/pages/bluetooth/scan_devices_page.dart';
import 'package:heartdog/src/pages/control_pages.dart';
import 'package:heartdog/src/pages/login_page.dart';
import 'package:heartdog/src/pages/monitoring/ecg_graph_pages.dart';
import 'package:heartdog/src/pages/profile/edit_info_page.dart';
import 'package:heartdog/src/pages/profile/edit_mydog_page.dart';
import 'package:heartdog/src/pages/profile/register_mydog_page.dart';
import 'package:heartdog/src/pages/register_user_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const LoginPage());
      //case '/home': return MaterialPageRoute(builder: (context) => const HomePage());
      case '/controlpages':
        return MaterialPageRoute(builder: (context) => const ControlPages());
      case '/edit_info_page':
        return MaterialPageRoute(
            builder: (context) => const EditPersonalInfoPage());
      case '/create_mydog_page':
        return MaterialPageRoute(
            builder: (context) => const RegisterMyDogPage());
      case '/edit_mydog_page':
        final dogId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => EditMyDogPage(dogId: dogId),
        );
      case '/register_user':
        return MaterialPageRoute(
            builder: (context) => const RegisterUserPage());
      case '/ecg_graph':
        return MaterialPageRoute(builder: (context) => ECGGraphPage());
      case '/scan_devices':
        return MaterialPageRoute(
            builder: (context) => ScanDevicesPage(),
            settings: const RouteSettings(name: '/scan_devices'));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
              'The provided route not exist in lib/src/route_generator.dart'),
        ),
      );
    });
  }
}
