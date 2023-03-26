import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karyakram/presentation/authentication/blocs/register/register_cubit.dart';
import 'package:karyakram/presentation/authentication/components/custom_auth_button.dart';

import '../../shared_components/dialog_utils.dart';
import '../components/custom_input.dart';
import '../components/page_heading.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _signupFormKey = GlobalKey<FormState>();
  late TextEditingController _name, _email, _password;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: SingleChildScrollView(
          child: BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) async {
              if (state is RegisterLoading) {
                DialogUtils.showLoadingDialog(context);
              }
              if (state is RegisterSuccess) {
                Navigator.of(context).pop();
                bool response = await DialogUtils.showSuccessDialog(
                      context,
                      'You have successfully logged in',
                    ) ??
                    false;
                if (response && mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => route.isCurrent,
                  );
                }
              }
              if (state is RegisterFailure) {
                if (mounted) {
                  Navigator.of(context).pop();
                  DialogUtils.showErrorDialog(
                    context,
                    'Register Failed',
                    state.message,
                  );
                }
              }
            },
            child: Form(
              key: _signupFormKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/welcome.png',
                    height: MediaQuery.of(context).size.height * 0.26,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const PageHeading(
                          title: 'Sign-up',
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomInputField(
                            controller: _name,
                            labelText: 'Name',
                            hintText: 'Your name',
                            isDense: true,
                            validator: (value) {
                              if (value != null &&
                                  value.trimRight().split(" ").length < 2) {
                                return "Please enter last name";
                              } else if (value == null || value.isEmpty) {
                                return "Please enter first and last name";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomInputField(
                            controller: _email,
                            labelText: 'Email',
                            hintText: 'Your email id',
                            isDense: true,
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
                          isDense: true,
                          obscureText: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Password is required!';
                            }
                            return null;
                          },
                          suffixIcon: true,
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        CustomAuthButton(
                          innerText: 'Signup',
                          onPressed: () {
                            if (_signupFormKey.currentState!.validate()) {
                              BlocProvider.of<RegisterCubit>(context).register(
                                email: _email.text.trim(),
                                password: _password.text,
                                fullName: _name.text.trim(),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account ? ',
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
                                              const LoginScreen()))
                                },
                                child: const Text(
                                  'Log-in',
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
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
