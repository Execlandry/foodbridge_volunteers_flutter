import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/round_button.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_state.dart';
import 'package:foodbridge_volunteers_flutter/view/login/login_view.dart';
import '../../common_widget/round_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtFirstName = TextEditingController();
  final TextEditingController txtLastName = TextEditingController();
  final TextEditingController txtMobile = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtConfirmPassword = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  void dispose() {
    txtFirstName.dispose();
    txtLastName.dispose();
    txtMobile.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registration Successful")),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
          }

          if (state is AuthFailure) {
            _showErrorSnackbar(state.error);
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 64),
                Text(
                  "Sign Up",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Add your details to sign up",
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25),
                _buildInputFields(),
                const SizedBox(height: 30),
                _buildSignUpButton(),
                _buildLoginRedirect(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        RoundTextfield(
          hintText: "First Name",
          controller: txtFirstName,
          validator: (value) =>
              value!.trim().isEmpty ? 'Enter your first name' : null,
        ),
        const SizedBox(height: 25),
        RoundTextfield(
          hintText: "Last Name",
          controller: txtLastName,
          validator: (value) =>
              value!.trim().isEmpty ? 'Enter your last name' : null,
        ),
        const SizedBox(height: 25),
        RoundTextfield(
          hintText: "Email",
          controller: txtEmail,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            final email = value!.trim();
            return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)
                ? null
                : 'Enter valid email';
          },
        ),
        const SizedBox(height: 25),
        RoundTextfield(
          hintText: "Mobile No",
          controller: txtMobile,
          keyboardType: TextInputType.phone,
          validator: (value) {
            final val = value!.trim();
            return RegExp(r'^[0-9]{10}$').hasMatch(val)
                ? null
                : 'Enter valid 10-digit mobile number';
          },
        ),
        const SizedBox(height: 25),
        _buildPasswordField(),
        const SizedBox(height: 25),
        _buildConfirmPasswordField(),
      ],
    );
  }

  Widget _buildPasswordField() {
    return RoundTextfield(
      hintText: "Password",
      controller: txtPassword,
      obscureText: _isPasswordHidden,
      validator: (value) =>
          value!.trim().length >= 6 ? null : 'Minimum 6 characters',
      suffixIcon: IconButton(
        icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return RoundTextfield(
      hintText: "Confirm Password",
      controller: txtConfirmPassword,
      obscureText: _isConfirmPasswordHidden,
      validator: (value) =>
          value == txtPassword.text ? null : 'Passwords do not match',
      suffixIcon: IconButton(
        icon: Icon(
          _isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () => setState(
            () => _isConfirmPasswordHidden = !_isConfirmPasswordHidden),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return RoundButton(
          title: "Sign Up",
          isLoading: state is AuthLoading,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (txtPassword.text != txtConfirmPassword.text) {
                _showErrorSnackbar('Passwords do not match');
                return;
              }

              context.read<AuthBloc>().add(
                    RegisterRequestedUserEvent(
                      firstName: txtFirstName.text.trim(),
                      lastName: txtLastName.text.trim(),
                      email: txtEmail.text.trim(),
                      mobno: txtMobile.text.trim(),
                      password: txtPassword.text.trim(),
                    ),
                  );
            }
          },
        );
      },
    );
  }

  Widget _buildLoginRedirect() {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already have an Account? ",
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "Login",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
