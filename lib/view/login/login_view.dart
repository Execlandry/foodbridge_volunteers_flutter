import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_state.dart';
import 'package:foodbridge_volunteers_flutter/view/main_tabview/main_tabview.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import 'reset_password_view.dart';
import 'sign_up_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainTabView()),
          );
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildLoginForm();
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              Text(
                "Login",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Add your details to login",
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 25),
              _buildEmailField(),
              const SizedBox(height: 25),
              _buildPasswordField(),
              const SizedBox(height: 25),
              _buildLoginButton(),
              const SizedBox(height: 4),
              _buildForgotPassword(),
              const SizedBox(height: 25),
              _buildSocialLogin(),
              const SizedBox(height: 20),
              _buildSignUpRedirect(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return RoundTextfield(
      hintText: "Your Email",
      controller: txtEmail,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => value!.contains('@') ? null : 'Enter valid email',
    );
  }

  Widget _buildPasswordField() {
    return RoundTextfield(
      hintText: "Password",
      controller: txtPassword,
      obscureText: _isPasswordHidden,
      validator: (value) => value!.isNotEmpty ? null : 'Enter password',
      suffixIcon: IconButton(
        icon: Image.asset(
          _isPasswordHidden ? "assets/img/hidden.png" : "assets/img/eye.png",
          width: 20,
          height: 20,
        ),
        onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return RoundButton(
          title: "Login",
          isLoading: state is AuthLoading,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<AuthBloc>().add(
                    LoginRequestedUserEvent(
                      email: txtEmail.text.trim(),
                      password: txtPassword.text.trim(),
                    ),
                  );
            }
          },
        );
      },
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResetPasswordView()),
        );
      },
      child: Text(
        "Forgot your password?",
        style: TextStyle(
          color: TColor.secondaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Text(
          "or",
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Login With",
          style: TextStyle(
            color: TColor.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 30),
        // Add your social login buttons here
      ],
    );
  }

  Widget _buildSignUpRedirect() {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpView()),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't have an Account? ",
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "Sign Up",
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
