import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 24),
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
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      //save data {shared preferences}

                      await PreferencesManager().setString(
                        "quote",
                        motivationQuoteController.value.text,
                      );
                      await PreferencesManager().setString(
                        "username",
                        usernameController.value.text,
                      );
                      Navigator.of(context).pop(true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 42),
                  ),
                  child: Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 14,
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
