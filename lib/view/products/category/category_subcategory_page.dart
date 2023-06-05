// import 'package:amazy_app/AppConfig/app_config.dart';
// import 'package:amazy_app/model/Category/CategoryData.dart';
// import 'package:amazy_app/model/Category/CategoryMain.dart';
// import 'package:amazy_app/model/Category/ParentCategory.dart';
// import 'package:amazy_app/model/Category/SingleCategory.dart';
// import 'package:amazy_app/network/config.dart';
// import 'package:amazy_app/utils/styles.dart';
// import 'package:amazy_app/view/products/category/ProductsByCategory.dart';
// import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
// import 'package:amazy_app/widgets/custom_loading_widget.dart';
// import 'package:amazy_app/widgets/fa_icon_maker/fa_custom_icon.dart';
// import 'package:dio/dio.dart';
// import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CategorySubCategoryScreen extends StatefulWidget {
//   @override
//   State<CategorySubCategoryScreen> createState() =>
//       _CategorySubCategoryScreenState();
// }

// class _CategorySubCategoryScreenState extends State<CategorySubCategoryScreen> {
//   Dio _dio = Dio();

//   Future category;

//   Future<CategoryMain> getCategories() async {
//     CategoryMain categoryMain;

//     try {
//       await _dio
//           .get(
//         URLs.ALL_CATEGORY,
//       )
//           .then((value) {
//         var data = new Map<String, dynamic>.from(value.data);
//         categoryMain = CategoryMain.fromJson(data);
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//     return categoryMain;
//   }

//   @override
//   void initState() {
//     category = getCategories();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppStyles.appBackgroundColor,
//       body: CustomScrollView(
//         slivers: [
//           CustomSliverAppBarWidget(true, true),
//           SliverToBoxAdapter(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
//                 ),
//               ),
//               child: Text(
//                 "Browse Categories",
//                 style: AppStyles.appFontMedium.copyWith(
//                   fontSize: 18,
//                   color: Color(0xff5C7185),
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
//                 ),
//               ),
//             ),
//           ),
//           SliverFillRemaining(
//             child: FutureBuilder<CategoryMain>(
//                 future: category,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Container(
//                       alignment: Alignment.center,
//                       width: 20,
//                       height: 20,
//                       child: CustomLoadingWidget(),
//                     );
//                   } else if (!snapshot.hasData) {
//                     return SizedBox.shrink();
//                   } else {
//                     final List<CategoryData> categoryList = snapshot.data.data
//                         .where((element) => element.parentId == 0)
//                         .toList();

