//flutter
import 'package:flutter/material.dart';
//package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_vol2/constants/routes.dart' as routes;
import 'package:sns_vol2/constants/strings.dart';
import 'package:sns_vol2/details/forget_password_text.dart';
import 'package:sns_vol2/details/rounded_button.dart';
import 'package:sns_vol2/details/rounded_password_field.dart';
import 'package:sns_vol2/details/rounded_text_field.dart';
//model
import 'package:sns_vol2/models/login_model.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginModel loginModel = ref.watch(loginProvider);
    final TextEditingController emailEditingCntoroller =
        TextEditingController(text: loginModel.email);
    final TextEditingController passwordEditingCntoroller =
        TextEditingController(text: loginModel.password);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          RoundedTextField(
            keybordType: TextInputType.emailAddress,
            onChanged: (text) => loginModel.email = text,
            controller: emailEditingCntoroller,
            color: Colors.grey.shade200,
            borderColor: Colors.black,
            hintText: mailAddressText,
          ),
          RoundedPasswordField(
              onChanged: (text) => loginModel.password = text,
              obscureText: loginModel.isObscure,
              passwordEditingController: passwordEditingCntoroller,
              toggleObscureText: () => loginModel.toggleIsObscure(),
              color: Colors.grey.shade200,
              borderColor: Colors.black),
          RoundedButton(
            onPressed: () async => await loginModel.login(context: context),
            widthRate: 0.35,
            color: Colors.black,
            text: loginTitle,
            textColor: Colors.white,
          ),
          TextButton(
              onPressed: () => routes.toSignUpPage(context: context),
              child: const Text(noAccountMsg)),
          const ForgetPasswordText()
        ],
      ),
    );
  }
}
