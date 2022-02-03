import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project/model/user.dart';
import 'package:project/tools/colors.dart';
import 'package:project/tools/mainbutton.dart';
import 'package:project/tools/mainmessage.dart';
import 'package:project/tools/maintextfield.dart';
import 'package:project/tools/mybehavior.dart';
import 'package:project/tools/validation/loginvalidator.dart';
import 'package:project/view/loginScreen/Cubit/login_cubit.dart';
import 'package:project/view/loginScreen/Cubit/passwordvisibility_cubit.dart';

class LogIn extends StatelessWidget {
  LogIn({Key? key}) : super(key: key);

  final TextEditingController _email_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => PasswordvisibilityCubit(),
          child: Container(
            color: AllColors.mainColor,
            padding: const EdgeInsets.all(10.0),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView(
                children: [
                  SizedBox(height: 60),
                  Center(
                    child: Image.asset("images/logo.png", width: 300),
                  ),
                  SizedBox(height: 60),
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        MainTextField(
                          label: "Enter your Email",
                          type: "email",
                          validator: LogInValidator.emailValidator,
                          controller: _email_controller,
                        ),
                        SizedBox(height: 40),
                        BlocBuilder<PasswordvisibilityCubit, bool>(
                          builder: (context, state) {
                            return MainTextField(
                              label: "Enter your Password",
                              type: "password",
                              validator: LogInValidator.passwrodValidator,
                              controller: _password_controller,
                              showFunction:
                                  BlocProvider.of<PasswordvisibilityCubit>(
                                          context)
                                      .Switched,
                              show: state,
                            );
                          },
                        ),
                        SizedBox(height: 40),
                        BlocListener<LogInCubit, LogInState>(
                          listener: (context, state) {
                            if (state is LogInSuccess) {
                              Navigator.pop(context);
                              MainMessage.getSnackBar(
                                "Log In success",
                                AllColors.secondryColor,
                                context,
                              );
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                            if (state is LogInFailed) {
                              Navigator.pop(context);
                              MainMessage.getSnackBar(
                                state.exception,
                                AllColors.errorColor,
                                context,
                              );
                            }
                            if (state is LogInWaiting) {
                              MainMessage.getProgressIndicator(context);
                            }
                          },
                          child: MainButton(
                            color: AllColors.secondryColor,
                            label: "Log In",
                            function: () {
                              if (_formkey.currentState!.validate()) {
                                BlocProvider.of<LogInCubit>(context).submitted(
                                  user: User(
                                    email: _email_controller.text,
                                    password: _password_controller.text,
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
                            "Create a new account?",
                            style: TextStyle(
                              color: AllColors.textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          InkWell(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: AllColors.secondryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, "/signup"),
                          ),
                        ],
                      ),
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
