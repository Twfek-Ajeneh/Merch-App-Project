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
import 'package:project/view/addProductScreen/cubit/add_product_cubit.dart';
import 'package:project/view/addProductScreen/cubit/date_cubit.dart';
import 'package:project/view/addProductScreen/cubit/image_cubit.dart';

class AddProduct extends StatelessWidget {
  AddProduct({Key? key}) : super(key: key);

  File? _image;
  final TextEditingController _name_controller = TextEditingController();
  final TextEditingController _type_controller = TextEditingController();
  final TextEditingController _price_controller = TextEditingController();
  final TextEditingController _count_controller = TextEditingController();
  DateTime? _expires_date;
  final TextEditingController _temp = TextEditingController(); // for date
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ImageCubit()),
        BlocProvider(create: (context) => DateCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Product",
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
            child: Form(
              key: _formkey,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  padding: EdgeInsets.all(15),
                  children: [
                    BlocBuilder<ImageCubit, bool>(
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
                                    _image != null
                                        ? Container(
                                            width: 130,
                                            height: 130,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.file(
                                                _image!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Center(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainTextField(
                          label: "Name",
                          type: "name",
                          validator: AddProductValidator.nameValidator,
                          controller: _name_controller,
                          W: 175,
                        ),
                        MainTextField(
                          label: "Category",
                          type: "name",
                          validator: AddProductValidator.typeValidator,
                          controller: _type_controller,
                          W: 175,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainTextField(
                          label: "Price",
                          type: "number",
                          validator: AddProductValidator.priceValidator,
                          controller: _price_controller,
                          W: 175,
                        ),
                        MainTextField(
                          label: "Count",
                          type: "number",
                          validator: AddProductValidator.countValidator,
                          controller: _count_controller,
                          W: 175,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AllColors.fieldColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: 360,
                          height: 46,
                        ),
                        Container(
                          width: 360,
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: BlocBuilder<DateCubit, bool>(
                            builder: (context, state) {
                              return TextFormField(
                                controller: _temp,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Expires Date",
                                  hintStyle: TextStyle(
                                    color: AllColors.hintTextColor,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      DateTime? temp =
                                          await showpicker(context);
                                      datePicker(temp, context);
                                    },
                                    icon: Icon(
                                      Icons.date_range,
                                      size: 25,
                                      color: AllColors.hintTextColor,
                                    ),
                                  ),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: AllColors.secondryColor,
                                keyboardType: TextInputType.datetime,
                                validator: AddProductValidator.dateValidator,
                                readOnly: true,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainTextField(
                          label: "Discount",
                          type: "number",
                          validator: AddProductValidator.discountValidator,
                          controller: _discount_1_controller,
                          W: 175,
                        ),
                        MainTextField(
                          label: "Days befor discount",
                          type: "number",
                          validator: AddProductValidator.daysValidator,
                          controller: _days_for_d1_controller,
                          W: 175,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainTextField(
                          label: "Discount",
                          type: "number",
                          validator: AddProductValidator.discountValidator,
                          controller: _discount_2_controller,
                          W: 175,
                        ),
                        MainTextField(
                          label: "Days befor discount",
                          type: "number",
                          validator: AddProductValidator.daysValidator,
                          controller: _days_for_d2_controller,
                          W: 175,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    MainTextField(
                      label: "Contact info",
                      type: "name",
                      validator: AddProductValidator.contactValidator,
                      controller: _contact_info_controller,
                      W: 360,
                    ),
                    SizedBox(height: 30),
                    MainTextField(
                      label: "Description",
                      type: "name",
                      validator: AddProductValidator.descriptionValidator,
                      controller: _description_controller,
                      W: 360,
                      H: 5,
                    ),
                    SizedBox(height: 30),
                    BlocListener<AddProductCubit, AddProductState>(
                      listener: (context, state) {
                        if (state is AddProductWaiting) {
                          MainMessage.getProgressIndicator(context);
                        }
                        if (state is AddProductSuccess) {
                          Navigator.pop(context);
                          MainMessage.getSnackBar(
                            "Product added successfully",
                            AllColors.secondryColor,
                            context,
                          );
                          Navigator.pop(context);
                        }
                        if (state is AddProductFailed) {
                          Navigator.pop(context);
                          MainMessage.getSnackBar(
                            state.exception,
                            AllColors.errorColor,
                            context,
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainButton(
                            color: AllColors.secondryColor,
                            label: "Add",
                            function: () {
                              if (_formkey.currentState!.validate() &&
                                  _image != null) {
                                BlocProvider.of<AddProductCubit>(context).add(
                                  product: Product(
                                    image: _image,
                                    name: _name_controller.text,
                                    type: _type_controller.text,
                                    price: double.parse(_price_controller.text),
                                    product_count:
                                        int.parse(_count_controller.text),
                                    expires_at: _expires_date,
                                    discount_1: double.parse(
                                        _discount_1_controller.text),
                                    discount_2: double.parse(
                                        _discount_2_controller.text),
                                    days_before_discount_1:
                                        int.parse(_days_for_d1_controller.text),
                                    days_before_discount_2:
                                        int.parse(_days_for_d2_controller.text),
                                    contact_info: _contact_info_controller.text,
                                    description: _description_controller.text,
                                  ),
                                );
                              } else if (_image == null) {
                                MainMessage.getSnackBar(
                                  "Please enter image for your product",
                                  AllColors.errorColor,
                                  context,
                                );
                              }
                            },
                            W: 175,
                          ),
                          MainButton(
                            color: AllColors.errorColor,
                            label: "Cancel",
                            function: () => Navigator.pop(context),
                            W: 175,
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
      BlocProvider.of<ImageCubit>(context).Change();
    } on PlatformException catch (e) {
      MainMessage.getSnackBar(
        "Failed to load image",
        AllColors.errorColor,
        context,
      );
    }
  }

  void datePicker(DateTime? value, BuildContext context) {
    if (value == null) return;
    _expires_date = value;
    _temp.text = AllColors.formatter.format(_expires_date!);
    BlocProvider.of<DateCubit>(context).Change();
  }

  Future<DateTime?> showpicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(new Duration(days: 1)),
      firstDate: DateTime.now().add(new Duration(days: 1)),
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
}
