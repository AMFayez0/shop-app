// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/login/cubit/login_cubit.dart';
import 'package:shop_app/login/login/login.dart';
import 'package:shop_app/component/widgets.dart';
import 'package:shop_app/login/register/register_cubit.dart';

import '../../home_layout/home.dart';
import '../../network/cach_helper.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSucsse) {
            if (state.RegisterModel.status = true) {
              print(state.RegisterModel.message);

              if (RegisterCubit.get(context).registerModel?.data?.token !=
                  null) {
                CachHelper.saveData(
                  key: 'token',
                  value: state.RegisterModel.data!.token,
                ).then((value) {});
                navigateAndReplace(
                  context,
                  HomeLayout(),
                );
              } else {
                dialog(context: context, massage: state.RegisterModel.message);
                print(state.RegisterModel.message);
              }
            }
          }
        },
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (BuildContext context, Widget? child) => Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
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
                          'Create an Account',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          label: 'Enter your Name',
                          prefix: Icons.person_add_alt_1_outlined,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter the email address';
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.number,
                          label: 'number',
                          prefix: Icons.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone number';
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.number,
                          label: 'password',
                          prefix: Icons.lock_outlined,
                          isPassword: RegisterCubit.get(context).isPasswordShow,
                          suffix: RegisterCubit.get(context).suffix,
                          suffixPressed: () {
                            RegisterCubit.get(context)
                                .changePasswordVisibilityREG();
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        defaultFormField(
                          controller: conPasswordController,
                          type: TextInputType.number,
                          suffix: RegisterCubit.get(context).suffix,
                          suffixPressed: () {
                            RegisterCubit.get(context)
                                .changePasswordVisibilityREG();
                          },
                          label: 'Confirm password',
                          prefix: Icons.lock_outlined,
                          validate: (String? value) {
                            if (value != passwordController.text) {
                              return 'password is not the same';
                            }
                          },
                          isPassword: RegisterCubit.get(context).isPasswordShow,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ConditionalBuilder(
                          fallback: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          condition: state is! RegisterLoading,
                          builder: (context) => Container(
                            width: double.infinity,
                            height: 55.h,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8.r)),
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).userRegister(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                    name: nameController.text,
                                  );
                                }
                              },
                              child: Text(
                                "Create",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(fontSize: 15.sp),
                            ),
                            TextButton(
                              onPressed: () => navigateTo(
                                context,
                                LoginScreen(),
                              ),
                              child: Text(
                                "Login now",
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
              )),
            ),
          );
        },
      ),
    );
  }
}
