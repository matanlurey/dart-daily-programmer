import 'dart:math';

/// Parses and rolls virtual dice for games or for fun!
///
/// ## Simple use:
/// ```dart
/// import 'package:dice_roller/dice_roller.dart';
///
/// void main() {
///   var roller = DiceRoller();
///   print(roller.roll('5d12'));
///   print(roller.sum('3d6'));
/// }
/// ```
///
/// ## Advanced use:
/// ```dart
/// import 'dart:math';
///
/// import 'package:dice_roller/dice_roller.dart';
///
/// void main() {
///   // Use an existing seed to give predictable results.
///   var roller = DiceRoller(Random(1001));
///   print(roller.roll('5d12'));
///   print(roller.sum('3d6'));
/// }
/// ```
class DiceRoller {
  final Random _random;

  /// Creates a new dice roller with a psuedo-random seed.
  ///
  /// For serious applications, games, or even tests, see [DiceRoller.seed].
  DiceRoller() : _random = Random();

  /// Creates a new dice roller with the provided [Random] seeded.
  DiceRoller.seed(this._random);

  /// Returns an iterable that rolls the `"NdN"` dice parsed from [expression].
  ///
  /// Throws a [FormatException] if any input is unsupported.
  Iterable<int> roll(String expression) {
    final parsed = _Expression.parse(expression);
    return Iterable.generate(parsed.amount, (_) {
      return _random.nextInt(parsed.sides) + 1;
    });
  }

  /// Returns the result and sum of all dice parsing in the form `"NdN"`.
  ///
  /// Throws a [FormatException] if any input is unsupported.
  int sum(String expression) => roll(expression).fold(0, (a, b) => a + b);
}

class _Expression {
  /// Number of dice to roll.
  final int amount;

  /// Number of sides on an individual die.
  final int sides;

  const _Expression(this.amount, this.sides);

  /// Parses and returns a dice expression in the form of `"NdN"`.
  ///
  /// Throws a [FormatException] on an unsupported input.
  factory _Expression.parse(String expression) {
    // We could write a much more defensive parser (with a recovering AST, etc)
    // but that (a) would be out of scope of this assignment and (b) would be
    // much harder to follow for the average developer.
    //
    // Instead, we'll assume all input is mostly well formed, and throw rather
    // eagerly if we get anything we don't expect. The expressions should be
    // short enough that they are human understandable if they fail.
    if (expression == null) {
      throw ArgumentError.notNull('expression');
    }
    try {
      // We now know the expression is a non-null String.
      final parts = expression.split('d');
      // We expect exactly two parts, i.e. "5d12" => ["5", "12"].
      // Any other number of parts (0, 1, 3+) is invalid.
      if (parts.length != 2) {
        // Throw in order to be caught by "on FormatException" below.
        throw const FormatException();
      }
      // Parse the two parts. If this ends up failing, it will throw.
      return _Expression(int.parse(parts.first), int.parse(parts.last));
    } on FormatException {
      // Recover and throw a human-readable error message.
      throw FormatException('Invalid "NdN" expression', expression);
    }
  }
}
