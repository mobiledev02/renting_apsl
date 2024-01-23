// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/img_font_color_string.dart';
import '../main.dart';
import '../models/request_model.dart';
import '../widgets/common_widgets.dart';
import '../widgets/cust_image.dart';
import '../widgets/custom_text.dart';

class RequestCard extends StatelessWidget {
  RequestCard({
    Key? key,
    required this.requestModel,
    this.onTap,
    this.isDelete = false,
    this.onDeleteTap,
  }) : super(key: key);
  RequestModel requestModel;
  Function()? onTap;
  bool isDelete = false;
  Function()? onDeleteTap;
  final DateFormat formatter = DateFormat("MMMM d,y");

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            // width: 100,
            decoration: BoxDecoration(
              color: custWhiteFFFFFF,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(16, 35, 57, 0.06),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        RequestCardIconAndText(
                          icon: ImgName.item,
                          title: requestModel.name,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        RequestCardIconAndText(
                          icon: ImgName.requestLocation,
                          title: requestModel.city,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        RequestCardIconAndText(
                          icon: ImgName.calender2,
                          title: formatter
                              .format(DateTime.parse(requestModel.needBy)),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: itemAndServiceTagCard(
                          ItemOrServices: requestModel.type),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Visibility(
            visible: isDelete,
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: onDeleteTap ?? () {},
                child: Container(
                  height: 26,
                  width: 36,
                  decoration: BoxDecoration(
                    color: custRedFF3F50.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.00),
                      bottomRight: Radius.circular(10.00),
                    ),
                  ),
                  child: CustImage(
                    imgURL: ImgName.delete,
                    width: 10.12,
                    height: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//  Request Card Icon And Text
Widget RequestCardIconAndText({required String icon, required String title}) {
  return Column(
    children: [
      Row(
        children: [
          CustImage(
            imgURL: icon,
            height: 16,
            width: 16,
            boxfit: BoxFit.contain,
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: CustomText(
              txtTitle: title,
              style: Theme.of(getContext).textTheme.caption?.copyWith(
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
          ),
        ],
      ),
    ],
  );
}
