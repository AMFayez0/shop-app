// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/component/widgets.dart';
import 'package:shop_app/home_layout/cubit/home_cubit.dart';
import 'package:shop_app/login/login/login.dart';
import 'package:shop_app/network/cach_helper.dart';

class Settings extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is ErrorUpdateUserState) {
          ////////////////
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text('something went wrong'),
              children: [
                SimpleDialogOption(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Text('${HomeCubit.get(context).userModel!.message}'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        var model = HomeCubit.get(context).userModel!;

        if (model.data != null) {
          nameController.text = model.data!.name ?? '';
          emailController.text = model.data!.email ?? '';
          phoneController.text = model.data!.phone ?? '';
        }
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (BuildContext context, Widget? child) => ConditionalBuilder(
            condition: HomeCubit.get(context).userModel != null,
            fallback: (context) => Center(child: CircularProgressIndicator()),
            builder: (context) => Padding(
              padding:  EdgeInsets.all(25.0.r),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 75.r,
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(
                          'https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg'),
                    ),
                    SizedBox(
                      height: 20.r,
                    ),
                    if (state is LoadingUpdateUserState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      label: 'Name',
                      prefix: Icons.person,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'name must not be empty';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      label: 'Email address',
                      prefix: Icons.email,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Email address must not be empty';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      type: TextInputType.numberWithOptions(),
                      label: 'Number',
                      prefix: Icons.phone,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Number must not be empty';
                        }
                      },
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 55.h,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            HomeCubit.get(context).updateUserData(
                              email: emailController.text,
                              name: nameController.text,
                              phone: phoneController.text,
                            );
                          }
                        },
                        child: Text(
                          "Update data",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 55.h,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: MaterialButton(
                        onPressed: () {
                          CachHelper.removeData(
                            key: 'token',
                            
                          ).then((value) {
                            navigateAndReplace(context, LoginScreen());
                            
                          });
                        },
                        child: Text(
                          "SIGN OUT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
