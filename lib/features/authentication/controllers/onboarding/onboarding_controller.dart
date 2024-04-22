import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/register/register.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {

  static OnboardingController get instance => Get.find();


  PageController pageController = PageController();
  Rx<int> currentIndex = 0.obs;

  void updatePageIndicator(index) {
    currentIndex.value = index;
  }

  void dotNavigationClick(index) {
    currentIndex.value = index;
    pageController.jumpToPage(currentIndex.value);
  }

  void nextPage() {
    if (currentIndex.value == 2) {
      // Jump to another page
      Get.offAll(RegisterScreen());
    } else {
      currentIndex.value++;
      pageController.jumpToPage(currentIndex.value);
    }
  }

  void skipPage() {
    currentIndex.value = 2;
    pageController.jumpToPage(currentIndex.value);
  }


}