List<String> findMatchingPatterns(String pattern, List<String> numberList) {
  List<String> result = [];

  for (String number in numberList) {
    if (number.length != pattern.length) {
      continue; // Skip this number if lengths don't match
    }

    bool isMatching = true;
    for (int i = 0; i < pattern.length; i++) {
      if (pattern[i] != 'x' && pattern[i] != number[i]) {
        isMatching = false;
        break; // Skip this number if characters don't match
      }
    }

    if (isMatching) {
      result.add(number);
    }
  }

  return result;
}
