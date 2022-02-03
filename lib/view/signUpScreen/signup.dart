import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project/model/user.dart';
import 'package:project/tools/colors.dart';
import 'package:project/tools/mainbutton.dart';
import 'package:project/tools/mainmessage.dart';
import 'package:project/tools/maintextfield.dart';
import 'package:project/tools/mybehavior.dart';
import 'package:project/tools/validation/signupvalidator.dart';
import 'package:project/view/signUpScreen/cubit/passwordvisibility_cubit.dart';
import 'package:project/view/signUpScreen/cubit/signup_cubit.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final TextEditingController _name_controller = TextEditingController();
  final TextEditingController _email_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();
  final TextEditingController _confirm_controller = TextEditingController();
  final TextEditingController _number_controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => PasswordvisibilitySCubit(),
          child: Container(
            color: AllColors.mainColor,
            padding: const EdgeInsets.all(10.0),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                children: [
                  SizedBox(height: 80),
                  Text(
                    "Create an account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AllColors.textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 40),
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MainTextField(
                          label: "Enter your Name",
                          type: 'name',
                          controller: _name_controller,
                          validator: SignUpValidator.nameValidator,
                        ),
                        SizedBox(height: 30),
                        MainTextField(
                          label: "Enter your Email",
                          type: "email",
                          controller: _email_controller,
                          validator: SignUpValidator.emailValidator,
                        ),
                        SizedBox(height: 30),
                        BlocBuilder<PasswordvisibilitySCubit, bool>(
                          builder: (context, state) {
                            return MainTextField(
                              label: "Enter your Password",
                              type: "password",
                              controller: _password_controller,
                              validator: SignUpValidator.passwordValidator,
                              showFunction:
                                  BlocProvider.of<PasswordvisibilitySCubit>(
                                          context)
                                      .Switched,
                              show: state,
                            );
                          },
                        ),
                        SizedBox(height: 30),
                        MainTextField(
                          label: "Confirm Password",
                          type: "confirm",
                          validator: SignUpValidator.confirmValidator,
                          controller: _confirm_controller,
                          show: true,
                        ),
                        SizedBox(height: 30),
                        MainTextField(
                          label: "Enter your Phone Number",
                          type: "number",
                          controller: _number_controller,
                          validator: SignUpValidator.numberValidator,
                        ),
                        SizedBox(height: 30),
                        BlocListener<SignUpCubit, SignUpState>(
                          listener: (context, state) {
                            if (state is SignUpSuccess) {
                              Navigator.pop(context);
                              MainMessage.getSnackBar(
                                "Sign Up success",
                                AllColors.secondryColor,
                                context,
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/home',
                                (route) => false,
                              );
                            }
                            if (state is SignUpFailed) {
                              Navigator.pop(context);
                              MainMessage.getSnackBar(
                                state.exception,
                                AllColors.errorColor,
                                context,
                              );
                            }
                            if (state is SignUpWaiting) {
                              MainMessage.getProgressIndicator(context);
                            }
                          },
                          child: MainButton(
                            color: AllColors.secondryColor,
                            label: "Sign Up",
                            function: () {
                              if (_formkey.currentState!.validate()) {
                                BlocProvider.of<SignUpCubit>(context).submitted(
                                  user: User(
                                    name: _name_controller.text,
                                    email: _email_controller.text,
                                    password: _password_controller.text,
                                    password_confirmation:
                                        _confirm_controller.text,
                                    phone_number: _number_controller.text,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 350,
                      padding: EdgeInsets.only(right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: AllColors.textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          InkWell(
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                color: AllColors.secondryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
