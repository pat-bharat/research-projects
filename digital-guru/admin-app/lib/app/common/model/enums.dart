class Language {
  static const String english = "English";
  static const String hindi = "Hindi";

  static var values = [english, hindi];
}

class BillingItemType {
  static const String monthly = "Monthly";
  static const String setup = "Setup";
  static var values = [monthly, setup];
}

class LegalFor {
  static const String business = "business";
  static const String consumer = "consumer";
  static var values = [business, consumer];
}

class LegalType {
  static const String toc = "toc";
  static const String privacy_policy = "privacy_policy";
  static var values = [toc, privacy_policy];
}

class UserRole {
  static const String admin = "Admin";
  static const String user = "User";
  static const String system = "System";
  static var values = [user, admin, system];
}
