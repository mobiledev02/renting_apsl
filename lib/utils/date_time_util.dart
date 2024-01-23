import 'package:intl/intl.dart';

   String formatDateDDMMYYYY(DateTime? date) {
    final format =  DateFormat('MM/dd/yyyy');
    if(date != null) {
      return format.format(date);
    } else {
      return '';
    }
   }



String formatDateYMD(DateTime? date) {
  final format =  DateFormat('yyyy-MM-dd');
  if(date != null) {
    return format.format(date);
  } else {
    return '';
  }
}

   String formatTimeHM(DateTime? date) {
     if(date != null) {
       return DateFormat('h:mm a').format(date);
     } else {
       return 'null';
     }
   }
