import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tubes_galon/data/list_galon.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/AddItemController.dart';
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
  int currIndex = 0;

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
                        "Ganjar Prabowo",
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
                                Text(
                                  "Rp. 5.000",
                                  style: GoogleFonts.boogaloo(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.dark),
                                )
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
                          "Level 1",
                          style: GoogleFonts.boogaloo(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Container(
                          height: 10,
                          width: 140,
                          decoration: const BoxDecoration(
                              color: Color(0xffF3EDED),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        Text(
                          "0/200",
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
          GestureDetector(
            onTap: () => {},
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                  color: const Color(0xffE0F9FF),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Lihat Semua",
                style: GoogleFonts.kumbhSans(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final itemController = Get.put(AddItemController());
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 150),
        itemCount: listGalon.length,
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
                            listGalon[index]['image'],
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
                                  onPressed: () {},
                                  child: Text(
                                    "Pesan",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
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
                      color: Colors.grey.withOpacity(0.5), //color of shadow
                      spreadRadius: 1, //spread radius
                      blurRadius: 7, // blur radius
                      offset: Offset(0, 2),
                    )
                  ]),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${listGalon[index]['nama']}",
                      style: GoogleFonts.boogaloo(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: primaryColor),
                    ),
                    Image.asset(
                      listGalon[index]['image'],
                      width: 100,
                    ),
                    Text(
                      "${listGalon[index]['harga']}",
                      style: GoogleFonts.kumbhSans(
                          fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ]),
            ),
          );
        });
  }
}
