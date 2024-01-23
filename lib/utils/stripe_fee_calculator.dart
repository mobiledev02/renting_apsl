import 'package:flutter/material.dart';

const serviceStripeFeeFactor = 3;
const additionalStripeCharge = 0.30;

/// 30 cents
double getServiceFeeTotal(double totalPayment) {
  
  return double.parse(
      ((totalPayment * serviceStripeFeeFactor / 100) + additionalStripeCharge)
          .toStringAsFixed(2));
}

const chekrFee = 31.25;
