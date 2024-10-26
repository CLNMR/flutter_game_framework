/// Calculates and returns the unique start substrings of the given list of
/// strings, e.g. ["Hello", "Hestia", "Alan"] => ["Hel", "Hes", "A"]
List<String> getUniqueStartSubstrings(Iterable<String> inputStrings) {
  final result = <String>[];

  // Iterate over substrings of each name until it's unique among the list
  for (final name in inputStrings) {
    for (var i = 0; i < name.length; i++) {
      final substring = name.substring(0, i + 1);
      final otherSubstrings = inputStrings
          .where((n) => n != name && n.length > i)
          .map((n) => n.substring(0, i + 1).toLowerCase())
          .toList();
      if (!otherSubstrings.contains(substring.toLowerCase())) {
        result.add(substring);
        break;
      }
    }
  }
  return result;
}

// void main() {
  // final test = [
  //   'Alan',
  //   'Alastair',
  //   'alex',
  //   'Henry',
  //   'Holger',
  //   'Johannes',
  //   'Klaus',
  // ];

  // final test = ['Player 1', 'Player 2'];
  // print(getUniqueStartSubstrings(test)); // [Alan, Alas, ale, He, Ho, J, K]
// }
