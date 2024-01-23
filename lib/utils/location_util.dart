 import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

Future<String> getLocalitySubLocality
(double latitude, double longitude) async {
  
   List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
   if(placemarks.isNotEmpty) {
     if(placemarks.first.country != null) {
       return '${placemarks.first.locality ?? placemarks.first.subLocality ?? ''}, ${placemarks.first.country}';
     }
     else {
       return '';
     }
   }
   else {
     return '';
   }
}