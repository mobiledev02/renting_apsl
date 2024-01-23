import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/custom_url_model.dart';
import '../api/api_end_points.dart';
import '../constants/img_font_color_string.dart';
import '../widgets/custom_text.dart';

class URLSwitcher extends StatelessWidget {
  const URLSwitcher({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SimultaneousTapDetectionButton(
        fireAction: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (ctx) => ProductionStagingURLScreen(),
            ),
          );
        },
        child: child);
  }
}

class ProductionStagingURLScreen extends StatefulWidget {
  ProductionStagingURLScreen({Key? key}) : super(key: key);

  @override
  _ProductionStagingURLScreenState createState() =>
      _ProductionStagingURLScreenState();
}

class _ProductionStagingURLScreenState
    extends State<ProductionStagingURLScreen> {
  // Key...
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // form validation mode...
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  TextEditingController _baseURLController = TextEditingController();
  List<CustomUrl> _customURL = [];

  bool get isCustomURL =>
      _baseURLController.text != APISetup.productionURL &&
      _baseURLController.text != APISetup.stagingURL;

  @override
  void initState() {
    super.initState();

    _customURL = ProductionStagingURL.getCustomBaseURLList;
    _baseURLController.text = _customURL
        .firstWhere((url) => url.isActiveURL, orElse: () => CustomUrl())
        .baseUrl;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Restore Button...
            SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(custMaterialPrimaryColor),
                ),
                onPressed: _resetURLButtonAction,
                child: CustomText(
                  txtTitle: "Reset",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            // Close button...
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: custMaterialPrimaryColor,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            // Set Button...
            SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(custMaterialPrimaryColor),
                ),
                onPressed: _setURLButtonAction,
                child: CustomText(
                  txtTitle: "Set",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ],
        ),
        appBar: AppBar(
          elevation: 1.0,
          shadowColor: Colors.white,
          leading: SizedBox(),

          // Appbar title...
          title: CustomText(
            txtTitle: "Set Base URL",
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: _buildBody(),
      ),
    );
  }

  // Body...
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom url textfield...
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            height: isCustomURL ? 70.0 : 0.0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              opacity: isCustomURL ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: _baseURLController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Enter base URL",
                      suffixIcon: _baseURLController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: _clearURLText,
                            ),
                    ),
                    onSaved: onSaveURL,
                    onChanged: (text) {
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    validator: (text) => text?.trim().isEmpty ?? true
                        ? "Please enter your base url"
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          // Custom URL List...
          Expanded(
            child: ListView.separated(
              itemCount: _customURL.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: custMaterialPrimaryColor,
              ),
              itemBuilder: (BuildContext context, int index) {
                final CustomUrl urlInfo = _customURL[index];
                // Base URL Type...
                List<Widget> rowChild = [
                  Expanded(
                    child: CustomText(
                      txtTitle: urlInfo.getBaseURLType,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: custMaterialPrimaryColor),
                    ),
                  ),
                ];
                if (urlInfo.isActiveURL) {
                  rowChild.add(SizedBox(width: 10.0));
                  rowChild.add(
                    // Currently in Use lable...
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          4.0,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2.0),
                      child: CustomText(
                        txtTitle: CustomUrl.currentlyInUse,
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: custMaterialPrimaryColor,
                            ),
                      ),
                    ),
                  );
                }

                return RadioListTile<String>(
                  activeColor: custMaterialPrimaryColor,
                  value: urlInfo.baseUrl,
                  groupValue: _baseURLController.text,
                  // Base URL...
                  title: urlInfo.baseUrl != APISetup.productionURL &&
                          urlInfo.baseUrl != APISetup.stagingURL
                      ? CustomText(
                          txtTitle: urlInfo.baseUrl,
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    color: custMaterialPrimaryColor,
                                  ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: rowChild,
                        ),
                  // URL Info...
                  subtitle: urlInfo.baseUrl != APISetup.productionURL &&
                          urlInfo.baseUrl != APISetup.stagingURL
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: rowChild,
                          ),
                        )
                      : null,
                  onChanged: (text) {
                    if (mounted) {
                      setState(() {
                        _baseURLController.text = text?.trim() ?? "";
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------------------------------------------ Button Action --------------------------------------------------------------------------//

  // Set URL Action...
  void _setURLButtonAction() {
    FocusScope.of(context).requestFocus(FocusNode());

    // Validate Form fields data and return if data is not validated...
    if (!(_formKey.currentState?.validate() ?? true)) {
      if (mounted) {
        setState(() => _autoValidate = AutovalidateMode.always);
      }
      return;
    }

    // Save Detail if form data is validated...
    _formKey.currentState?.save();

    // Save url data...
    ProductionStagingURL.setCustomBaseURLs = _customURL;

    // showToast("The new URL is set successfully");

    Get.back();

    Get.showSnackbar(
      const GetSnackBar(
        message: "The new URL is set successfully",
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Reset Button Action...
  void _resetURLButtonAction() {
    FocusScope.of(context).requestFocus(FocusNode());

    _customURL.clear();
    _customURL.addAll([
      CustomUrl(
        baseUrl: APISetup.productionURL,
        isActiveURL: true,
      ),
      CustomUrl(
        baseUrl: APISetup.stagingURL,
      ),
      CustomUrl(
        baseUrl: APISetup.localURL,
      )
    ]);

    // Save url data...
    ProductionStagingURL.setCustomBaseURLs = _customURL;
    _baseURLController.text = _customURL
        .firstWhere((url) => url.isActiveURL, orElse: () => CustomUrl())
        .baseUrl;

    showToast("Restored to default url successfully");
  }

  // Clear URL text action...
  void _clearURLText() {
    if (mounted) {
      setState(() {
        _baseURLController.clear();
      });
    }
  }

  // OnSave URL method...
  void onSaveURL(String? text) {
    _customURL.forEach((url) {
      url.isActiveURL = false;
    });
    final int index =
        _customURL.indexWhere((url) => url.baseUrl == (text?.trim() ?? ""));
    index < 0
        ? _customURL.add(
            CustomUrl(
              baseUrl: _baseURLController.text,
              date: DateTime.now().toUtc().toString(),
              isActiveURL: true,
            ),
          )
        : _customURL[index] = CustomUrl(
            baseUrl: _baseURLController.text,
            date: DateTime.now().toUtc().toString(),
            isActiveURL: true,
          );
  }
}

class ProductionStagingURL {
  static final String _baseURL = 'base_url';
  static SharedPreferences? _prefs;
  static List<CustomUrl> _customURLList = [];
  // Custom base URL...
  static set setCustomBaseURLs(List<CustomUrl> urls) {
    _customURLList = urls;
    _prefs?.setString(_baseURL, customUrListToJson(urls));
  }

  // Custom base url...
  static String get getCustomBaseURL =>
      _customURLList.firstWhere((url) => url.isActiveURL, orElse: () {
        return CustomUrl();
      }).baseUrl;

  // Custom base url...
  static List<CustomUrl> get getCustomBaseURLList => _customURLList;

  // Load saved data...
  static Future<void> loadSavedData() async {
    _prefs = await SharedPreferences.getInstance();
    _getBaseURLs();
  }

  // Base URL...
  static List<CustomUrl> _getBaseURLs() {
    final String urls = _prefs?.getString(_baseURL) ?? '';
    List<CustomUrl> customURLList = [];
    if (urls.isEmpty) {
      customURLList.addAll([
        CustomUrl(
          baseUrl: APISetup.productionURL,
          isActiveURL: true,
        ),
        CustomUrl(
          baseUrl: APISetup.stagingURL,
        ),
        CustomUrl(
          baseUrl: APISetup.localURL,
        )
      ]);
    } else {
      customURLList = customUrlListFromJson(urls);
    }

    _customURLList = customURLList;

    return customURLList;
  }

  // // Message collection key for firebase
  // static String getMessageCollectionKey() {
  //   String newMessageCollectionKey = StaticString.productionMessageCollection;
  //   if (APISetup.localURL == ProductionStagingURL.getCustomBaseURL) {
  //     newMessageCollectionKey = StaticString.localMessageCollection;
  //   } else if (APISetup.stagingURL == ProductionStagingURL.getCustomBaseURL) {
  //     newMessageCollectionKey = StaticString.staggingMessageCollection;
  //   } else {
  //     newMessageCollectionKey = StaticString.productionMessageCollection;
  //   }
  //   return newMessageCollectionKey;
  // }

  // // User collection key for firebase
  // static String getUserCollectionKey() {
  //   String newUserCollectionKey = StaticString.productionUsersCollection;
  //   if (APISetup.localURL == ProductionStagingURL.getCustomBaseURL) {
  //     newUserCollectionKey = StaticString.localUsersCollection;
  //   } else if (APISetup.stagingURL == ProductionStagingURL.getCustomBaseURL) {
  //     newUserCollectionKey = StaticString.staggingUsersCollection;
  //   } else {
  //     newUserCollectionKey = StaticString.productionUsersCollection;
  //   }
  //   return newUserCollectionKey;
  // }

  // // Event collection key for firebase
  // static String getEventCollectionKey() {
  //   String newUserCollectionKey = StaticString.productionUsersCollection;
  //   if (APISetup.localURL == ProductionStagingURL.getCustomBaseURL) {
  //     newUserCollectionKey = StaticString.localEventsCollection;
  //   } else if (APISetup.stagingURL == ProductionStagingURL.getCustomBaseURL) {
  //     newUserCollectionKey = StaticString.staggingEventsCollection;
  //   } else {
  //     newUserCollectionKey = StaticString.productionEventsCollection;
  //   }
  //   return newUserCollectionKey;
  // }
}

class SimultaneousTapDetectionButton extends StatefulWidget {
  final int tapsToFireAction;
  final Function fireAction;
  final Widget child;

  SimultaneousTapDetectionButton({
    this.tapsToFireAction = 2,
    required this.fireAction,
    required this.child,
  });

  @override
  _SimultaneousTapDetectionButtonState createState() =>
      _SimultaneousTapDetectionButtonState();
}

class _SimultaneousTapDetectionButtonState
    extends State<SimultaneousTapDetectionButton> {
  int simultaneousTaps = 0;
  int lastTap = DateTime.now().millisecondsSinceEpoch;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        // Get milisecond when user taps...
        final int now = DateTime.now().millisecondsSinceEpoch;

        // Compare last taps time and current tap time, it should be less then 600 milisecond(you can increase as per your requirement of tap delay)...
        if (now - lastTap < 600 || simultaneousTaps == 0) {
          // Increase tap count...
          simultaneousTaps++;

          // Fire action when matched with out target count tap count...
          if (simultaneousTaps == widget.tapsToFireAction) {
            if (widget.fireAction == null) return;
            widget.fireAction();

            // reset to zero on fire...
            simultaneousTaps = 0;
          }
        } else {
          // Reset to zero if tap are not too frequent...
          simultaneousTaps = 0;
        }

        // Assign now tapped time to last taped time...
        lastTap = now;
      },
      child: widget.child,
    );
  }
}

enum URLType {
  Staging,
  Production,
  Local,
  None,
}


// import '../api/api_end_points.dart';
// import '../widgets/custom_text.dart';

// class URLSwitcher extends StatelessWidget {
//   const URLSwitcher({
//     Key? key,
//     required this.child,
//   }) : super(key: key);
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return SimultaneousTapDetectionButton(
//         fireAction: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               fullscreenDialog: true,
//               builder: (ctx) => ProductionStagingURLScreen(),
//             ),
//           );
//         },
//         child: child);
//   }
// }

// class ProductionStagingURLScreen extends StatefulWidget {
//   ProductionStagingURLScreen({Key? key}) : super(key: key);

//   @override
//   _ProductionStagingURLScreenState createState() =>
//       _ProductionStagingURLScreenState();
// }

// class _ProductionStagingURLScreenState
//     extends State<ProductionStagingURLScreen> {
//   // Key...
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   // form validation mode...
//   AutovalidateMode _autoValidate = AutovalidateMode.disabled;
//   TextEditingController _baseURLController = TextEditingController();
//   List<CustomUrl> _customURL = [];

//   bool get isCustomURL =>
//       _baseURLController.text != APISetup.productionURL &&
//       _baseURLController.text != APISetup.stagingURL;

//   @override
//   void initState() {
//     super.initState();

//     _customURL = ProductionStagingURL.getCustomBaseURLList;

//     _baseURLController.text = _customURL
//         .firstWhere((url) => url.isActiveURL, orElse: () => CustomUrl())
//         .baseUrl;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         FocusScope.of(context).requestFocus(FocusNode());
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 1.0,
//           shadowColor: Colors.white,
//           leading: IconButton(
//             icon: Icon(Icons.close),
//             onPressed: () {
//               if (Navigator.of(context).canPop()) Navigator.of(context).pop();
//             },
//           ),
//           actions: [
//             // Set Button...
//             TextButton(
//               child: CustomText(
//                 txtTitle: "Set",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1
//                     ?.copyWith(color: Theme.of(context).primaryColor),
//               ),
//               onPressed: _setURLButtonAction,
//             ),
//             // Restore Button...
//             TextButton(
//               child: CustomText(
//                 txtTitle: "Restore",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1
//                     ?.copyWith(color: Theme.of(context).primaryColor),
//               ),
//               onPressed: _resetURLButtonAction,
//             )
//           ],
//           // Appbar title...
//           title: CustomText(
//             txtTitle: "Select API Base URL",
//             style: Theme.of(context)
//                 .textTheme
//                 .headline1
//                 ?.copyWith(color: Theme.of(context).primaryColor),
//           ),
//         ),
//         body: _buildBody(),
//       ),
//     );
//   }

//   // Body...
//   Widget _buildBody() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Custom url textfield...
//           AnimatedContainer(
//             duration: Duration(milliseconds: 200),
//             curve: Curves.fastOutSlowIn,
//             height: isCustomURL ? 70.0 : 0.0,
//             child: AnimatedOpacity(
//               duration: Duration(milliseconds: 150),
//               curve: Curves.easeInOut,
//               opacity: isCustomURL ? 1 : 0,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 15.0),
//                 child: Form(
//                   key: _formKey,
//                   autovalidateMode: _autoValidate,
//                   child: TextFormField(
//                     cursorColor: Theme.of(context).primaryColor,
//                     controller: _baseURLController,
//                     textInputAction: TextInputAction.done,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       hintText: "Enter base URL",
//                       suffixIcon: _baseURLController.text.isEmpty
//                           ? null
//                           : IconButton(
//                               icon: Icon(Icons.clear_rounded),
//                               onPressed: _clearURLText,
//                             ),
//                     ),
//                     onSaved: onSaveURL,
//                     onChanged: (text) {
//                       if (mounted) {
//                         setState(() {});
//                       }
//                     },
//                     onEditingComplete: () => FocusScope.of(context).unfocus(),
//                     validator: (text) => text?.trim().isEmpty ?? true
//                         ? "Please enter your base url"
//                         : null,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 10.0),
//           // Custom URL List...
//           Expanded(
//             child: ListView.separated(
//               itemCount: _customURL.length,
//               separatorBuilder: (BuildContext context, int index) => Divider(),
//               itemBuilder: (BuildContext context, int index) {
//                 CustomUrl urlInfo = _customURL[index];
//                 // Base URL Type...
//                 List<Widget> rowChild = [
//                   CustomText(
//                     txtTitle: urlInfo.getBaseURLType,
//                     style: Theme.of(context)
//                         .textTheme
//                         .caption
//                         ?.copyWith(color: Theme.of(context).primaryColor),
//                   ),
//                 ];
//                 if (urlInfo.isActiveURL) {
//                   rowChild.add(SizedBox(width: 10.0));
//                   rowChild.add(
//                     // Currently in Use lable...
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(
//                           4.0,
//                         ),
//                       ),
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
//                       child: CustomText(
//                         txtTitle: CustomUrl.currentlyInUse,
//                         style: Theme.of(context)
//                             .textTheme
//                             .caption
//                             ?.copyWith(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   );
//                 }

//                 return RadioListTile<String>(
//                   activeColor: Theme.of(context).primaryColor,
//                   value: urlInfo.baseUrl,
//                   groupValue: _baseURLController.text,
//                   // Base URL...
//                   title: urlInfo.baseUrl != APISetup.productionURL &&
//                           urlInfo.baseUrl != APISetup.stagingURL
//                       ? CustomText(
//                           txtTitle: urlInfo.baseUrl,
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyText1
//                               ?.copyWith(color: Theme.of(context).primaryColor),
//                         )
//                       : Row(children: rowChild),
//                   // URL Info...
//                   subtitle: urlInfo.baseUrl != APISetup.productionURL &&
//                           urlInfo.baseUrl != APISetup.stagingURL
//                       ? Row(children: rowChild)
//                       : null,
//                   onChanged: (text) {
//                     if (mounted) {
//                       setState(() {
//                         _baseURLController.text = text?.trim() ?? "";
//                       });
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   //------------------------------------------------------------------ Button Action --------------------------------------------------------------------------//

//   // Set URL Action...
//   void _setURLButtonAction() {
//     FocusScope.of(context).requestFocus(FocusNode());

//     // Validate Form fields data and return if data is not validated...
//     if (!(_formKey.currentState?.validate() ?? true)) {
//       if (mounted) {
//         setState(() => _autoValidate = AutovalidateMode.always);
//       }
//       return;
//     }

//     // Save Detail if form data is validated...
//     _formKey.currentState?.save();

//     // if (_baseURLController.text == APISetup.localURL) {
//     //   APISetup.urlTypeToTest = URLType.Local;
//     // } else if (_baseURLController.text == APISetup.stagingURL) {
//     //   APISetup.urlTypeToTest = URLType.Staging;
//     // } else {
//     //   APISetup.urlTypeToTest = URLType.Production;
//     // }

//     // SharedPreferencesHelper.setApiUrlType =
//     //     APISetup.urlTypeToTest.toString().split(".").last;

//     // ProductionStagingURL.getUserCollectionKey() =
//     //     APISetup.urlTypeToTest.getEnumName.toLowerCase() + "_users";
//     // ProductionStagingURL.getEventCollectionKey() =
//     //     APISetup.urlTypeToTest.getEnumName.toLowerCase() + "_events";

//     // ProductionStagingURL.getMessageCollectionKey() =
//     //     APISetup.urlTypeToTest.getEnumName.toLowerCase() + "_messages";

//     // Save url data...
//     ProductionStagingURL.setCustomBaseURLs = _customURL;
//     showToast("The new URL is set successfully");

//     if (Navigator.of(context).canPop()) Navigator.of(context).pop();
//   }

//   // Reset Button Action...
//   void _resetURLButtonAction() {
//     FocusScope.of(context).requestFocus(FocusNode());

//     _customURL.clear();
//     _customURL.addAll([
//       CustomUrl(
//         baseUrl: APISetup.productionURL,
//         isActiveURL: true,
//       ),
//       CustomUrl(
//         baseUrl: APISetup.stagingURL,
//       ),
//       CustomUrl(
//         baseUrl: APISetup.localURL,
//       )
//     ]);

//     // Save url data...
//     ProductionStagingURL.setCustomBaseURLs = _customURL;
//     _baseURLController.text = _customURL
//         .firstWhere((url) => url.isActiveURL, orElse: () => CustomUrl())
//         .baseUrl;

//     showToast("Restored to default url successfully");
//   }

//   // Clear URL text action...
//   void _clearURLText() {
//     if (mounted) {
//       setState(() {
//         _baseURLController.clear();
//       });
//     }
//   }

//   // OnSave URL method...
//   void onSaveURL(String? text) {
//     _customURL.forEach((url) {
//       url.isActiveURL = false;
//     });
//     int index =
//         _customURL.indexWhere((url) => url.baseUrl == (text?.trim() ?? ""));
//     index < 0
//         ? _customURL.add(
//             CustomUrl(
//               baseUrl: _baseURLController.text,
//               date: DateTime.now().toUtc().toString(),
//               isActiveURL: true,
//             ),
//           )
//         : _customURL[index] = CustomUrl(
//             baseUrl: _baseURLController.text,
//             date: DateTime.now().toUtc().toString(),
//             isActiveURL: true,
//           );
//   }
// }

// class ProductionStagingURL {
//   static final String _baseURL = 'base_url';
//   static late SharedPreferences _prefs;
//   static List<CustomUrl> _customURLList = [];
//   // Custom base URL...
//   static set setCustomBaseURLs(List<CustomUrl> urls) {
//     _customURLList = urls;
//     _prefs.setString(_baseURL, customUrListToJson(urls));
//   }

//   // Custom base url...
//   static String get getCustomBaseURL =>
//       _customURLList.firstWhere((url) => url.isActiveURL, orElse: () {
//         return CustomUrl();
//       }).baseUrl;

//   // Custom base url...
//   static List<CustomUrl> get getCustomBaseURLList => _customURLList;

//   // Load saved data...
//   static Future<void> loadSavedData() async {
//     _prefs = await SharedPreferences.getInstance();
//     _getBaseURLs();
//   }

//   // Base URL...
//   static List<CustomUrl> _getBaseURLs() {
//     String urls = _prefs.getString(_baseURL) ?? '';
//     List<CustomUrl> customURLList = [];
//     if (urls.isEmpty) {
//       customURLList.addAll([
//         CustomUrl(
//           baseUrl: APISetup.productionURL,
//           isActiveURL: true,
//         ),
//         CustomUrl(
//           baseUrl: APISetup.stagingURL,
//         ),
//         CustomUrl(
//           baseUrl: APISetup.localURL,
//         )
//       ]);
//     } else {
//       customURLList = customUrlListFromJson(urls);
//     }

//     _customURLList = customURLList;

//     return customURLList;
//   }
// }

// class SimultaneousTapDetectionButton extends StatefulWidget {
//   final int tapsToFireAction;
//   final Function fireAction;
//   final Widget child;

//   SimultaneousTapDetectionButton({
//     this.tapsToFireAction = 10,
//     required this.fireAction,
//     required this.child,
//   });

//   @override
//   _SimultaneousTapDetectionButtonState createState() =>
//       _SimultaneousTapDetectionButtonState();
// }

// class _SimultaneousTapDetectionButtonState
//     extends State<SimultaneousTapDetectionButton> {
//   int simultaneousTaps = 0;
//   int lastTap = DateTime.now().millisecondsSinceEpoch;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       highlightColor: Colors.transparent,
//       splashColor: Colors.transparent,
//       onTap: () async {
//         // Get milisecond when user taps...
//         int now = DateTime.now().millisecondsSinceEpoch;

//         // Compare last taps time and current tap time, it should be less then 600 milisecond(you can increase as per your requirement of tap delay)...
//         if (now - lastTap < 600 || simultaneousTaps == 0) {
//           // Increase tap count...
//           simultaneousTaps++;

//           // Fire action when matched with out target count tap count...
//           if (simultaneousTaps == widget.tapsToFireAction) {
//             widget.fireAction();

//             // reset to zero on fire...
//             simultaneousTaps = 0;
//           }
//         } else {
//           // Reset to zero if tap are not too frequent...
//           simultaneousTaps = 0;
//         }

//         // Assign now tapped time to last taped time...
//         lastTap = now;
//       },
//       child: widget.child,
//     );
//   }
// }

// enum URLType {
//   Staging,
//   Production,
//   Local,
//   None,
// }
