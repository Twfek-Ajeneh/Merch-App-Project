import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

import 'package:project/model/product.dart';
import 'package:project/tools/colors.dart';
import 'package:project/tools/mainmessage.dart';
import 'package:project/tools/maintextfield.dart';
import 'package:project/tools/mybehavior.dart';
import 'package:project/view/editProductScreen/cubit/edit_product_cubit.dart';
import 'package:project/view/editProductScreen/edit_product.dart';
import 'package:project/view/productDetailsScreen/cubit/delete_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/like_cubit.dart';
import 'package:project/view/productDetailsScreen/cubit/product_details_cubit.dart';
import 'package:project/view/productDetailsScreen/product_details_api.dart';

class ProductDetails extends StatelessWidget {
  ProductDetails({Key? key, required this.baseId}) : super(key: key);

  final int baseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details", // prodcut name
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 21),
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
          child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
            builder: (context, state) {
              if (state is ProductDetailsWaiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AllColors.secondryColor,
                    strokeWidth: 2,
                  ),
                );
              }
              if (state is ProductDetailsFailed) {
                return RefreshIndicator(
                  onRefresh: () => BlocProvider.of<ProductDetailsCubit>(context)
                      .get_product(id: baseId),
                  color: AllColors.secondryColor,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView(
                      children: [
                        SizedBox(height: 200),
                        Image.asset("images/error.png"),
                        Text(
                          "Something went wrong :\(",
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
              if (state is ProductDetailsSuccess) {
                return RefreshIndicator(
                  onRefresh: () => BlocProvider.of<ProductDetailsCubit>(context)
                      .get_product(id: state.product.id!),
                  color: AllColors.secondryColor,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 240,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              state.product.image_url!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'images/image_user.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getText("${state.product.name!}", 21, 0),
                            InkWell(
                              onTap: () async {
                                await BlocProvider.of<LikeCubit>(context)
                                    .Change(id: state.product.id!);
                                BlocProvider.of<ProductDetailsCubit>(context)
                                    .get_product(id: state.product.id!);
                              },
                              child: BlocBuilder<LikeCubit, bool>(
                                builder: (context, s) {
                                  return getIcon(m: state.product.isLiked!);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            getText(
                              "${state.product.price!}\$",
                              18,
                              0,
                              c: Color(0xFF007C48),
                            ),
                            SizedBox(width: 12),
                            state.product.original_price != state.product.price
                                ? getText(
                                    "${state.product.original_price}\$",
                                    18,
                                    0,
                                    c: AllColors.errorColor,
                                    line: true,
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(height: 10),
                        getLine(color: AllColors.thirdColor),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            getText("Category: ", 16, 0),
                            getText("  ${state.product.type!}", 16, 0),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.production_quantity_limits,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            getText("Quantities: ", 16, 0),
                            getText("  ${state.product.product_count!}", 16, 0),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            getText("Views: ", 16, 0),
                            getText("  ${state.product.view_count!}", 16, 0),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.thumb_up_alt_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            getText("Likes:", 16, 0),
                            getText("  ${state.product.like_count}", 16, 0),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            getText("Expires At:", 16, 0),
                            getText(
                              "  ${AllColors.formatter.format(state.product.expires_at!)}",
                              16,
                              0,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.contacts_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            getText("Contact Info:", 16, 0),
                            getText("  ${state.product.contact_info}", 16, 0),
                          ],
                        ),
                        SizedBox(height: 10),
                        getLine(color: AllColors.thirdColor),
                        SizedBox(height: 10),
                        getText("${state.product.description}", 16, 0),
                        SizedBox(height: 10),
                        getLine(color: AllColors.thirdColor),
                        Theme(
                          data: ThemeData()
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            iconColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            tilePadding: EdgeInsets.symmetric(horizontal: 5),
                            title: Row(
                              children: [
                                Icon(
                                  Icons.comment,
                                  size: 24,
                                  color: AllColors.textColor,
                                ),
                                SizedBox(width: 10),
                                getText("Comments", 17, 0),
                              ],
                            ),
                            children: [
                              getComments(
                                state.product.id!,
                                state.product.comments!,
                                context,
                              )
                            ],
                          ),
                        ),
                        getLine(color: AllColors.thirdColor),
                        SizedBox(height: 15),
                        state.product.is_owner == true
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  getButton(
                                    () => nav(context, state.product),
                                    AllColors.secondryColor,
                                    "Edit",
                                    Icons.edit_outlined,
                                  ),
                                  BlocListener<DeleteCubit, DeleteState>(
                                    listener: (context, state) {
                                      if (state is DeleteWaiting) {
                                        MainMessage.getProgressIndicator(
                                            context);
                                      }
                                      if (state is DeleteFailed) {
                                        Navigator.pop(context);
                                        MainMessage.getSnackBar(
                                          state.exception,
                                          AllColors.errorColor,
                                          context,
                                        );
                                      }
                                      if (state is DeleteSuccess) {
                                        Navigator.pop(context);
                                        MainMessage.getSnackBar(
                                          "Product deleted successfully",
                                          AllColors.secondryColor,
                                          context,
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: getButton(
                                      () =>
                                          BlocProvider.of<DeleteCubit>(context)
                                              .delete_product(
                                        id: state.product.id!,
                                      ),
                                      AllColors.errorColor,
                                      "Delete",
                                      Icons.delete,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              }
              return Center();
            },
          ),
        ),
      ),
    );
  }

  Container getLine({Color? color, double? W}) {
    return Container(
      width: W != null ? W : null,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: color != null ? color : Colors.black,
          ),
        ),
      ),
    );
  }

  Text getText(String label, double size, int font,
      {int? f, Color? c, bool? line}) {
    return Text(
      label,
      textAlign: f != null ? TextAlign.center : null,
      style: TextStyle(
        color: c != null ? c : AllColors.textColor,
        fontWeight: font == 1 ? FontWeight.normal : FontWeight.w300,
        fontSize: size,
        decoration:
            line != null ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }

  Container getIcon({bool? m}) {
    return Container(
      padding: EdgeInsets.only(right: 5),
      child: m == null || m == false
          ? Icon(
              Icons.thumb_up_alt_outlined,
              size: 23,
              color: Colors.white,
            )
          : Icon(
              Icons.thumb_up_alt,
              size: 23,
              color: Colors.blue,
            ),
    );
  }

  Container getButton(
    Function()? function,
    Color color,
    String label,
    IconData icon,
  ) {
    return Container(
      width: 180,
      height: 45,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: ElevatedButton(
        onPressed: function,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 5),
            Icon(
              icon,
              color: AllColors.mainColor,
              size: 21,
            ),
          ],
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          elevation: MaterialStateProperty.all(5),
        ),
      ),
    );
  }

  nav(BuildContext context, Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => EditProductCubit(),
          child: EditProduct(product: product),
        ),
      ),
    );
    BlocProvider.of<ProductDetailsCubit>(context).get_product(id: product.id!);
  }

  Container getComments(int id, List<dynamic> comments, BuildContext context) {
    TextEditingController _comment = TextEditingController();
    final _formkey = GlobalKey<FormState>();
    return Container(
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 300),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return getLine(color: AllColors.thirdColor);
                },
                padding: EdgeInsets.only(left: 5, right: 5),
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 8, top: 8),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getText(comments[index]['user_name'], 16, 1),
                        SizedBox(height: 5),
                        getText(" " +comments[index]['comment'], 15, 0),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          Form(
            key: _formkey,
            child: MainTextField(
              label: "Enter your comment",
              type: "comment",
              validator: (value) {
                if (isNull(value) || value!.isEmpty)
                  return "Enter your comment to send";
                else
                  return null;
              },
              controller: _comment,
              showFunction: () async {
                if (_formkey.currentState!.validate()) {
                  await ProductDetailsApi.comment_product(
                    id: id,
                    comment: _comment.text,
                  );
                  BlocProvider.of<ProductDetailsCubit>(context)
                      .get_product(id: id);
                }
              },
              W: 378,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
