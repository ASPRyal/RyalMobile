class AppValidationRule {
  AppValidationRule._();

  static final emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static final pwdRegistrationRegex = RegExp(
    r"""^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[ "'=\(\)\\#?!@$%^&*-/{}_|~`;:<>,]).{8,}$""",
  );

  static final allowedCharacters = RegExp(r'^[^<>]*$');
  static final allowedEmail = RegExp(
    r'^[a-zA-Z0-9\._-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.(?:[a-zA-Z]{2,})$',
    unicode: true,
  );
  static final allowedCharactersForPassword = RegExp(r'^[^<>]*$');

  static final numbers = RegExp('[0-9].{7,10}');
  static final lowerCase = RegExp('[a-z]');
  static final upperCase = RegExp('[A-Z]');
  static final letters = RegExp('[a-zA-Z]');

  /// ✅ QID: exactly 11 digits
  static final qidRegex = RegExp(r'^[0-9]{11}$');

  /// ✅ Phone: exactly 8 digits
  static final phoneRegex = RegExp(r'^[0-9]{8}$');

  static bool pwdCharsCountValidator(String pwd) {
    return pwd.toLowerCase().length >= 8;
  }

  static bool wordValidator(String string) {
    return letters.hasMatch(string);
  }
static bool mcitValidator(String mcitNumber) {
    if (mcitNumber.isEmpty) return false;
    
    // Remove any whitespace
    final cleanedMcit = mcitNumber.trim();
    
    // Check if it contains only digits
    final digitRegex = RegExp(r'^\d+$');
    if (!digitRegex.hasMatch(cleanedMcit)) return false;
    
    // Check length (adjust based on actual MCIT format - typically 10-15 digits)
    // Update this range based on your requirements
    if (cleanedMcit.length < 8 || cleanedMcit.length > 15) return false;
    
    return true;
  }
  static bool numberValidator(String string) {
    return numbers.hasMatch(string);
  }

  static bool emailValidator(String email) {
    return emailRegex.hasMatch(email);
  }

  static bool pwdValidator(String pwd) {
    return pwdRegistrationRegex.hasMatch(pwd);
  }

  static bool qidValidator(String qid) {
    return qidRegex.hasMatch(qid);
  }

  static bool phoneValidator(String phone) {
    return phoneRegex.hasMatch(phone);
  }
}
