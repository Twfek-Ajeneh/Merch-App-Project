import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/api.dart';
import 'package:project/model/product.dart';

import 'package:project/tools/colors.dart';
import 'package:project/tools/mainitemfield.dart';
import 'package:project/tools/mainmessage.dart';
import 'package:project/tools/mybehavior.dart';
import 'package:project/view/customSearchDelegate/custom_search_delegate.dart';
import 'package:project/view/homeScreen/cubit/home_cubit.dart';
import 'package:project/view/homeScreen/cubit/logout_cubit.dart';
import 'package:project/view/homeScreen/cubit/user_image_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/delete_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/like_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/product_details_cubit.dart';
import 'package:project/view/productDetailsScreen/product_details.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: AllColors.secondryColor,
        actions: [
          PopupMenuButton<int>(
            color: Color(0xffC4C4C4),
            initialValue: 0,
            onSelected: (value) =>
                BlocProvider.of<HomeCubit>(context).list_sort(value),
            itemBuilder: (context) => [
              _myPopUpItem(
                value: 1,
                label: "Sort by name",
                icon: Icons.sort_by_alpha,
              ),
              _myPopUpItem(
                value: 2,
                label: "Sort by price",
                icon: Icons.trending_down,
              ),
              _myPopUpItem(
                value: 3,
                label: "Sort by expired",
                icon: Icons.date_range,
              ),
            ],
            padding: EdgeInsets.all(8),
            icon: Icon(Icons.filter_list_rounded),
            iconSize: 28,
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AllColors.mainColor,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeWaiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AllColors.secondryColor,
                    strokeWidth: 2,
                  ),
                );
              }
              if (state is HomeFailed ||
                  (state is HomeSuccess && state.products.length == 0)) {
                return RefreshIndicator(
                  onRefresh: BlocProvider.of<HomeCubit>(context).get_products,
                  color: AllColors.secondryColor,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView(
                      children: [
                        SizedBox(height: 200),
                        state is HomeFailed
                            ? Image.asset("images/error.png")
                            : Image.asset("images/empty.png", width: 500),
                        Text(
                          state is HomeFailed
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
              if (state is HomeSuccess && state.products.length != 0) {
                products = state.products;
                return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: RefreshIndicator(
                    onRefresh: BlocProvider.of<HomeCubit>(context).get_products,
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
      drawer: Drawer(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AllColors.thirdColor,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 280,
                  color: AllColors.mainColor,
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          BlocConsumer<UserImageCubit, UserImageState>(
                            listener: (context, state) {
                              if (state is UserImageWaiting) {
                                MainMessage.getProgressIndicator(context);
                              }
                              if (state is UserImageFailed) {
                                Navigator.pop(context);
                                MainMessage.getSnackBar(
                                  state.exception,
                                  AllColors.errorColor,
                                  context,
                                );
                                BlocProvider.of<UserImageCubit>(context)
                                    .reset();
                              }
                            },
                            builder: (context, state) {
                              if (state is UserImageSuccess) {
                                Navigator.pop(context);
                                BlocProvider.of<UserImageCubit>(context)
                                    .reset();
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  Api.user!.image_url!,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'images/user_image.png',
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          Container(
                            width: 27,
                            height: 27,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AllColors.thirdColor,
                            ),
                            child: InkWell(
                              onTap: () => pickImage(context),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            Api.user!.name!,
                            style: TextStyle(
                              color: AllColors.textColor,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            Api.user!.email!,
                            style: TextStyle(
                              color: AllColors.fieldColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    _myDrawerItem(
                      icon: Icons.store_mall_directory_sharp,
                      textColor: AllColors.mainColor,
                      iconColor: AllColors.secondryColor,
                      label: "My Products",
                      function: () async {
                        await Navigator.pushNamed(context, '/my_products');
                        BlocProvider.of<HomeCubit>(context).get_products();
                      },
                    ),
                    _myDrawerItem(
                      icon: Icons.add_business,
                      textColor: AllColors.mainColor,
                      iconColor: AllColors.secondryColor,
                      label: "Add a new product",
                      function: () async {
                        await Navigator.pushNamed(context, '/add_product');
                        BlocProvider.of<HomeCubit>(context).get_products();
                      },
                    ),
                    BlocListener<LogOutCubit, LogOutState>(
                      listener: (context, state) {
                        if (state is LogOutWaiting) {
                          MainMessage.getProgressIndicator(context);
                        }
                        if (state is LogOutSuccess) {
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                        if (state is LogOutFailed) {
                          Navigator.pop(context);
                          MainMessage.getSnackBar(
                            state.exception,
                            AllColors.errorColor,
                            context,
                          );
                        }
                      },
                      child: _myDrawerItem(
                        icon: Icons.logout,
                        textColor: AllColors.mainColor,
                        iconColor: AllColors.errorColor,
                        label: "Log out",
                        function: () =>
                            BlocProvider.of<LogOutCubit>(context).logout(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showSearch(
            context: context,
            delegate: CustomSearchDelegate(products: products),
          );
          BlocProvider.of<HomeCubit>(context).get_products();
        },
        child: Icon(Icons.search),
        backgroundColor: AllColors.secondryColor,
        elevation: 10,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PopupMenuItem<int> _myPopUpItem(
      {required int value, required String label, required IconData icon}) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: AllColors.thirdColor,
          ),
          SizedBox(width: 15),
          Text(label),
        ],
      ),
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w300,
        fontSize: 17,
      ),
    );
  }

  Container _myDrawerItem({
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required String label,
    required Function() function,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xff686D76)),
        ),
      ),
      child: ListTile(
        onTap: function,
        leading: Icon(
          icon,
          color: iconColor,
          size: 30,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Future pickImage(BuildContext context) async {
    try {
      File? _image;
      final temp = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (temp == null) return;
      final imageTemp = File(temp.path);
      _image = imageTemp;
      BlocProvider.of<UserImageCubit>(context).edit_image(image: _image);
    } on PlatformException catch (e) {
      MainMessage.getSnackBar(
        "Failed to load image",
        AllColors.errorColor,
        context,
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
    BlocProvider.of<HomeCubit>(context).get_products();
  }
}
