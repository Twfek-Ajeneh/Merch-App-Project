import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:project/model/product.dart';
import 'package:project/tools/colors.dart';
import 'package:project/tools/mainbutton.dart';
import 'package:project/tools/mainmessage.dart';
import 'package:project/tools/maintextfield.dart';
import 'package:project/tools/mybehavior.dart';
import 'package:project/tools/validation/addproductvalidator.dart';
import 'package:project/view/editProductScreen/cubit/edit_image_cubit.dart';
import 'package:project/view/editProductScreen/cubit/edit_product_cubit.dart';

class EditProduct extends StatelessWidget {
  EditProduct({Key? key, required this.product}) : super(key: key);

  final Product product;
  File? _image;
  final TextEditingController _name_controller = TextEditingController();
  final TextEditingController _type_controller = TextEditingController();
  final TextEditingController _price_controller = TextEditingController();
  final TextEditingController _count_controller = TextEditingController();
  final TextEditingController _temp = TextEditingController(); //for date
  final TextEditingController _discount_1_controller = TextEditingController();
  final TextEditingController _discount_2_controller = TextEditingController();
  final TextEditingController _days_for_d1_controller = TextEditingController();
  final TextEditingController _days_for_d2_controller = TextEditingController();
  final TextEditingController _contact_info_controller =
      TextEditingController();
  final TextEditingController _description_controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Product",
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
            color: AllColors.mainColor,
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formkey,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: [
                    BlocBuilder<EditImageCubit, bool>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AllColors.fieldColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: 130,
                                height: 130,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 130,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: _image != null
                                            ? Image.file(
                                                _image!,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                product.image_url!,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    Center(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: AllColors.hintTextColor,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () => pickImage(context),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainTextField(
                          label: "Name",
                          type: "name",
                          validator: AddProductValidator.nameValidator,
                          controller: _name_controller..text = product.name!,
                          W: 180,
                        ),
                        MainTextField(
                          label: "Category",
                          type: "name",
                          validator: AddProductValidator.typeValidator,
                          controller: _type_controller..text = product.type!,
                          W: 180,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainTextField(
                          label: "Price",
                          type: "number",
                          validator: AddProductValidator.priceValidator,
                          controller: _price_controller
                            ..text = product.original_price!.toString(),
                          W: 180,
                        ),
                        MainTextField(
                          label: "Count",
                          type: "number",
                          validator: AddProductValidator.countValidator,
                          controller: _count_controller
                            ..text = product.product_count!.toString(),
                          W: 180,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    MainTextField(
                      label: "Expires Date",
                      type: "number",
                      validator: (a) => null,
                      controller: _temp
                        ..text =
                            AllColors.formatter.format(product.expires_at!),
                      W: 370,
                      f: true,
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainTextField(
                          label: "Discount",
                          type: "number",
                          validator: AddProductValidator.discountValidator,
                          controller: _discount_1_controller
                            ..text = product.discount_1!.toString(),
                          W: 180,
                        ),
                        MainTextField(
                          label: "Days befor discount",
                          type: "number",
                          validator: AddProductValidator.daysValidator,
                          controller: _days_for_d1_controller
                            ..text = product.days_before_discount_1.toString(),
                          W: 180,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainTextField(
                          label: "Discount",
                          type: "number",
                          validator: AddProductValidator.discountValidator,
                          controller: _discount_2_controller
                            ..text = product.discount_2.toString(),
                          W: 180,
                        ),
                        MainTextField(
                          label: "Days befor discount",
                          type: "number",
                          validator: AddProductValidator.daysValidator,
                          controller: _days_for_d2_controller
                            ..text = product.days_before_discount_2.toString(),
                          W: 180,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    MainTextField(
                      label: "Contact info",
                      type: "name",
                      validator: AddProductValidator.contactValidator,
                      controller: _contact_info_controller
                        ..text = product.contact_info!,
                      W: 370,
                    ),
                    SizedBox(height: 30),
                    MainTextField(
                      label: "Description",
                      type: "name",
                      validator: AddProductValidator.descriptionValidator,
                      controller: _description_controller
                        ..text = product.description!,
                      W: 370,
                      H: 5,
                    ),
                    SizedBox(height: 30),
                    BlocListener<EditProductCubit, EditProductState>(
                      listener: (context, state) {
                        if (state is EditProductWaiting) {
                          MainMessage.getProgressIndicator(context);
                        }
                        if (state is EditProductSuccess) {
                          Navigator.pop(context);
                          MainMessage.getSnackBar(
                            "Product edited successfully",
                            AllColors.secondryColor,
                            context,
                          );
                          Navigator.pop(context);
                        }
                        if (state is EditProductFailed) {
                          Navigator.pop(context);
                          MainMessage.getSnackBar(
                            state.exception,
                            AllColors.errorColor,
                            context,
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainButton(
                            color: AllColors.secondryColor,
                            label: "Edit",
                            function: () {
                              if (_formkey.currentState!.validate()) {
                                BlocProvider.of<EditProductCubit>(context).edit(
                                  product: Product(
                                    id: product.id,
                                    image: _image,
                                    image_url: product.image_url,
                                    name: _name_controller.text,
                                    type: _type_controller.text,
                                    price: double.parse(_price_controller.text),
                                    product_count:
                                        int.parse(_count_controller.text),
                                    expires_at: product.expires_at,
                                    discount_1: double.parse(
                                        _discount_1_controller.text),
                                    days_before_discount_1:
                                        int.parse(_days_for_d1_controller.text),
                                    discount_2: double.parse(
                                        _discount_2_controller.text),
                                    days_before_discount_2:
                                        int.parse(_days_for_d2_controller.text),
                                    contact_info: _contact_info_controller.text,
                                    description: _description_controller.text,
                                  ),
                                );
                              }
                            },
                            W: 180,
                          ),
                          MainButton(
                            color: AllColors.errorColor,
                            label: "Cancel",
                            function: () => Navigator.pop(context),
                            W: 180,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage(BuildContext context) async {
    try {
      final temp = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (temp == null) return;
      final imageTemp = File(temp.path);
      this._image = imageTemp;
      BlocProvider.of<EditImageCubit>(context).Change();
    } on PlatformException catch (e) {
      MainMessage.getSnackBar(
        "Failed to load image",
        AllColors.errorColor,
        context,
      );
    }
  }
}
