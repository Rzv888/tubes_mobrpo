import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/utils/constants/sizes.dart';
import 'package:flutter_tubes_galon/utils/helpers/helper_functions.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    this.image,
    this.title,
    this.subtitle,
  });
  final image, title, subtitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.defaultSpace*1.2),
      child: Column(
        children: [
          Image.asset(
            image,
            width: AppHelperFunctions.screenWidth() * 0.8,
            height: AppHelperFunctions.screenHeight() * 0.6,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: AppSizes.spaceBtwItems,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}