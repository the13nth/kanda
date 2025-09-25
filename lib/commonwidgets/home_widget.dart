// import 'package:flutter/material.dart';
//
// import '../../../widgets/detailstext1.dart';
// import '../constants/colors.dart';
//
// class HomeWidgte extends StatelessWidget {
//   const HomeWidgte({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Builder(builder: (context) {
//           return InkWell(
//             onTap: () {
//               Scaffold.of(context).openDrawer();
//             },
//             child: const Icon(
//               Icons.menu_outlined,
//               color: Colors.white,
//             ),
//           );
//         }),
//         const Text1(
//           text1: 'Home',
//           size: 16,
//           color: Colors.white,
//         ),
//         Container(
//           height: 42,
//           width: 42,
//           padding: const EdgeInsets.all(5),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: const Icon(
//             Icons.search,
//             color: AppColors.buttonColor,
//           ),
//         ),
//       ],
//     );
//   }
// }
