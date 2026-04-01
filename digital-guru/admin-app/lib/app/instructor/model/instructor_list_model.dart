import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/firebase_services/service/cloud_storage_service.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:digiguru/app/instructor/service/instructor_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:flutter/cupertino.dart';

class InstructorListModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final InstructorService _instructorService = locator<InstructorService>();
  final DialogService _dialogService = locator<DialogService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  static List<Instructor> _Instructors = [];

  //Business _business;
  //Business get business => _business;
  static List<Instructor> get instructors => _Instructors;

  InstructorListModel();
  void listenToInstructors() async {
    setBusy(true);
    _instructorService
        .listenToInstructoresRealTime(currentBusiness.documentId!)
        .listen((instructor) {
      List<Instructor> instructors = instructor;
      if (instructors.isNotEmpty) {
        _Instructors = instructors;
        notifyListeners();
      }
      setBusy(false);
    });
  }

  Future deleteInstructor(Instructor instructor) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete the Instructor?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed!) {
      setBusy(true);
      try {
        await _instructorService.deleteInstructor(instructor);
        // Delete the image after the post is deleted
        await _cloudStorageService.deleteFile(instructor.profilePic!);
      } catch (e) {
        await _dialogService.showDialog(
            title: "Failed Todelete Instructor", description: e.toString());
      }

      setBusy(false);
    }
  }

  void editInstructor(Instructor instructor) {
    // CourseModule cm CourseModule(course: _course, module: _modules[index])
    _navigationService.navigateTo(AddEditInstructorViewRoute,
        arguments: instructor);
  }

  void requestMoreData() =>
      _instructorService.requestMoreData(currentBusiness.documentId!);

  Future navigateToAddInstructorToBusiness() async {
    _navigationService.navigateTo(AddEditInstructorViewRoute);
  }

  goBack() {
    _navigationService.pop();
  }
}

class BusinessInstructorArgs {
  final Business business;
  final Instructor? instructor;
  BusinessInstructorArgs({required this.business, this.instructor});
}
