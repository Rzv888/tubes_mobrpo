import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/features/common/screens/history/main.dart';
import 'package:flutter_tubes_galon/features/common/screens/home/home.dart';
import 'package:flutter_tubes_galon/features/common/screens/chat/chat.dart';
import 'package:flutter_tubes_galon/features/common/screens/history/history.dart';
import 'package:flutter_tubes_galon/features/common/screens/order/order.dart';
import 'package:flutter_tubes_galon/features/common/screens/search/search.dart';
import 'package:flutter_tubes_galon/utils/constants/colors.dart';
import 'package:flutter_tubes_galon/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:iconsax/iconsax.dart';

class MainMenu extends StatefulWidget {
  MainMenu({
    super.key,
  });

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int currIndex = 0;

  PageController pageController = PageController();

  final mainMenuController = Get.put(MainMenuController());

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Obx(
          () => mainMenuController.screens[mainMenuController.currIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          iconSize: 20,
          backgroundColor: isDark ? AppColors.light : AppColors.dark,
          currentIndex: mainMenuController.currIndex.value,
          unselectedItemColor: isDark ? AppColors.light : AppColors.dark,
          selectedItemColor: AppColors.primary,
          onTap: (page) => mainMenuController.currIndex.value = page,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.message),
              label: "Obrolan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.search_normal),
              label: "Cari",
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.receipt_1),
              label: "Pesanan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.clock),
              label: "Riwayat",
            )
          ],
        ),
      ),
    );
  }
}

class MainMenuController extends GetxController {
  final Rx<int> currIndex = 0.obs;

  List<Widget> screens = [
    HomeScreen(),
    ChatScreen(),
    SearchScreen(),
    OrderScreen(),
    GalonPurchaseHistoryPage()
  ];
}
