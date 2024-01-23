import 'dart:convert';
import 'dart:developer';

import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/api/api_end_points.dart';
import 'package:renting_app_mobile/controller/chat_controller.dart';
import 'package:renting_app_mobile/controller/request_controller.dart';
import 'package:renting_app_mobile/models/item_detail_model.dart';
import 'package:renting_app_mobile/models/job_offer_model.dart';
import 'package:renting_app_mobile/utils/custom_extension.dart';
import 'package:renting_app_mobile/utils/dialog_utils.dart';
import 'package:renting_app_mobile/widgets/statusbar_content_style.dart';
import '../../../utils/custom_enum.dart';

import '../api/api_middleware.dart';
import '../constants/img_font_color_string.dart';
import 'auth_controller.dart';

class JobOfferController extends GetxController {
  RxList<JobOfferModel> jobOffers = <JobOfferModel>[].obs;
  RxList<JobOfferModel> allOffers = <JobOfferModel>[].obs;
  RxBool loadingJobOffers = false.obs;
  RxBool loadingSendJobOffer = false.obs;
  RxBool loadingCheckOffer = false.obs;
  Rxn<JobOfferModel> sentOffer = Rxn<JobOfferModel>();

  void updateSentOfferLocally(JobOfferModel offer) {
    debugPrint(offer.serviceId);
    debugPrint(offer.id.toString());
    debugPrint(jobOffers.length.toString());
    for (final JobOfferModel offers in jobOffers)
      {
        debugPrint("Test");
        debugPrint(offers.id.toString());
      }
    final index = jobOffers.indexWhere((p0) => p0.renter == offer.renter && p0.serviceProvider == offer.serviceProvider
                                              && p0.chatId == offer.chatId && p0.id == 0);
    jobOffers[index] = offer;
  }

  void updateOfferLocally(JobOfferModel offer) {
    final index = jobOffers.indexWhere((p0) => p0.id == offer.id);
    jobOffers[index] = offer;
  }

  void sortOffers(String sort) {
    if (sort == 'New') {
      jobOffers.sort((a, b) {
        final status = {
          'Pending': 0,
          'Accepted': 1,
          'Declined': 2,
          'Hired': 3,
          'Completed': 4
        };
        return status[a.status]!.compareTo(status[b.status]!);
      });
    } else if (sort == 'Accepted') {

      jobOffers.sort((a, b) {
        final status = {
          'Accepted': 0,
          'Pending': 1,
          'Declined': 2,
          'Hired': 3,
          'Completed': 4
        };
        return status[a.status]!.compareTo(status[b.status]!);
      });
    } else if (sort == 'Declined') {
      jobOffers.sort((a, b) {
        final status = {
          'Declined': 0,
          'Pending': 1,
          'Accepted': 2,
          'Hired': 3,
          'Completed': 4
        };
        return status[a.status]!.compareTo(status[b.status]!);
      });
    } else if (sort == 'Hired') {
      jobOffers.sort((a, b) {
        final status = {
          'Hired': 0,
          'Pending': 1,
          'Accepted': 2,
          'Declined': 3,
          'Completed': 4
        };
        return status[a.status]!.compareTo(status[b.status]!);
      });
    } else {
      jobOffers.sort((a, b) {
        final status = {
          'Completed': 0,
          'Pending': 1,
          'Accepted': 2,
          'Declined': 3,
          'Hired': 4,
        };
        return status[a.status]!.compareTo(status[b.status]!);
      });
    }
  }

  Future<void> sendJobOffer(
      BuildContext context, JobOfferModel jobOffer, String serviceId, String cardId) async {
    try {
      debugPrint('offer id with chat is ${jobOffer.id} ${jobOffer.chatId}');
      loadingSendJobOffer.value = true;
      var parameters = jobOffer.toJson();
      parameters['post_id'] = serviceId;
      parameters['pay_via'] = cardId;
      
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.sendJobOffer,
          parameter: parameters,
        ),
      );

      final data = json.decode(response);
      final jobOfferModel =
          JobOfferModel.fromJsonLender(data['dataset']['offer']);
          
      Get.find<RequestController>()
          .createServiceRequest(serviceId, jobOfferModel);
      