//                     return ListView.separated(
//                       itemCount: categoryList.length,
//                       shrinkWrap: true,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                       separatorBuilder: (context, index) {
//                         return SizedBox(height: 20);
//                       },
//                       itemBuilder: ((context, index) {
//                         final CategoryData category = categoryList[index];
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(5),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(0x1a000000),
//                                 offset: Offset(0, 3),
//                                 blurRadius: 6,
//                                 spreadRadius: 0,
//                               )
//                             ],
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: 80,
//                                 height: 80,
//                                 padding: EdgeInsets.symmetric(horizontal: 10),
//                                 child: category.categoryImage == null
//                                     ? category.icon != null
//                                         ? Container(
//                                             child: Icon(
//                                               FaCustomIcon.getFontAwesomeIcon(
//                                                   category.icon),
//                                               size: 30,
//                                               color: Colors.black,
//                                             ),
//                                           )
//                                         : Container(
//                                             child: Icon(
//                                               Icons.list_alt_outlined,
//                                               size: 30,
//                                               color: Colors.black,
//                                             ),
//                                           )
//                                     : FancyShimmerImage(
//                                         imageUrl:
//                                             "${AppConfig.assetPath}/${category.categoryImage.image}",
//                                         boxFit: BoxFit.contain,
//                                         errorWidget: FancyShimmerImage(
//                                           imageUrl:
//                                               "${AppConfig.assetPath}/backend/img/default.png",
//                                           boxFit: BoxFit.contain,
//                                         ),
//                                       ),
//                               ),
//                               SizedBox(
//                                 width: 15,
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     category.name ?? "",
//                                     style: AppStyles.appFontBold,
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   IntrinsicHeight(
//                                     child: Row(
//                                       children: [
//                                         category.subCategories.length > 0
//                                             ? GestureDetector(
//                                                 onTap: () {
//                                                   Get.to(
//                                                     () => SubCategoryScreen(
//                                                       title: category.name,
//                                                       id: category.id,
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Container(
//                                                   alignment: Alignment.center,
//                                                   height: 20,
//                                                   child: Text(
//                                                     "View Sub-Categories",
//                                                     style: AppStyles
//                                                         .appFontLight
//                                                         .copyWith(
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                             : SizedBox.shrink(),
//                                         category.subCategories.length > 0
//                                             ? VerticalDivider()
//                                             : SizedBox.shrink(),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Get.to(
//                                               () => ProductsByCategory(
//                                                 categoryId: category.id,
//                                               ),
//                                             );
//                                           },
//                                           child: Container(
//                                             alignment: Alignment.center,
//                                             height: 20,
//                                             child: Text(
//                                               "View Products",
//                                               style: AppStyles.appFontLight
//                                                   .copyWith(
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         );
//                       }),
//                     );
//                   }
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SubCategoryScreen extends StatefulWidget {
//   final String title;
//   final int id;
//   SubCategoryScreen({this.title, this.id});

//   @override
//   State<SubCategoryScreen> createState() => _SubCategoryScreenState();
// }

// class _SubCategoryScreenState extends State<SubCategoryScreen> {
//   Dio _dio = Dio();

//   Future subCategory;

//   Future<SingleCategory> getSubCategory() async {
//     SingleCategory singleCategory;

//     try {
//       await _dio
//           .get(
//         URLs.ALL_CATEGORY + "/${widget.id}",
//       )
//           .then((value) {
//         var data = new Map<String, dynamic>.from(value.data);
//         singleCategory = SingleCategory.fromJson(data);
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//     return singleCategory;
//   }

//   @override
//   void initState() {
//     subCategory = getSubCategory();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppStyles.appBackgroundColor,
//       bottomNavigationBar: Container(
//         height: 100,
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 10,
//             ),
//             GestureDetector(
//               onTap: () {
//                 Get.to(() => ProductsByCategory(
//                       categoryId: widget.id,
//                     ));
//               },
//               child: Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   gradient: AppStyles.gradient,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 padding: EdgeInsets.all(12),
//                 child: Text(
//                   "View Products".tr,
//                   style: AppStyles.appFontMedium.copyWith(
//                     fontSize: 13,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: [
//           CustomSliverAppBarWidget(true, true),
//           SliverToBoxAdapter(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
//                 ),
//               ),
//               child: Text(
//                 "${widget.title}",
//                 style: AppStyles.appFontMedium.copyWith(
//                   fontSize: 18,
//                   color: Color(0xff5C7185),
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
//                 ),
//               ),
//             ),
//           ),
//           SliverFillRemaining(
//             child: FutureBuilder<SingleCategory>(
//                 future: subCategory,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Container(
//                       alignment: Alignment.center,
//                       width: 20,
//                       height: 20,
//                       child: CustomLoadingWidget(),
//                     );
//                   } else if (!snapshot.hasData) {
//                     return SizedBox.shrink();
//                   } else {
//                     final List<ParentCategory> categoryList =
//                         snapshot.data.data.subCategories.toList();
//                     if (categoryList.length == 0) {
//                       return ListView(
//                         physics: NeverScrollableScrollPhysics(),
//                         children: <Widget>[
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Container(
//                             child: Image.asset(
//                               AppConfig.appLogo,
//                               width: 30,
//                               height: 30,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             'No Sub-Categories found'.tr,
//                             style: AppStyles.kFontBlack17w5,
//                             textAlign: TextAlign.center,
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       );
//                     } else {
//                       return ListView.separated(
//                         itemCount: categoryList.length,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                         separatorBuilder: (context, index) {
//                           return SizedBox(height: 20);
//                         },
//                         itemBuilder: ((context, index) {
//                           final ParentCategory category = categoryList[index];
//                           return Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(5),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x1a000000),
//                                   offset: Offset(0, 3),
//                                   blurRadius: 6,
//                                   spreadRadius: 0,
//                                 )
//                               ],
//                             ),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   width: 80,
//                                   height: 80,
//                                   padding: EdgeInsets.symmetric(horizontal: 10),
//                                   child: category.categoryImage == null
//                                       ? category.icon != null
//                                           ? Container(
//                                               child: Icon(
//                                                 FaCustomIcon.getFontAwesomeIcon(
//                                                     category.icon),
//                                                 size: 30,
//                                                 color: Colors.black,
//                                               ),
//                                             )
//                                           : Container(
//                                               child: Icon(
//                                                 Icons.list_alt_outlined,
//                                                 size: 30,
//                                                 color: Colors.black,
//                                               ),
//                                             )
//                                       : FancyShimmerImage(
//                                           imageUrl:
//                                               "${AppConfig.assetPath}/${category.categoryImage.image}",
//                                           boxFit: BoxFit.contain,
//                                           errorWidget: FancyShimmerImage(
//                                             imageUrl:
//                                                 "${AppConfig.assetPath}/backend/img/default.png",
//                                             boxFit: BoxFit.contain,
//                                           ),
//                                         ),
//                                 ),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       category.name ?? "",
//                                       style: AppStyles.appFontBold,
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     IntrinsicHeight(
//                                       child: Row(
//                                         children: [
//                                           GestureDetector(
//                                             onTap: () {
//                                               Get.to(
//                                                 () => SubCategoryScreen(
//                                                   title: category.name,
//                                                   id: category.id,
//                                                 ),
//                                                 preventDuplicates: false,
//                                               );
//                                             },
//                                             child: Container(
//                                               alignment: Alignment.center,
//                                               height: 20,
//                                               child: Text(
//                                                 "View Sub-Categories",
//                                                 style: AppStyles.appFontLight
//                                                     .copyWith(
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           VerticalDivider(),
//                                           GestureDetector(
//                                             onTap: () {
//                                               print('next');
//                                               Get.to(
//                                                 () => ProductsByCategory(
//                                                   categoryId: category.id,
//                                                 ),
//                                               );
//                                             },
//                                             child: Container(
//                                               alignment: Alignment.center,
//                                               height: 20,
//                                               child: Text(
//                                                 "View Products",
//                                                 style: AppStyles.appFontLight
//                                                     .copyWith(
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                       );
//                     }
//                   }
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }