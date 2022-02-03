import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project/model/product.dart';
import 'package:project/view/addProductScreen/add_product.dart';
import 'package:project/view/addProductScreen/cubit/add_product_cubit.dart';
import 'package:project/view/editProductScreen/edit_product.dart';
import 'package:project/view/homeScreen/cubit/home_cubit.dart';
import 'package:project/view/homeScreen/cubit/logout_cubit.dart';
import 'package:project/view/homeScreen/cubit/user_image_cubit.dart';
import 'package:project/view/homeScreen/home.dart';
import 'package:project/view/loginScreen/Cubit/login_cubit.dart';
import 'package:project/view/loginScreen/login.dart';
import 'package:project/view/myProductsScreen/cubit/my_products_cubit.dart';
import 'package:project/view/myProductsScreen/my_products.dart';
import 'package:project/view/productDetailsScreen/product_details.dart';
import 'package:project/view/signUpScreen/cubit/signup_cubit.dart';
import 'package:project/view/signUpScreen/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'model/user.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.containsKey('token') &&
      preferences.getString('token')!.length != 0) {
    try {
      Response response =
          await Api.checkToken(token: preferences.getString('token')!);
      if (response.statusCode == 200) {
        debugPrint("token valid");
        Api.user = User.fromJson(response.data);
        var token = response.data['token'];
        preferences.setString('token', token);
      }
    } catch (e) {
      debugPrint("token invalid");
      preferences.setString('token', '');
    }
  } else {
    preferences.setString('token', '');
  }
  await Api.getToken();
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Api.user!.token!.length == 0 ? '/login' : '/home',
      routes: {
        '/login': (context) => BlocProvider(
              create: (context) => LogInCubit(),
              child: LogIn(),
            ),
        '/signup': (context) => BlocProvider(
              create: (context) => SignUpCubit(),
              child: SignUp(),
            ),
        '/home': (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => HomeCubit()..get_products(),
                ),
                BlocProvider(create: (context) => LogOutCubit()),
                BlocProvider(create: (context) => UserImageCubit()),
              ],
              child: Home(),
            ),
        '/my_products': (context) => BlocProvider(
              create: (context) => MyProductsCubit()..get_products(),
              child: MyProducts(),
            ),
        '/add_product': (context) => BlocProvider(
              create: (context) => AddProductCubit(),
              child: AddProduct(),
            ),
        '/product_details': (context) => ProductDetails(baseId: 0),
        '/edit_product': (context) => EditProduct(product: Product()),
      },
    );
  }
}
