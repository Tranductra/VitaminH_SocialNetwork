import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/blocs/account_bloc.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';

import '../reponsive/mobile_screen_layout.dart';
import '../reponsive/reponsive_layout_screen.dart';
import '../reponsive/web_screen_layout.dart';
import 'forgot_password_sceen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  void selectImage() async {
    File? im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  final AccountBloc _accountBloc = AccountBloc();

  onClickSignUp() {
    if (_accountBloc.isValidSignup(
        _usernameController.text.trim(),
        _bioController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim())) {
      _signUpSelected();
    }
  }

  void _signUpSelected() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      username: _usernameController.text,
      bio: _bioController.text,
      email: _emailController.text,
      password: _passwordController.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ReponsiveLayout(
                  mobieScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout())));
    }
  }

  void _navigatorLogIn() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 42,
              ),
              //svg image
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.white, // Change to your desired color
                  BlendMode.srcIn,
                ),
                child: ColorFiltered(
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
              ),
              const SizedBox(
                height: 44,
              ),
              //cicular widget to accept and show our selected file
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: FileImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg'),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: () {
                          selectImage();
                        },
                      ))
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              //text field input for username
              StreamBuilder(
                stream: _accountBloc.usernameStream,
                builder: (context, snapshot) => TextFieldInput(
                    textEditingController: _usernameController,
                    hintText: 'Enter your username',
                    textInputType: TextInputType.text,
                    erroText: snapshot.hasError ? snapshot.error.toString() : ''
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              //text field input for bio
              StreamBuilder(
                stream: _accountBloc.bioStream,
                builder: (context, snapshot) => TextFieldInput(
                    textEditingController: _bioController,
                    hintText: 'Enter your bio',
                    textInputType: TextInputType.text,
                    erroText: snapshot.hasError ? snapshot.error.toString() : ''),
              ),
              const SizedBox(
                height: 5,
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
                    erroText: snapshot.hasError ? snapshot.error.toString() : ''),
              ),
              const SizedBox(
                height: 5,
              ),
              //button login
              InkWell(
                onTap: () {
                  onClickSignUp();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Colors.blueAccent),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Sign up',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(
                height: 52,
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
                    child: const Text("Have a account? "),
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigatorLogIn();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Log in.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
