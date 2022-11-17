// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/home_layout/home.dart';
import 'package:shop_app/login/cubit/login_cubit.dart';
import 'package:shop_app/login/login/login_model.dart';
import 'package:shop_app/login/register/register.dart';
import 'package:shop_app/network/cach_helper.dart';
import 'package:shop_app/component/widgets.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSucsse) {
            if (state.loginModel.status = true) {
              if (LoginCubit.get(context).loginModel?.data?.token != null) {
                print(state.loginModel.data?.token);
                print(state.loginModel.message);

                CachHelper.saveData(
                        key: 'token', value: state.loginModel.data?.token)
                    .then((value) {
                  navigateAndReplace(context, HomeLayout());
                });
              }
            }  
            dialog(context: context, massage: state.loginModel.message);
          }
        },
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (BuildContext context, Widget? child) => Scaffold(
              appBar: AppBar(
                elevation: 0.0,
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.0.r),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LOGIN',
                            style: TextStyle(
                                fontSize: 40.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'please enter the email address';
                              }
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          defaultFormField(
                            controller: passwordController,
                            type: TextInputType.number,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Password is too short';
                              }
                            },
                            isPassword: LoginCubit.get(context).isPasswordShow,
                            label: 'Password',
                            onSubmit: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            prefix: Icons.lock_outline,
                            suffix: LoginCubit.get(context).suffix,
                            suffixPressed: () {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ConditionalBuilder(
                            condition: state is! LoginLoading,
                            fallback: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            builder: (context) => Container(
                              width: double.infinity,
                              height: 55.h,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: MaterialButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              TextButton(
                                onPressed: () => navigateTo(
                                  context,
                                  RegisterScreen(),
                                ),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  //   bool _showPassword = false;

  // Widget _buildPasswordTextField() {
  //   return TextField(
  //     obscureText: !this._showPassword,
  //     decoration: InputDecoration(
  //       labelText: 'password',
  //       prefixIcon: const Icon(Icons.security),
  //       suffixIcon: IconButton(
  //         icon: Icon(
  //           Icons.remove_red_eye,
  //           color: this._showPassword ? Colors.blue : Colors.grey,
  //         ),
  //         onPressed: () {
  //           setState(() => this._showPassword = !this._showPassword);
  //         },
  //       ),
  //     ),
  //   );
  // }
}
