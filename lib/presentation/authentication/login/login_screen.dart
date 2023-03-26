import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karyakram/presentation/authentication/blocs/login/login_cubit.dart';
import 'package:karyakram/presentation/authentication/components/custom_auth_button.dart';
import 'package:karyakram/presentation/authentication/register/register_screen.dart';
import 'package:karyakram/presentation/base/base_page.dart';
import 'package:karyakram/presentation/shared_components/dialog_utils.dart';

import '../components/custom_input.dart';
import '../components/page_heading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  final _loginFormKey = GlobalKey<FormState>();
  late TextEditingController _email, _password;
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is LoginLoading) {
              DialogUtils.showLoadingDialog(context);
            }
            if (state is LoginSuccess) {
              Navigator.of(context).pop();
              bool response = await DialogUtils.showSuccessDialog(
                    context,
                    'You have successfully logged in',
                  ) ??
                  false;
              if (response && mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const BasePage()),
                  (route) => route.isCurrent,
                );
              }
            }
            if (state is LoginFailure) {
              if (mounted) {
                Navigator.of(context).pop();
                DialogUtils.showErrorDialog(
                  context,
                  'Login Failed',
                  state.message,
                );
              }
            }
          },
          child: Column(
            children: [
              Image.asset(
                'assets/images/login.png',
                height: MediaQuery.of(context).size.height * 0.26,
                width: size.width,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          const PageHeading(
                            title: 'Log-in',
                          ),
                          CustomInputField(
                              controller: _email,
                              labelText: 'Email',
                              hintText: 'Your email id',
                              validator: (textValue) {
                                if (textValue == null || textValue.isEmpty) {
                                  return 'Email is required!';
                                }
                                // if(!EmailValidator.validate(textValue)) {
                                //   return 'Please enter a valid email';
                                // }
                                return null;
                              }),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomInputField(
                            controller: _password,
                            labelText: 'Password',
                            hintText: 'Your password',
                            obscureText: true,
                            suffixIcon: true,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Password is required!';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomAuthButton(
                            innerText: 'Login',
                            onPressed: () {
                              if (_loginFormKey.currentState!.validate()) {
                                BlocProvider.of<LoginCubit>(context).login(
                                  email: _email.text.trim(),
                                  password: _password.text,
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            width: size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account ? ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff939393),
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterScreen()))
                                  },
                                  child: const Text(
                                    'Sign-up',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff748288),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
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
