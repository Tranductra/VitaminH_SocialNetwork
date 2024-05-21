import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/blocs/account_bloc.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/screens/forgot_password_sceen.dart';
import 'package:instagram_flutter/screens/signup_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';
import '../reponsive/mobile_screen_layout.dart';
import '../reponsive/reponsive_layout_screen.dart';
import '../reponsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final AccountBloc _accountBloc = AccountBloc();

  _onClickLogin() {
    if (_accountBloc.isValidLogin(
        _emailController.text.trim(), _passwordController.text.trim())) {
      _loginUser();
    }
  }

  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().logInUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ReponsiveLayout(
                  mobieScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout())));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _navigatorSignUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            //svg image
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white, // Change to your desired color
                BlendMode.srcIn,
              ),
              child: Image.asset(
                'assets/logo.png',
                height: 64,
                // Specify your SVG image path here
              ),
            ),
            const SizedBox(
              height: 64,
            ),
            //text field input for email
            StreamBuilder(
              stream: _accountBloc.emailStream,
              builder: (context, snapshot) => TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.text,
                  erroText: snapshot.hasError ? snapshot.error.toString() : ''),
            ),
            const SizedBox(
              height: 5,
            ),
            //text field input for password
            StreamBuilder(
              stream: _accountBloc.passwordStream,
              builder: (context, snapshot) => TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
                erroText: snapshot.hasError ? snapshot.error.toString() : '',
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            //button login
            InkWell(
              onTap: () {
                _onClickLogin();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                width: double.infinity,
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.blueAccent),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text(
                        'Log in',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPasswordScreen(),));
                },
                child: const Text('Forgot password?', style: TextStyle(fontWeight: FontWeight.bold),)),
            //transitioning to signing up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("Don't have a account? "),
                ),
                GestureDetector(
                  onTap: () {
                    _navigatorSignUp();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Sign up.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
