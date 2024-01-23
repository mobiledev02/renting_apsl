import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/models/customer_card.dart';

import '../../constants/img_font_color_string.dart';
import '../../controller/payment_controller.dart';
import '../../widgets/custom_text.dart';

class CardListTile extends GetView<PaymentController> {
  final CustomerCard customerCard;

  const CardListTile({Key? key, required this.customerCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () {
          controller.selectACard(customerCard);
          controller.update();
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: Colors.grey.shade200,
              ),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        customerCard.selected
                            ? Image.asset(
                                'assets/images/payment_tick_green.png',
                                height: 25,
                              )
                            : Image.asset(
                                'assets/images/payment_tick.png',
                                height: 25,
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        customerCard.brand == 'Visa'
                            ? SvgPicture.asset(
                                'assets/images/visaCard.svg',
                                height: 35,
                              )
                            : customerCard.brand == 'Master'
                                ? SvgPicture.asset(
                                    'assets/images/visaCard.svg',
                                    height: 35,
                                  )
                                : const SizedBox(),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          txtTitle: "**** **** ${customerCard.last4}",
                          style: Theme.of(context).textTheme.overline?.copyWith(
                              color: custBlack102339WithOpacity, height: 2),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
