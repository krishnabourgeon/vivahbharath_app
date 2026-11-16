// import 'package:flutter/widgets.dart';

// /// Values collected across the 7 sign-up steps. One instance is passed
// /// from screen to screen and submitted at the end.
// class SignUpData {
//   // Step 1 – Basic information
//   String gender = 'Male';
//   DateTime? dob;
//   String email = '';
//   String password = '';

//   // Step 2 – Community & location
//   String? religion, caste, subCaste, gotra;
//   bool openToOtherCastes = false;
//   String? nativeCountry, nativeState, nativeDistrict;
//   String? permCountry, permState, permDistrict;
//   String pincode = '';
//   String homeAddress = '';
//   bool currentSameAsPermanent = true;
//   String currentAddress = '';

//   // Step 3 – Professional details
//   String? education;
//   String educationDetail = '';
//   final Set<String> languages = {};
//   String? employmentType, occupation, workCountry, workState, workCity;
//   String? residentialStatus;
//   String currency = '₹ INR';
//   String? income;

//   // Step 4 – Personal & physical
//   String maritalStatus = 'Never married';
//   int children = 0;
//   String? height, weight, bodyType, complexion, bloodGroup, disability;
//   bool surgery = false;
//   String? diet, smoking, drinking;
//   bool pets = false;

//   // Step 5 – Photos & about you
//   final List<ImageProvider?> photos = List.filled(8, null);
//   String aboutMe = '';

//   // Step 6 – Family details
//   String? familyStatus, familyType, familyValues, familyMembers;
//   int brothers = 0, brothersMarried = 0, sisters = 0, sistersMarried = 0;
//   String? fatherOccupation, motherOccupation, propertyValue;
//   String secondContact = '';

//   // Step 7 – Hobbies & interests
//   final Set<String> hobbies = {};
//   String otherHobbies = '';
// }

import 'package:flutter/material.dart';

/// Values collected across the 8 sign-up steps. One instance is passed
/// from screen to screen and submitted at the end.
class SignUpData {
  // Step 1 – Basic information
  String gender = 'Female';
  DateTime? dob;
  String email = '';
  String password = '';

  // Step 2 – Community & location
  String? religion, caste, subCaste, gotra;
  bool openToOtherCastes = false;
  String? nativeCountry, nativeState, nativeDistrict;
  String? permCountry, permState, permDistrict;
  String pincode = '';
  String homeAddress = '';
  bool currentSameAsPermanent = true;
  String? curCountry, curState, curDistrict;
  String currentPincode = '';
  String currentAddress = '';

  // Step 3 – Professional details
  String? education;
  String educationDetail = '';
  final Set<String> languages = {};
  String? employmentType, occupation, workCountry, workState, workCity;
  String? residentialStatus;
  String currency = 'Select';
  String? income;

  // Step 4 – Personal & physical
  String maritalStatus = '';
  int children = 0;
  String? height, weight, bodyType, complexion, bloodGroup, disability;
  bool surgery = false;
  String? diet, smoking, drinking;
  bool pets = false;

  // Step 5 – Photos & about you
  // One slot per image type from the image-types API (grown when loaded).
  final List<ImageProvider?> photos = [];
  String aboutMe = '';
  // Photo slots / about text already sent to the server, so going Back and
  // Continue again doesn't upload them twice.
  final Set<int> uploadedPhotos = {};
  String uploadedAbout = '';

  // Step 6 – Family details
  String? familyStatus, familyType, familyValues, familyMembers;
  int brothers = 0, brothersMarried = 0, sisters = 0, sistersMarried = 0;
  String? fatherOccupation, motherOccupation, propertyValue;
  String secondContact = '';
  bool secondContactWhatsapp = false;

  // Step 7 – Hobbies & interests
  final Set<String> hobbies = {};
  String otherHobbies = '';

  // Step 8 – Horoscope details
  DateTime? horoscopeDob;
  String? birthStar;
  TimeOfDay? birthTime;
  String? birthLocation;
  String? sudhaJathakam, doshaJathakam;
  String doshaType = '';
  String? starMatchOnly;
  String? horoscopeMatch;
  bool showHoroscope = true;
}
