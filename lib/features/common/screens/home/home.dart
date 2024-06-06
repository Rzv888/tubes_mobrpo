import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tubes_galon/data/list_galon.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/AddItemController.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/order_service.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/product_service.dart';
import 'package:flutter_tubes_galon/features/profile/screens/profile.dart';
import 'package:flutter_tubes_galon/features/saldo/screens/saldo.dart';
import 'package:flutter_tubes_galon/theme.dart';
import 'package:flutter_tubes_galon/utils/constants/colors.dart';
import 'package:flutter_tubes_galon/utils/constants/sizes.dart';
import 'package:flutter_tubes_galon/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _namalengkap = "";
  int _saldo = 0;
  int _level = 0;
  int _xp = 0;
  int currIndex = 0;
  Future<dynamic> refreshDataUser(context) async {
  try {
    final user = await UserService().getCurrentUser();
    print(("cek" + user.toString()));
    _namalengkap = user["nama_lengkap"];
    _level = user['level'];
    _xp = user['xp'];
    _saldo = user['saldo'];
    print(_saldo.toString() + "saldo: ");
    setState(() {});
    return user;
  }catch (e) {
      print(e);      
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    refreshDataUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(const ProfileScreen());
                    },
                    child: Image.asset(
                      "assets/img/profile.png",
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang",
                        style: GoogleFonts.kumbhSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: greyColor),
                      ),
                      Text(
                        _namalengkap,
                        style: GoogleFonts.kumbhSans(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: primaryColor),
                      )
                    ],
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(
                    Icons.notifications,
                    color: primaryColor,
                    size: 40,
                  ),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                        color: redColor, shape: BoxShape.circle),
                    child: Center(
                        child: Text(
                      "1",
                      style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Center(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(const SaldoScreen());
                    },
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/img/wallet.png",
                              width: 35,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Saldo",
                                  style: GoogleFonts.boogaloo(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.dark),
                                ),
                                FutureBuilder(
                                    future: refreshDataUser(context),
                                    builder: (context, snapshot) {
                                      return Text(
                                        "Rp. " + _saldo.toString(),
                                        style: GoogleFonts.boogaloo(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.dark),
                                      );
                                    })
                              ],
                            )
                          ],
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Level " + _level.toString(),
                          style: GoogleFonts.boogaloo(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Container(
                          height: 10,
                          width: 100,
                          decoration: const BoxDecoration(
                              color: Color(0xffF3EDED),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        Text(
                          _xp.toString() + "/200",
                          style: GoogleFonts.boogaloo(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        )
                      ])
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ListItems(),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class ListItems extends StatefulWidget {
  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  final products = ProductService().getAllProducts();

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final itemController = Get.put(AddItemController());
    return FutureBuilder(
        future: products,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
            );
          } else {
            return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 150),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.all(AppSizes.md),
                              child: Column(
                                children: [
                                  Image.asset(
                                    snapshot.data[index]["image"],
                                    width: 100,
                                  ),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          itemController.addCounter();
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: AppColors.primary,
                                          child: Icon(Iconsax.add),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Obx(() => Text(
                                            "${itemController.count.value}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .apply(
                                                    color: isDark
                                                        ? AppColors.light
                                                        : AppColors.dark),
                                          )),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            itemController.minCounter();
                                          });
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: AppColors.primary,
                                          child: Icon(Iconsax.minus),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            OrderService().insertOrder(
                                                snapshot.data[index]['id'],
                                                itemController.count.value,
                                                200000, context);
                                                SnackBar(content: Text("Order Berhasil Dibuat"));
                                          },
                                          child: Text(
                                            "Pesan",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          )))
                                ],
                              ),
                            );
                          }).whenComplete(() => itemController.count.value = 1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: primaryColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), //color of shadow
                              spreadRadius: 1, //spread radius
                              blurRadius: 7, // blur radius
                              offset: Offset(0, 2),
                            )
                          ]),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${snapshot.data[index]['nama_barang']}",
                              style: GoogleFonts.boogaloo(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: primaryColor),
                            ),
                            Image.asset(
                              snapshot.data[index]['image'],
                              width: 100,
                            ),
                            Text(
                              "Rp. ${snapshot.data[index]['harga_barang']}",
                              style: GoogleFonts.kumbhSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                          ]),
                    ),
                  );
                });
          }
        });
  }
}
