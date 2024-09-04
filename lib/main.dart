import 'package:flutter/material.dart';
import 'package:tudo_app/core/app.dart';
import 'package:tudo_app/injections.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}
