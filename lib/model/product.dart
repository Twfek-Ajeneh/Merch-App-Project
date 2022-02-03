import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:project/tools/colors.dart';

class Product {
  final int? id;
  final String? name;
  final File? image;
  final String? image_url;
  final DateTime? expires_at; //yyyy-mm-dd
  final String? type;
  final int? product_count;
  final double? price;
  final double? original_price;
  final String? contact_info;
  final double? discount_1;
  final double? discount_2;
  final int? days_before_discount_1;
  final int? days_before_discount_2;
  final int? view_count;
  final int? like_count;
  bool? isLiked;
  final String? description;
  final bool? is_owner;
  final List<dynamic>? comments;

  Product({
    this.id,
    this.name,
    this.image,
    this.image_url,
    this.expires_at,
    this.type,
    this.product_count,
    this.price,
    this.original_price,
    this.contact_info,
    this.discount_1,
    this.discount_2,
    this.days_before_discount_1,
    this.days_before_discount_2,
    this.view_count,
    this.like_count,
    this.isLiked,
    this.description,
    this.is_owner,
    this.comments,
  });

  Future<Map<String, dynamic>> toMap() async {
    return {
      'id': id,
      'name': name,
      'image': image != null
          ? await MultipartFile.fromFile(
              image!.path,
              filename: image!.path.split('/').last,
            )
          : null,
      'image_url': image_url,
      'expires_at': AllColors.formatter.format(expires_at!),
      'type': type,
      'product_count': product_count,
      'price': price,
      'original_price': original_price,
      'contact_info': contact_info,
      'discount_1': discount_1,
      'discount_2': discount_2,
      'days_before_discount_1': days_before_discount_1,
      'days_before_discount_2': days_before_discount_2,
      'view_count': view_count,
      'like_count': like_count,
      'isLiked': isLiked,
      'description': description,
      'is_owner': is_owner,
      'comments': comments,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] != null ? int.parse(map['id']) : null,
      name: map['name'],
      image: null,
      image_url: map['image_url'],
      expires_at: map['expires_at'] != null
          ? DateTime(
              int.parse(map['expires_at'].toString().split("-")[0]),
              int.parse(map['expires_at'].toString().split("-")[1]),
              int.parse(map['expires_at'].toString().split("-")[2]),
            )
          : null,
      type: map['type'],
      product_count:
          map['product_count'] != null ? int.parse(map['product_count']) : null,
      price: map['price'] != null ? double.parse(map['price']) : null,
      original_price: map['original_price'] != null
          ? double.parse(map['original_price'])
          : null,
      contact_info: map['contact_info'].toString(),
      discount_1:
          map['discount_1'] != null ? double.parse(map['discount_1']) : null,
      discount_2:
          map['discount_2'] != null ? double.parse(map['discount_2']) : null,
      days_before_discount_1: map['days_before_discount_1'] != null
          ? int.parse(map['days_before_discount_1'])
          : null,
      days_before_discount_2: map['days_before_discount_2'] != null
          ? int.parse(map['days_before_discount_2'])
          : null,
      view_count:
          map['view_count'] != null ? int.parse(map['view_count']) : null,
      like_count:
          map['like_count'] != null ? int.parse(map['like_count']) : null,
      isLiked: map['isLiked'] != null
          ? map['isLiked'].toLowerCase() == 'true'
          : null,
      description: map['description'],
      is_owner: map['is_owner'] != null
          ? map['is_owner'].toLowerCase() == 'true'
          : null,
      comments: json.decode(map['comments']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