      checkSentOffer(context, serviceId);
    } on AppException catch (e, st) {
      debugPrint('new error ${e.message}');
      Get.showSnackbar(GetSnackBar(
        // title: "Your account is created successfully",
        message: e.message,
        duration: const Duration(seconds: 2),
      ));
    } catch (e, st) {
      debugPrint('sendJobOffer error $e $st');
    } finally {
      loadingSendJobOffer.value = false;
    }
  }

  Future<void> checkSentOffer(BuildContext context, String serviceId) async {
    try {
      sentOffer.value = null;
      loadingCheckOffer.value = true;
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.checkOffer,
          parameter: {'post_id': serviceId},
        ),
      );
      final data = json.decode(response);
      sentOffer.value = JobOfferModel.fromJson(data['dataset']['offer']);
      debugPrint('check offer response ${sentOffer.value?.description}');
    } catch (e, st) {
      debugPrint('sendJobOffer error $e $st');
    } finally {
      loadingCheckOffer.value = false;
    }
  }

  Future<void> getJobOffersByService(
      BuildContext context, String serviceId) async {
    try {
      loadingJobOffers.value = true;
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.getOffers,
          parameter: {'post_id': serviceId},
        ),
      );
      log('offers are $response');
      final data = json.decode(response);
      final dataList = data['dataset']['offers'] as List;
      jobOffers.value =
          dataList.map((e) => JobOfferModel.fromJsonLender(e)).toList();
      // debugPrint('job offer values ${jobOffers.first.renter.name}');
      debugPrint('LEngth: ${jobOffers.length}');
    } catch (e, st) {
      debugPrint('getJobOffers error $e $st');
    } finally {
      loadingJobOffers.value = false;
    }
  }

  Future<void> getAllJobOffers(BuildContext context) async {
    try {
      loadingJobOffers.value = true;
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.getAllOffers,
          parameter: {},
        ),
      );
      log('offers are $response');
      final data = json.decode(response);
      final dataList = data['dataset']['offers'] as List;
      jobOffers.value =
          dataList.map((e) => JobOfferModel.fromJsonLender(e)).toList();
      // debugPrint('job offer values ${jobOffers.first.renter.name}');
    } catch (e, st) {
      debugPrint('getJobOffers error $e $st');
    } finally {
      loadingJobOffers.value = false;
    }
  }

  Future<void> acceptJobOffer(
    BuildContext context,
    JobOfferModel jobOffer,
    String serviceId,
  ) async {
    try {
      // final chatRoomId =
      //     "${jobOffer.renter.id}${Get.find<AuthController>().getUserInfo.id}${serviceId}ES";

      // Get.find<RequestController>()
      //     .createServiceRequest(serviceId, jobOffer);  
      final response = await ApiMiddleware.callService(
          context: context,
          requestInfo: APIRequestInfoObj(
            requestType: HTTPRequestType.POST,
            url: EventEndPoints.offerAction,
            parameter: {
              'post_id': jobOffer.serviceId,
              'offer_id': jobOffer.id,
              'type': EventEndPoints.accept
            },
          ),
        );

      final data = json.decode(response);
      debugPrint("Hob offer data ${data}");
      final jobOfferModel =
          JobOfferModel.fromJsonLender(data['dataset']['offer']);
      if (jobOffers.length > 0)
      {
        updateOfferLocally(jobOfferModel);
      }
    } on AppException catch (e, st) {
      debugPrint('new error ${e.message}');
      Get.showSnackbar(
        GetSnackBar(
          // title: "Your account is created successfully",
          message: e.message,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e, st) {
      debugPrint('sendJobOffer error $e $st');
    } finally {}
  }

  Future<void> rejectJobOffer(
    BuildContext context,
    JobOfferModel jobOffer,
    String serviceId,
  ) async {
    try {
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.offerAction,
          parameter: {
            'post_id': serviceId,
            'offer_id': jobOffer.id,
            'type': EventEndPoints.reject
          },
        ),
      );
      final data = json.decode(response);
      final jobOfferModel =
          JobOfferModel.fromJsonLender(data['dataset']['offer']);
      if (jobOffers.length > 0)
      {
        updateOfferLocally(jobOfferModel);
      }
    } on AppException catch (e, st) {
      debugPrint('new error ${e.message}');
      Get.showSnackbar(GetSnackBar(
        // title: "Your account is created successfully",
        message: e.message,
        duration: const Duration(seconds: 2),
      ));
    } catch (e, st) {
      debugPrint('sendJobOffer error $e $st');
    } finally {}
  }

  Future<void> hireLender(
    BuildContext context,
    JobOfferModel jobOffer,
    String serviceId,
      String? chatId,
      ItemDetailModel service,

  ) async {
    try {
      showLoadingDialog(context);
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.offerAction,
          parameter: {
            'post_id': serviceId,
            'offer_id': jobOffer.id,
            'type': EventEndPoints.hire,
          },
        ),
      );
      log('hired successfully $response');
      if(chatId != null) {
        Get.find<ChatController>().updateChatStatus(itemDetailModel: service, docId: chatId);
      }
    } on AppException catch (e, st) {
      debugPrint('new error ${e.message}');
      Get.showSnackbar(GetSnackBar(
        // title: "Your account is created successfully",
        message: e.message,
        duration: const Duration(seconds: 2),
      ));
    } catch (e, st) {
      debugPrint('sendJobOffer error $e $st');
    } finally {
      Get.back();
    }
  }

  Future<void> loggHours(
    BuildContext context,
    JobOfferModel jobOffer,
    DateTime startDate,
    DateTime startTime,
    DateTime endTime,
    String serviceId,
  ) async {
    try {
      showLoadingDialog(context);
      debugPrint('logged hours job id ${jobOffer.id} post id: ${serviceId}');
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.loggHours,
          parameter: {
            'post_id': serviceId,
            'offer_id': jobOffer.id,
            'start_date_time': startTime.toString(),
            'end_date_time': endTime.toString(),
            'start_date': startDate.toString(),
            'chat_id': jobOffer.chatId,
          },
        ),
      );
      log('hired successfully $response');

      Get.back();
      Get.back();
      Get.showSnackbar(GetSnackBar(
        // title: "Your account is created successfully",
        message: "Hours has been logged",
        duration: const Duration(seconds: 2),
      ));
      updateFirebaseServiceRequest(jobOffer, startDate, endTime, startTime);
    } on AppException catch (e, st) {
      debugPrint('log hour error $e $st');
      Get.back();
      Get.back();
      debugPrint('new error ${e.message}');
      Get.showSnackbar(GetSnackBar(
        // title: "Your account is created successfully",
        message: e.message,
        duration: const Duration(seconds: 2),
      ));
    } catch (e, st) {
      debugPrint('sendJobOffer error $e $st');
      Get.back();
      Get.back();
    } finally {}
  }

 Future<void> updateFirebaseServiceRequest(JobOfferModel jobOffer, DateTime loggedDate, DateTime loggedStart, DateTime loggedEnd) async{
    FirebaseFirestore.instance.collection(StaticString.serviceRequestCollection).doc(jobOffer.id.toString()).update(
        {'logged_date': loggedDate, 'logged_end': loggedEnd, 'logged_start': loggedStart});
  }

  Future<void> disputeHours(
    BuildContext context,
    JobOfferModel jobOffer,
    DateTime startDate,
    DateTime startTime,
    DateTime endTime,
    String serviceId,
    String? info,
  ) async {
    try {
      showLoadingDialog(context);
      final String response = await ApiMiddleware.callService(
        context: context,
        requestInfo: APIRequestInfoObj(
          requestType: HTTPRequestType.POST,
          url: EventEndPoints.dispute,
          parameter: {
            'post_id': serviceId,
            'offer_id': jobOffer.id,
            'start_date_time': startTime.toString(),
            'end_date_time': endTime.toString(),
            'start_date': startDate.toString(),
          },
        ),
      );
      log('hired successfully $response');

      Get.back();
      Get.back();
      Get.showSnackbar(GetSnackBar(
        // title: "Your account is created successfully",
        message: "Hours has been logged",
        duration: const Duration(seconds: 2),
      ));
    } on AppException catch (e, st) {
      Get.back();
      Get.back();
      debugPrint('new error ${e.message}');
      Get.showSnackbar(GetSnackBar(
        // title: "Your account is created successfully",
        message: e.message,
        duration: const Duration(seconds: 2),
      ));
    } catch (e, st) {
      debugPrint('sendJobOffer error $e $st');
      Get.back();
      Get.back();
    } finally {}
  }

  
  JobOfferModel getSingleOffer(BuildContext context, String serviceId, String offerId)
  {
    JobOfferModel offer;
    debugPrint(jobOffers.length.toString());
    debugPrint("Here is my offer ID: ${offerId}");
    for (JobOfferModel offert in jobOffers) {
      debugPrint("Here is my ID");
      debugPrint(offert.id.toString());
    }
    final index = jobOffers.indexWhere((p0) => p0.id.toString() == offerId);
    debugPrint('This is my Index ${index.toString()}');
    offer = jobOffers[index];

    return offer;
  }

}
