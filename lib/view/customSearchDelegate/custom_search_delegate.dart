import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:project/model/product.dart';
import 'package:project/tools/colors.dart';
import 'package:project/tools/mainitemfield.dart';
import 'package:project/tools/mybehavior.dart';
import 'package:project/view/customSearchDelegate/cubit/search_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/delete_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/like_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/product_details_cubit.dart';
import 'package:project/view/productDetailsScreen/product_details.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({
    required this.products,
  });

  String date = "";
  DateTime? dateQuery;
  List<Product> products;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: AllColors.createMaterialColor(AllColors.secondryColor),
      hintColor: Colors.white,
      textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontWeight: FontWeight.w300),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        padding: EdgeInsets.only(right: 5),
        onPressed: () {
          query = '';
          date = '';
          dateQuery = null;
        },
        icon: Icon(Icons.clear),
      ),
      IconButton(
        padding: EdgeInsets.only(right: 15),
        onPressed: () async {
          DateTime? temp = await showpicker(context);
          datePicker(temp);
        },
        icon: Icon(
          Icons.date_range,
          size: 25,
          color: AllColors.textColor,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AllColors.mainColor,
      child: BlocProvider(
        create: (context) => SearchCubit()..search(query: query, date: date),
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchWaiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AllColors.secondryColor,
                  strokeWidth: 2,
                ),
              );
            }
            if (state is SearchFailed ||
                (state is SearchSuccess && state.products.length == 0)) {
              return Column(
                children: [
                  SizedBox(height: 200),
                  state is SearchFailed
                      ? Image.asset("images/error.png")
                      : Image.asset("images/empty.png", width: 500),
                  Text(
                    state is SearchFailed
                        ? "Something went wrong :\("
                        : "There are no products \nthat match your search",
                    style: TextStyle(
                      color: Color(0xFFC4C4C4),
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
            if (state is SearchSuccess && state.products.length != 0) {
              return ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 500),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: InkWell(
                            onTap: () => show_product(
                                context, state.products[index].id!),
                            child: MainItemField(
                              product: state.products[index],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: state.products.length,
                ),
              );
            }
            return Center();
          },
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> match = [];
    if (query.length == 0 && dateQuery == null)
      match = products;
    else {
      if (query.length != 0 && dateQuery != null) {
        for (var item in products) {
          if ((item.name!.toLowerCase().contains(query.toLowerCase()) &&
                  (item.expires_at!.isBefore(dateQuery!) || item.expires_at==dateQuery)  ) ||
              (item.type!.toLowerCase().contains(query.toLowerCase()) &&
                  (item.expires_at!.isBefore(dateQuery!) || item.expires_at==dateQuery)  )) {
            match.add(item);
          }
        }
      } else if (query.length != 0) {
        for (var item in products) {
          if ((item.name!.toLowerCase().contains(query.toLowerCase())) ||
              (item.type!.toLowerCase().contains(query.toLowerCase()))) {
            match.add(item);
          }
        }
      } else {
        for (var item in products) {
          if (item.expires_at!.isBefore(dateQuery!) || item.expires_at==dateQuery) match.add(item);
        }
      }
    }

    if (match.length == 0) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: AllColors.mainColor,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 200),
                Image.asset("images/empty.png", width: 500),
                Text(
                  "There are no products \nthat match your search",
                  style: TextStyle(
                    color: Color(0xFFC4C4C4),
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: AllColors.mainColor,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 300,
                  child: FadeInAnimation(
                    child: InkWell(
                      onTap: () =>
                          show_product(context, match[index].id!),
                      child: MainItemField(
                        product: match[index],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: match.length,
          ),
        ),
      );
    }

  }

  show_product(BuildContext context, int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ProductDetailsCubit()..get_product(id: id),
              ),
              BlocProvider(create: (context) => DeleteCubit()),
              BlocProvider(create: (context) => LikeCubit()),
            ],
            child: ProductDetails(baseId: id),
          );
        },
      ),
    );
  }

  Future<DateTime?> showpicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch:
                AllColors.createMaterialColor(AllColors.secondryColor),
            primaryColorDark:
                AllColors.createMaterialColor(AllColors.secondryColor),
            accentColor: AllColors.createMaterialColor(AllColors.secondryColor),
          ),
          dialogBackgroundColor: AllColors.thirdColor,
        ),
        child: child!,
      ),
    );
  }

  void datePicker(DateTime? value) {
    dateQuery = value;
    if (value == null) return;
    date = AllColors.formatter.format(value);
  }
}
