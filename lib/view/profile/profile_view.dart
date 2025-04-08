import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/user_repository.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_state.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UserProfileBloc(userRepository: UserRepository())..add(FetchUserProfile()),
      child: const _ProfileViewBody(),
    );
  }
}

class _ProfileViewBody extends StatefulWidget {
  const _ProfileViewBody();

  @override
  State<_ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<_ProfileViewBody> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtMobile = TextEditingController();
  final txtAddress = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();

  @override
  void dispose() {
    txtName.dispose();
    txtEmail.dispose();
    txtMobile.dispose();
    txtAddress.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileLoaded) {
            txtName.text = state.user.name ?? '';
            txtEmail.text = state.user.email ?? '';
            txtMobile.text = state.user.mobno ?? '';
          }
        },
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserProfileError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 46),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Profile",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: TColor.placeholder,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    alignment: Alignment.center,
                    child: image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              File(image!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 65,
                            color: TColor.secondaryText,
                          ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      image = await picker.pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    icon: Icon(Icons.edit, color: TColor.primary, size: 12),
                    label: Text("Edit Profile",
                        style: TextStyle(color: TColor.primary, fontSize: 12)),
                  ),
                  Text(
                    "Hi there ${txtName.text}!",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Name",
                      hintText: "Enter a Username",
                      controller: txtName,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Email",
                      hintText: "Enter Email",
                      keyboardType: TextInputType.emailAddress,
                      controller: txtEmail,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Mobile No",
                      hintText: "Enter Mobile No",
                      controller: txtMobile,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RoundButton(
                      title: "Save",
                      onPressed: () {
                        // TODO: Add update logic here (API call or bloc event)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Save functionality not yet implemented.')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
