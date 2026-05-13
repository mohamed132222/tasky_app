import 'package:flutter/material.dart';
import 'package:tasky_app/core/constant/app_size.dart';
import 'package:tasky_app/core/constant/storage_key.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';

class UserDetailsScreen extends StatefulWidget {
  final String username;
  String? quote;

  UserDetailsScreen({super.key, required this.username, this.quote});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController motivationQuoteController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    motivationQuoteController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController.value = TextEditingValue(text: widget.username);
    motivationQuoteController.value = TextEditingValue(
      text: widget.quote ?? "",
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.pw16,
          vertical: AppSize.ph16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                title: "User Name",
                controller: usernameController,
                hintText: "Enter User Name",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter user name";
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSize.ph24),
              CustomTextFormField(
                title: "Motivation Quote",
                controller: motivationQuoteController,
                hintText: "One task at a time. One step closer.",
                maxline: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter Motivation Quote";
                  }
                  return null;
                },
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.ph16,
                  horizontal: AppSize.pw16,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      //save data {shared preferences}

                      await PreferencesManager().setString(
                        StorageKey.quote,
                        motivationQuoteController.value.text,
                      );
                      await PreferencesManager().setString(
                        StorageKey.userName,
                        usernameController.value.text,
                      );
                      Navigator.of(context).pop(true);
                    }
                  },

                  child: Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: AppSize.f14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      color: Color(0xFFFFFCFC),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
