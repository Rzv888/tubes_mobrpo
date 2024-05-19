import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/common/styles/spacing_styles.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/auth_service.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/register/register.dart';
import 'package:flutter_tubes_galon/features/common/screens/home/home.dart';
import 'package:flutter_tubes_galon/main_menu.dart';
import 'package:flutter_tubes_galon/utils/constants/colors.dart';
import 'package:flutter_tubes_galon/utils/constants/sizes.dart';
import 'package:get/get.dart';
// import 'package:flutter_tubes_galon/utils/helpers/helper_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController email_controller = TextEditingController();
    TextEditingController password_controller = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: AppSpacingStyle.paddingWithAppBarHeight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logos/dark-logo.png',
                width: 200,
              ),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),
              const Text(
                "Masuk",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 20),
              ),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),
              TextField(
                cursorColor: Colors.blueAccent,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Colors.lightBlue,
                            style: BorderStyle.solid))),
              ),
              const SizedBox(height: 20.0),
              TextField(
                obscureText: true,
                cursorColor: Colors.blueAccent,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Colors.lightBlue,
                            style: BorderStyle.solid))),
              ),
              const SizedBox(height: 20.0),
              (isLoading)
                  ? Text("Loading")
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await AuthService().login(email_controller.text,
                                password_controller.text, context);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: const Text("Masuk"))),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),
              RichText(
                  text: TextSpan(
                      text: "Belum punya akun?",
                      style: Theme.of(context).textTheme.labelLarge,
                      children: [
                    TextSpan(
                        text: " Daftar",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .apply(color: AppColors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(const RegisterScreen());
                          })
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
