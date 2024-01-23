import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/constants/img_font_color_string.dart';
import '/widgets/cust_image.dart';
import '/widgets/custom_appbar.dart';
import '../../utils/custom_enum.dart';
import '../../widgets/custom_text.dart';

class SelectCardScreen extends StatefulWidget {
  const SelectCardScreen({Key? key}) : super(key: key);

  @override
  State<SelectCardScreen> createState() => _SelectCardScreenState();
}

class _SelectCardScreenState extends State<SelectCardScreen> {
  //!-------------------------------------- variable --------------------------
  Cards? _selectedCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: StaticString.payWith.replaceAll(":", ""),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.00),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10.00,
              ),
              CustomText(
                txtTitle: StaticString.addNewCard,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(
                height: 20.00,
              ),
              Expanded(
                child: ListView(
                  children: Cards.values
                      .map(
                        (e) => _buildCard(
                          context: context,
                          image: ImgName.cardImage(e),
                          title: e,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //!------------------------------------------------ Widget -------------------------------------
  /// Card
  Widget _buildCard({
    required BuildContext context,
    required String image,
    required Cards title,
  }) {
    return Container(
      height: 46,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          // width: 1,
          color: custBlack102339.withOpacity(0.04),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => _selectCard(card: title),
            child: CustImage(
              imgURL: ImgName.check,
              imgColor: _selectedCard == title
                  ? primaryColor
                  : custBlack102339.withOpacity(0.1),
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          CustImage(
            imgURL: image,
            width: 40,
            height: 24,
          ),
          const SizedBox(
            width: 10,
          ),
          CustomText(
            txtTitle: describeEnum(title).replaceAll("_", " "),
            style: Theme.of(context).textTheme.overline?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          )
        ],
      ),
    );
  }

  //!------------------------------- Button Action -----------------------------------
  void _selectCard({required Cards card}) {
    debugPrint(
        "******************************** Select Card ***************************************");
    setState(() {
      _selectedCard = card;
    });
  }
}
