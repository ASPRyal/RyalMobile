abstract class NameFormatter {
  NameFormatter._();
  static String capitalizeName(String name) {
    final List<String> words = name.split(' ');

    final String result = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      final String lowerCaseWord = word.substring(1).toLowerCase();
      return word[0].toUpperCase() + lowerCaseWord;
    }).join(' ');
    return result;
  }

  static String capitalizeFirstWord(String input) {
    if (input.isEmpty) return input;

    final List<String> words = input.split(' ');
    if (words.isNotEmpty) {
      final String firstWord = words[0];
      if (firstWord.isNotEmpty) {
        final String capitalized =
            firstWord[0].toUpperCase() + firstWord.substring(1).toLowerCase();
        words[0] = capitalized;
      }
    }

    return words.isNotEmpty ? words[0] : '';
  }

  static String extractInitials(String name) {
    final List<String> words = name.split(' ');

    if (words.isEmpty) {
      return ''; // Return an empty string if there are no names
    }

    // Extract the first letter of the first name
    final String firstNameInitial =
        words[0].isNotEmpty ? words[0][0].toUpperCase() : '';

    // Extract the first letter of the last name if available
    final String lastNameInitial = words.length > 1 && words.last.isNotEmpty
        ? words.last[0].toUpperCase()
        : '';

    return '$firstNameInitial$lastNameInitial';
  }


}
