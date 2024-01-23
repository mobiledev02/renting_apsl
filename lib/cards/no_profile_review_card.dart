import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constants/img_font_color_string.dart';
import '../models/review_model.dart';
import '../widgets/cust_image.dart';
import '../widgets/custom_text.dart';

class NoProfileReviewCard extends StatelessWidget {
  final ReviewModel review;

  const NoProfileReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CustImage(
                  width: 60,
                  height: 42,
                  cornerRadius: 12,
                  imgURL: review.givenBy != null
                      ? review.givenBy!.profileImage
                      : "",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    height: 42,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          txtTitle: review.givenBy != null
                              ? review.givenBy!.name
                              : "",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                        ),
                        CustomText(
                          txtTitle: review.itemServiceName ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 12),
                        ),
                        const SizedBox(),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                RatingBar.builder(
                  initialRating: review.rating,
                  itemSize: 20,
                  minRating: 1,
                  ignoreGestures: true,
                  allowHalfRating: true,
                  unratedColor: Colors.grey.withAlpha(50),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    size: 5,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CustomText(
                  txtTitle: review.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: custBlack102339WithOpacity),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
