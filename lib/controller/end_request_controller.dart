import 'package:get/get_state_manager/get_state_manager.dart';
import '/constants/img_font_color_string.dart';
import '/models/end_request_model.dart';

class EndRequestController extends GetxController {
  static const endRequestJson = {
    "title": "MacBook Air with Apple M1 chip",
    "image": [ImgName.image1, ""],
    "location": "Buffalo, New York",
    "date": "08, October 2020",
    "termAndCondition":
        "This rental agreement or lease deed format can be used by #the #lessor or lessee of a residential property. It is signed by the lessee and lessor to indicate agreement to the conditions placed by the lessor. It is signed by the lessee and lessor to indicate agreement to the conditions placed by the lessor. It is a legal document having force of law which may be referenced by courts in the event of a disagreement. The rental agreement must be printed on a Non-Judicial Stamp Paper with a value of Rs.100/- or more. The rental agreement is usually signed on payment of deposit for the rental property between the lessor and the lessee. Two copies of the document are usually executed, with each party retaining one of the original copies."
  };

  EndRequestModel endRequestData = EndRequestModel.fromJson(endRequestJson);
// List<EndRequestController> listOfEndRequest = List<EndRequestController>.from(
//   listOfEndRequestJson.map(
//     (e) => EndRequestModel.fromJson(e),
//   ),
// );

// List<EndRequestController> get getItemList => listOfEndRequest;
}
