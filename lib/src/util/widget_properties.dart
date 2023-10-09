import 'package:flutter/material.dart';
import 'app_colors.dart';

class WidgetCustomProperties {

  static InputDecoration customInputDecoration({required String hintText}) {
    return  InputDecoration(
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      counterStyle: const TextStyle(color: Colors.black),
      focusColor: Colors.white,
      hoverColor: Colors.white,
    );
  }

  static InputDecoration customPasswordInputDecoration({required GestureDetector gestureDetector}) {
    return  InputDecoration(
      suffixIcon: gestureDetector,
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
      ),
      hintText: '',
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
      counterStyle: const TextStyle(color: Colors.black),
      focusColor: Colors.white,
      hoverColor: Colors.white,
    );
  }

}
