import 'package:flutter/material.dart';
import 'package:tasky_app/core/constant/app_size.dart';
import 'package:tasky_app/core/constant/storage_key.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';
import 'package:tasky_app/feature/navigation/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.pw16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: AppSize.ph18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomSvgPicture(
                      imgPath: "logo",
                      withFilterColor: false,
                      height: AppSize.h42,
                      width: AppSize.w42,
                    ),
                    SizedBox(width: AppSize.pw16),
                    Text(
                      "Tasky",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                SizedBox(height: AppSize.ph116),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome To Tasky ",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(width: AppSize.pw8),
                    CustomSvgPicture(
                      imgPath: "wave_hand",
                      withFilterColor: false,
                      width: AppSize.w28,
                      height: AppSize.h28,
                    ),
                  ],
                ),
                SizedBox(height: AppSize.ph10),
                Text(
                  "Your productivity journey starts here.",
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(fontSize: AppSize.f16),
                ),
                SizedBox(height: AppSize.ph24),
                CustomSvgPicture(
                  imgPath: "welcome_image",
                  withFilterColor: false,
                  height: AppSize.h204,
                  width: AppSize.w204,
                ),

                SizedBox(height: AppSize.ph28),
                CustomTextFormField(
                  title: "Full Name",
                  controller: controller,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                  hintText: "e.g. Sarah Khalid",
                ),

                SizedBox(height: AppSize.ph24),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await PreferencesManager().setString(
                        StorageKey.userName,
                        controller.value.text,
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter your name"),
                          elevation: 10,
                          backgroundColor: Color(0xFF15B86C),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(100),
                    ),
                  ),
                  child: Text(
                    "Let’s Get Started",
                    style: TextStyle(
                      fontSize: AppSize.f16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
