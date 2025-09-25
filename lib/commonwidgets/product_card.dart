// import 'package:flutter/material.dart';
//
// import '../constants/colors.dart';
// import '../views/Home/details.dart';
//
// class ProductCard extends StatefulWidget {
//   final String imagePath;
//   final String name;
//   final String price;
//   final VoidCallback? onTap;
//   final bool isFavorited;
//   final VoidCallback? onFavoriteTap;
//   final VoidCallback? onAddToCartTap;
//
//   const ProductCard({
//     super.key,
//     required this.imagePath,
//     required this.name,
//     required this.price,
//     this.onTap,
//     this.isFavorited = false,
//     this.onFavoriteTap,
//     this.onAddToCartTap,
//   });
//
//   @override
//   State<ProductCard> createState() => _ProductCardState();
// }
//
// class _ProductCardState extends State<ProductCard> {
//   late bool _isFavorited;
//
//   @override
//   void initState() {
//     super.initState();
//     _isFavorited = widget.isFavorited;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(context, MaterialPageRoute(builder: (_)=>StarterBatteryDetailsScreen()));
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(7),
//           boxShadow: [
//             BoxShadow(
//            color: Color.fromARGB((0.1 * 255).toInt(), 33, 150, 243),
//               spreadRadius: 2,
//               blurRadius: 7,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: _buildImageSection(context),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.name,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '\$${widget.price}', // or 'widget.price' if it's already formatted
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.buttonColor,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: widget.onAddToCartTap,
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: AppColors.buttonColor,
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Icon(Icons.add,
//                               size: 16, color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageSection(BuildContext context) {
//     return Stack(
//       children: [
//         SizedBox(height: 10,),
//         SizedBox(
//           height: 180,
//           width: double.infinity,
//           child: Container(
//             margin: EdgeInsets.only(left: 25),
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//               image: DecorationImage(
//                 image: AssetImage(widget.imagePath),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 1,
//           left: 1,
//           child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 _isFavorited = !_isFavorited;
//               });
//               if (widget.onFavoriteTap != null) {
//                 widget.onFavoriteTap!();
//               }
//             },
//             child: CircleAvatar(
//               radius: 14,
//               backgroundColor: Colors.black54,
//               child: Icon(
//                 _isFavorited ? Icons.favorite : Icons.favorite_border,
//                 size: 18,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }