// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '/screen/payment/payment_list_screen.dart';
// import '/screen/payment/select_card_screen.dart';

// import '../../widgets/custom_appbar.dart';
// import '../../widgets/payment_transaction_card.dart';
// import '/constants/img_font_color_string.dart';
// import '/widgets/cust_image.dart';
// import '/widgets/image_slider.dart';
// import '../../widgets/custom_text.dart';

// List<String> statusList = [
//   "Done",
//   "Pending",
//   "Failed",
// ];

// class PaymentScreen extends StatelessWidget {
//   const PaymentScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppbar(
//         title: StaticString.paymentScreen,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(
//                 height: 18,
//               ),
//               //Image Slider
//               const ImageSlider(),

//               const SizedBox(
//                 height: 28,
//               ),

//               /// Transactions And Show All text
//               _buildTransactionAndShowAllText(context),
//               const SizedBox(
//                 height: 14,
//               ),
//               ListView.builder(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 7,
//                 ),
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: statusList.length,
//                 itemBuilder: (_, index) => PaymentTransactionCard(
//                   image: ImgName.image1,
//                   name: "James Gouse",
//                   date: "18 January, 2022",
//                   rate: "566",
//                   context: context,
//                   status: statusList[index],
//                 ),
//               ),

//               const SizedBox(
//                 height: 16,
//               ),

//               /// Add New Card Button
//               _buildAddNewCardButton(),

//               const SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// //!---------------------------- widget ---------------------------------

//   /// Transaction And Show All text
//   Widget _buildTransactionAndShowAllText(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CustomText(
//             txtTitle: StaticString.transactions, // Transactions
//             style: Theme.of(context).textTheme.bodyText2?.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//           ),
//           InkWell(
//             onTap: _viewAll,
//             child: CustomText(
//               txtTitle: StaticString.viewAll, // show All
//               style: Theme.of(context).textTheme.caption?.copyWith(
//                     color: primaryColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   /// Add New Card Button

//   Widget _buildAddNewCardButton() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 90,
//       ),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           shadowColor: const Color.fromRGBO(172, 172, 172, 0.5),
//           elevation: 10,
//         ),
//         onPressed: _addNewCard,
//         child: const CustomText(
//           txtTitle: StaticString.addNewCard, // Add Neew Card
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   //!-------------------------------- Button Action---------------------
//   // View All
//   void _viewAll() {
//     debugPrint(
//         "***************************** View All Payments ************************");
//     Get.toNamed("PaymentListScreen");
//   }

//   // Add New Card Buttomn
//   void _addNewCard() {
//     debugPrint(
//         "***************************** Add New Card ************************");
//     Get.toNamed("SelectCardScreen");
//     // Get.to(SelectCardScreen());
//   }
// }
