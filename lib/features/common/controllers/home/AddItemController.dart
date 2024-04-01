import 'package:get/get.dart';

class AddItemController extends GetxController {

  Rx<int> count = 1.obs;

  void addCounter() {
    count.value++;
  }

  void minCounter() {
    if (count > 1) {
      count.value--;
    }
  }
}