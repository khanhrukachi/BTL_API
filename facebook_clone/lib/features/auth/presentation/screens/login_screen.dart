import 'package:facebook_clone/core/utils/utils.dart';
import 'package:facebook_clone/core/widgets/round_button_widget.dart';
import 'package:facebook_clone/core/widgets/round_text_field_widget.dart';
import 'package:facebook_clone/features/auth/presentation/screens/create_account_screen.dart';
import 'package:facebook_clone/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/core/constants/constants.dart';
import '/features/auth/utils/utils.dart';

final _formKey = GlobalKey<FormState>();

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);
      await ref.read(authProvider).signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // showToastMessage(text: "Success");

      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: Constants.defaultPadding,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                'assets/icons/fb_logo.png',
                width: 60,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    RoundTextFieldWidget(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 15),
                    RoundTextFieldWidget(
                      controller: _passwordController,
                      hintText: 'Password',
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      isPassword: true,
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 15),
                    RoundButtonWidget(onPressed: login, label: 'Login'),
                    const SizedBox(height: 15),
                    const Text(
                      'Forget Password',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  RoundButtonWidget(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        CreateAccountScreen.routeName,
                      );
                    },
                    label: 'Create new account',
                    color: Colors.transparent,
                  ),
                  Image.asset(
                    'assets/icons/meta.png',
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
