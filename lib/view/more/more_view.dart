import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/gradient_bg.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/section_header.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_state.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_state.dart';
import 'package:foodbridge_volunteers_flutter/view/login/welcome_view.dart';
import 'package:foodbridge_volunteers_flutter/view/more/about_us_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  late List<Map<String, dynamic>> _menuItems;
  final ImagePicker picker = ImagePicker();
  String? _profileImageBase64;

  final txtFirstname = TextEditingController();
  final txtEmail = TextEditingController();
  final txtMobile = TextEditingController();
  final txtAddress = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(FetchUserProfile());
    _loadProfileImage();
    _menuItems = [
      {
        "title": "About Us",
        "icon": Icons.info_outline,
        "action": (context) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutUsView()),
            ),
      },
      {
        "title": "Logout",
        "icon": Icons.exit_to_app,
        "action": (context) => _showLogoutDialog(context),
      },
    ];
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImage = prefs.getString('profile_image');
    if (savedImage != null) {
      setState(() {
        _profileImageBase64 = savedImage;
      });
    }
  }

  Future<void> _saveProfileImage(String base64Image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', base64Image);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Logout',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LoggedOutRequestedUserEvent());
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    txtFirstname.dispose();
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
      body: GradientBackground(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeView()),
                (route) => false,
              );
            }
            if (state is AuthFailure) {
              _showErrorSnackbar(state.error);
            }
          },
          child: BlocConsumer<UserProfileBloc, UserProfileState>(
            listener: (context, state) {
              if (state is UserProfileLoaded) {
                txtFirstname.text = state.user.firstName ?? '';
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
                child: Column(
                  children: [
                    const SizedBox(height: 46),
                    const SectionHeader(title: "Profile"),
                    const SizedBox(height: 20),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: _profileImageBase64 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.memory(
                                base64Decode(_profileImageBase64!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  TColor.placeholder.withOpacity(0.2),
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: TColor.placeholder,
                              ),
                            ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final XFile? pickedImage = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        if (pickedImage != null) {
                          final bytes = await pickedImage.readAsBytes();
                          final base64Image = base64Encode(bytes);
                          await _saveProfileImage(base64Image);
                          setState(() {
                            _profileImageBase64 = base64Image;
                          });
                        }
                      },
                      icon: Icon(Icons.edit, color: TColor.primary, size: 12),
                      label: Text("Edit Profile",
                          style: TextStyle(color: TColor.primary, fontSize: 12)),
                    ),
                    Text(
                      "Hi there ${txtFirstname.text}!",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: RoundTitleTextfield(
                        title: "Email",
                        hintText: "Enter Email",
                        keyboardType: TextInputType.emailAddress,
                        controller: txtEmail,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: RoundTitleTextfield(
                        title: "Mobile No",
                        hintText: "Enter Mobile No",
                        controller: txtMobile,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _menuItems.length,
                        itemBuilder: (context, index) {
                          final item = _menuItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: _buildMenuItem(
                              icon: item['icon'] as IconData,
                              title: item['title'] as String,
                              onTap: () => (item['action'] as Function)(context),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: TColor.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: TColor.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: TColor.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child:
              const Icon(Icons.chevron_right, size: 20, color: Colors.black54),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}