import 'package:flutter/material.dart';
import 'package:instagram_flutter/blocs/account_bloc.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';

import '../utils/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AccountBloc _accountBloc = AccountBloc();



  onClickForgot() {
    if(_accountBloc.isValidForGotPassword(_emailController.text.trim())) {
      _forgotSelected();
    }
  }
  void _forgotSelected() async {
    String res = await AuthMethods().forgotPassword(_emailController.text.trim());
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      showSnackBar('Please check in your email', context);
    }}
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _accountBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(
              height: 60,
            ),
            Text(
              'Forgot password',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              'Please enter your email in box',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white),
            ),
            const SizedBox(height: 20,),
            StreamBuilder(
              stream: _accountBloc.emailStream,
              builder: (context, snapshot) => TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.text,
                  erroText: snapshot.hasError ? snapshot.error.toString() : ''),
            ),
            const SizedBox(height: 20,),
            InkWell(
              onTap: () {
                onClickForgot();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                width: double.infinity,
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.blueAccent),
                // child: _isLoading
                //     ? const LinearProgressIndicator()
                //     : const Text(
                //   'Sign up',
                //   style: TextStyle(
                //       fontWeight: FontWeight.w600, fontSize: 16),
                // ),
                child: const Text(
                    'Continue',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
