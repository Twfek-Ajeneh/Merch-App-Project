import 'package:flutter/material.dart';

import 'package:project/model/product.dart';
import 'package:project/tools/colors.dart';

class MainItemField extends StatelessWidget {
  const MainItemField({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AllColors.thirdColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 105,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                product.image_url!,
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
          SizedBox(width: 15),
          Container(
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name!,
                    style: TextStyle(
                      color: AllColors.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${product.price}\$",
                            style: TextStyle(
                              color: Color(0xFF007C48),
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: 8),
                          product.original_price != product.price
                              ? Text(
                                  "${product.original_price}\$",
                                  style: TextStyle(
                                    color: AllColors.errorColor,
                                    fontSize: 15,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.thumb_up_alt_outlined,
                                size: 16,
                                color: AllColors.mainColor,
                              ),
                              SizedBox(height: 3),
                            ],
                          ),
                          SizedBox(width: 3),
                          Text(
                            "${product.like_count}  ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: AllColors.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "Category:  ${product.type}",
                    style: TextStyle(
                      color: AllColors.mainColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "Expired date:  ${AllColors.formatter.format(product.expires_at!)}",
                    style: TextStyle(
                      color: AllColors.mainColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
