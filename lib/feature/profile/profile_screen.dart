import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky_app/core/constant/storage_key.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/theme/theme_controller.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/feature/profile/user_details_screen.dart';
import 'package:tasky_app/feature/welcome/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  late String quote;
  String? imagePath;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    setState(() {
      userName = PreferencesManager().getString(StorageKey.userName);
      quote =
          PreferencesManager().getString(StorageKey.quote) ??
          "One task at a time. One step closer.";
      imagePath = PreferencesManager().getString(StorageKey.imagePath);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator(color: Color(0xFFFFFCFC)))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Profile Screen",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: imagePath != null
                                ? FileImage(File(imagePath!))
                                : AssetImage(
                                    "assets/images/Leading element.png",
                                  ),
                            radius: 60,
                          ),
                          Positioned(
                            child: GestureDetector(
                              onTap: () {
                                showImagePicker(context, (file) {
                                  saveImagePath(file);
                                  setState(() {
                                    imagePath = file.path;
                                  });
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: ThemeController.isDark()
                                        ? Color(0xFF282828)
                                        : Color(0xFFFFFFFF),
                                    width: 2,
                                  ),
                                  color: ThemeController.isDark()
                                      ? Color(0xFF282828)
                                      : Color(0xFFFFFFFF),
                                ),
                                child: Icon(Icons.camera_alt, size: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userName ?? "",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quote,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Profile Info",

                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 19),

                ListTile(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(
                          username: userName ?? "",
                          quote: quote,
                        ),
                      ),
                    );
                    if (result != null && result) {
                      loadUserData();
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text("User Details"),
                  leading: CustomSvgPicture(imgPath: "person"),
                  trailing: SvgPicture.asset(
                    "assets/images/arrow_back.svg",
                    colorFilter: ColorFilter.mode(
                      ThemeController.isDark()
                          ? Color(0xFFC6C6C6)
                          : Color(0xFF3A4640),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Divider(thickness: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Dark Mode"),
                  leading: CustomSvgPicture(imgPath: "theme"),
                  trailing: ValueListenableBuilder<ThemeMode>(
                    valueListenable: ThemeController.themeNotifier,
                    builder: (context, value, child) => Switch(
                      value: value == ThemeMode.dark,
                      onChanged: (value) async {
                        ThemeController.toggleTheme();
                      },
                    ),
                  ),
                ),
                Divider(thickness: 1),
                ListTile(
                  onTap: () async {
                    PreferencesManager().remove(StorageKey.userName);
                    PreferencesManager().remove(StorageKey.quote);
                    PreferencesManager().remove(StorageKey.tasks);
                    PreferencesManager().remove(StorageKey.imagePath);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (route) => false,
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text("Log Out"),
                  leading: CustomSvgPicture(imgPath: "log_out"),
                  trailing: SvgPicture.asset(
                    "assets/images/arrow_back.svg",
                    colorFilter: ColorFilter.mode(
                      ThemeController.isDark()
                          ? Color(0xFFC6C6C6)
                          : Color(0xFF3A4640),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  saveImagePath(XFile file) async {
    final dirApp = await getApplicationDocumentsDirectory();
    final imagePath = await File(
      file.path,
    ).copy("${dirApp.path}/${file.name}}");

    PreferencesManager().setString(StorageKey.imagePath, imagePath.path);
  }
}

showImagePicker(BuildContext context, Function(XFile) onSelectedImage) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(
        "Selected Image Source",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      children: [
        SimpleDialogOption(
          onPressed: () async {
            Navigator.pop(context);
            final image = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (image != null) {
              onSelectedImage(image);
            }
          },
          padding: EdgeInsets.all(16),
          child: Row(
            children: [Icon(Icons.image), SizedBox(width: 16), Text("Gallery")],
          ),
        ),
        SimpleDialogOption(
          onPressed: () async {
            Navigator.pop(context);
            final image = await ImagePicker().pickImage(
              source: ImageSource.camera,
            );
            if (image != null) {
              onSelectedImage(image);
            }
          },
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.camera_alt),
              SizedBox(width: 16),
              Text("Camera"),
            ],
          ),
        ),
      ],
    ),
  );
}
