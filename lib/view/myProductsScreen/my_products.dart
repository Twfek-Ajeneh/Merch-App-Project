import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:project/tools/colors.dart';
import 'package:project/tools/mainitemfield.dart';
import 'package:project/tools/mybehavior.dart';
import 'package:project/view/myProductsScreen/cubit/my_products_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/delete_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/like_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/product_details_cubit.dart';
import 'package:project/view/productDetailsScreen/product_details.dart';

class MyProducts extends StatelessWidget {
  const MyProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Products",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: AllColors.secondryColor,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AllColors.mainColor,
          child: BlocBuilder<MyProductsCubit, MyProductsState>(
            builder: (context, state) {
              if (state is MyProductsWaiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AllColors.secondryColor,
                    strokeWidth: 2,
                  ),
                );
              }
              if (state is MyProductsFailed ||
                  (state is MyProductsSuccess && state.products.length == 0)) {
                return RefreshIndicator(
                  onRefresh:
                      BlocProvider.of<MyProductsCubit>(context).get_products,
                  color: AllColors.secondryColor,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView(
                      children: [
                        SizedBox(height: 200),
                        state is MyProductsFailed
                            ? Image.asset("images/error.png")
                            : Image.asset("images/empty.png", width: 500),
                        Text(
                          state is MyProductsFailed
                              ? "Something went wrong :\("
                              : "There are no products to display \n Add a product to view",
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
                );
              }
              if (state is MyProductsSuccess && state.products.length != 0) {
                return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: RefreshIndicator(
                    onRefresh:
                        BlocProvider.of<MyProductsCubit>(context).get_products,
                    color: AllColors.secondryColor,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
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
                                    product: state.products[index]),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: state.products.length,
                    ),
                  ),
                );
              }
              return Center();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_product');
          BlocProvider.of<MyProductsCubit>(context).get_products();
        },
        child: Icon(Icons.add),
        backgroundColor: AllColors.secondryColor,
        elevation: 10,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
    BlocProvider.of<MyProductsCubit>(context).get_products();
  }
}
