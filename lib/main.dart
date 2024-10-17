import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/app_config/page_routes.dart';
import 'package:saloon_pos/app_config/shared_preferences_config.dart';
import 'package:saloon_pos/features/account/view_model/account_view_model.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import 'app_config/my_http_overrides.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesRepo.initialize();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? loggedIn;
  bool? isAdminU;

  final _prefs=SharedPreferencesRepo.instance;
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoggedIn();
    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
      });
    });
  }




  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }
  checkLoggedIn()async{
    setState(() {
      loggedIn=_prefs!.checkLoggedIn();
      isAdminU=_prefs!.checkAdminUSer();
    });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AccountViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => PosScreenViewModel(),
        ),


      ],
      child: GetMaterialApp(
        title: 'Saloon POS',
        defaultTransition: Transition.noTransition, //this would be the solution
        transitionDuration: const Duration(seconds: 0),
        getPages: getPages(),
        theme: ThemeData(
          
          

          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: (loggedIn!&&isAdminU!)?'/reportScreen':loggedIn!?'/posScreen':'/pinScreen',
      ),
    );
  }
}


