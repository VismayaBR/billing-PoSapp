import 'package:get/get.dart';
import 'package:saloon_pos/features/account/view/log_in_page.dart';
import 'package:saloon_pos/features/account/view/mobile_login.dart';
import 'package:saloon_pos/features/account/view/mpin_login.dart';
import 'package:saloon_pos/features/pos/view/AddEmployeeScreen.dart';
import 'package:saloon_pos/features/pos/view/AddServiceScreen.dart';
import 'package:saloon_pos/features/pos/view/checkout_page_mobile.dart';
import 'package:saloon_pos/features/pos/view/pos_screen.dart';
import 'package:saloon_pos/features/pos/view/report_screen.dart';



List<GetPage<dynamic>> getPages() {
  return[
    GetPage(
      name: '/loginScreen',
      page: () => const LoginPage(),
    ),
    GetPage(
      name: '/pinScreen',
      page: () => const PinLogin(),
    ),
    GetPage(
      name: '/mobileScreen',
      page: () => const MobileLoginPage(),
    ),
    GetPage(
      name: '/posScreen',
      page: () => const PosScreen(),
    ),
    GetPage(
      name: '/reportScreen',
      page: () => const ReportScreen(),
    ),
    GetPage(
      name: '/checkoutScreen',
      page: () => const CheckoutPageMobile(),
    ),
    GetPage(
      name: '/addServiceScreen',
      page: () => const AddServiceScreen(),
    ),
    GetPage(
      name: '/addEmployeeScreen',
      page: () => const AddEmployeeScreen(),
    ),
  ];
}