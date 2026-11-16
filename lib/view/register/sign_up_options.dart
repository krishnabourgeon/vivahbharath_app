/// Dropdown and chip options for the sign-up steps.
/// Replace with your real lists or API data.
abstract final class SignUpOptions {
  // static const religions = ['Hindu', 'Muslim', 'Christian', 'Sikh', 'Jain', 'Buddhist', 'Parsi', 'Jewish', 'Other'];
  // static const castes = ['Nair', 'Ezhava', 'Namboothiri', 'Menon', 'Thiyya', 'Vishwakarma', 'Nadar', 'Other'];
  // static const subCastes = ['Nambiar', 'Kiriyathil', 'Illathu', 'Swaroopathil', 'Other'];
  // static const gotras = ["Don't know", 'Kashyap', 'Bharadwaj', 'Vashishta', 'Vishwamitra', 'Gautam', 'Atri', 'Other'];
  // static const countries = ['India', 'UAE', 'Saudi Arabia', 'Qatar', 'Oman', 'Kuwait', 'USA', 'UK', 'Canada', 'Australia', 'Other'];
  // static const states = ['Kerala', 'Tamil Nadu', 'Karnataka', 'Andhra Pradesh', 'Telangana', 'Maharashtra', 'Delhi', 'Other'];
  // static const districts = ['Thiruvananthapuram', 'Kollam', 'Pathanamthitta', 'Alappuzha', 'Kottayam', 'Idukki', 'Ernakulam', 'Thrissur', 'Palakkad', 'Malappuram', 'Kozhikode', 'Wayanad', 'Kannur', 'Kasaragod'];
  // static const cities = ['Kozhikode', 'Kochi', 'Thiruvananthapuram', 'Thrissur', 'Kannur', 'Bengaluru', 'Chennai', 'Other'];
  // static const educations = ['High school', 'Diploma', "Bachelor's degree", "Master's degree", 'Doctorate', 'Other'];
  // static const languages = ['Malayalam', 'English', 'Hindi', 'Tamil', 'Kannada', 'Telugu', 'Arabic', 'Other'];
  // static const employmentTypes = ['Healthcare', 'Information Technology', 'Farmer', 'Defence', 'Government / PSU', 'Private sector', 'Business', 'Others'];
  // static const occupations = ['Software engineer', 'Doctor', 'Nurse', 'Teacher', 'Engineer', 'Accountant', 'Lawyer', 'Business owner', 'Government employee', 'Other'];
  // static const residentialStatuses = ['Permanent', 'Citizen', 'Work permit', 'Student visa', 'Temporary visa'];
  // static const currencies = ['₹ INR', '\$ USD', '£ GBP', '€ EUR', 'AED'];
  // static const incomeRanges = ['Below 1 Lakh', '1 – 3 Lakh', '3 – 5 Lakh', '5 – 10 Lakh', '10 – 15 Lakh', '15 – 25 Lakh', '25 – 50 Lakh', 'Above 50 Lakh'];
  // static const maritalStatuses = ['Never married', 'Divorced', 'Widow / Widower', 'Awaiting divorce', 'Annulled'];
  // static const bodyTypes = ['Slim', 'Average', 'Athletic', 'Heavy'];
  // static const complexions = ['Very fair', 'Fair', 'Wheatish', 'Dark'];
  // static const bloodGroups = ['A +ve', 'A -ve', 'B +ve', 'B -ve', 'AB +ve', 'AB -ve', 'O +ve', 'O -ve'];
   static const disabilities = ['No','Yes'];
  // static const diets = ['Vegetarian', 'Non-vegetarian', 'Eggetarian', 'Vegan'];
  // static const habits = ['No', 'Occasionally', 'Yes'];
  // static const familyStatuses = ['Lower middle class', 'Middle class', 'Upper middle class', 'Rich', 'Affluent'];
  // static const familyTypes = ['Nuclear', 'Joint', 'Extended'];
  // static const familyValues = ['Traditional', 'Moderate', 'Liberal'];
  // static const parentOccupations = ['Business', 'Homemaker', 'Government employee', 'Private employee', 'Farmer', 'Retired', 'Not alive', 'Other'];
  // static const propertyValues = ['Below 25 Lakh', '25 – 50 Lakh', '50 Lakh – 1 Crore', '1 – 5 Crore', 'Above 5 Crore'];
  // static const photoLabels = ['Profile', 'Close-up', 'Full length', 'Traditional', 'Candid', 'Professional', 'Casual', 'Formal'];
  // static const hobbies = ['Writing', 'Reading', 'Badminton', 'Cricket', 'Football', 'Tennis', 'Chess', 'Kabaddi', 'Carroms', 'Billiards', 'Swimming', 'Travelling', 'Trekking', 'Cinema', 'Watching TV', 'Gaming', 'Music', 'Cooking'];

  /// 120 cm to 210 cm: "168 cm"
  static final heights = List.generate(91, (i) => '${120 + i} cm');

  /// 20 kg to 150 kg
  static final weights = List.generate(131, (i) => '${20 + i} kg');
  static final familyMemberCounts = List.generate(15, (i) => '${i + 1}');
}