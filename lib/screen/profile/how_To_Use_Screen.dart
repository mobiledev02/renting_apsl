// ignore_for_file: prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '/controller/how_to_use_controller.dart';
import '/models/how_to_use_model.dart';
import '../../constants/img_font_color_string.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/cust_image.dart';
import '../../widgets/custom_text.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<HowToUseModel> items =
        Get.find<HowToUseController>().listOfHowToUse;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              Center(
                child: CustomText(
                  txtTitle: StaticString.appName.replaceAll("!", ""),
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontFamily: CustomFont.mochiyPopOne,
                        color: primaryColor,
                      ),
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              // Service List
              _buildServiceList(items, context),

              const SizedBox(
                height: 26,
              ),

              _contactUsWidget(context),

              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  //!------------------------------Widget-----------------------
  /// Appbar
  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustBackButton(),
        ],
      ),
      title: const CustomText(
        txtTitle: StaticString.howToUseApp, // Hoe to use app
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Service List

  Widget _buildServiceList(List<HowToUseModel> items, BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items
          .map(
            (data) => _buildServiceCard(data, context),
          )
          .toList(),
    );
  }

  /// Service card
  Widget _buildServiceCard(HowToUseModel data, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 35, 57, 0.08),
            blurRadius: 20.0,
          ),
        ],
        borderRadius: BorderRadius.circular(
          25,
        ),
      ),
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 20,
        right: 25,
        top: 18,
        bottom: 10,
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                25,
              ),
              border: Border.all(
                color: custBlack102339.withOpacity(
                  0.10,
                ),
                width: 1,
              ),
            ),
            child: CustImage(
              imgURL: data.icon,
              imgColor: primaryColor,
              width: 16,
              height: 16,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  txtTitle: data.title,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomText(
                  maxLine: 2,
                  textOverflow: TextOverflow.ellipsis,
                  txtTitle: data.description,
                  style: Theme.of(context).textTheme.overline?.copyWith(
                        color: custBlack102339.withOpacity(0.5),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Contact us
  Widget _contactUsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            txtTitle: 'Contact Us',
            style: Theme.of(getContext).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: _launchEmail,
            child: CustomText(
              txtTitle: 'Email: support@re-lend.com',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: custBlack102339.withOpacity(0.5),
                  ),
              // onPressed: _launchEmail,
              align: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }

  //!----------------------- Button Action -------------------

  Future<void> _launchEmail() async {
    try {
      final Uri uri = Uri.parse(
          'mailto:< support@re-lend.com>?subject=<subject>&body=<body>');
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e, st) {
      debugPrint('launch email error $e $st');
    }
  }
}
