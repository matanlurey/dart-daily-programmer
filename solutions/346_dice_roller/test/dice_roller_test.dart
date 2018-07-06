import 'dart:math';

import 'package:dice_roller/dice_roller.dart';
import 'package:test/test.dart';

void main() {
  // Create a pre-defined seeded random to make testing possible.
  final roller = DiceRoller.seed(Random(1001));

  test('5d12', () {
    expect(
        roller.roll('5d12'),
        boundsOf(
          minResult: 1,
          maxResult: 12,
          minSum: 1 * 5,
          maxSum: 12 * 5,
        ));
  });

  test('6d4', () {
    expect(
        roller.roll('6d4'),
        boundsOf(
          minResult: 1,
          maxResult: 4,
          minSum: 1 * 6,
          maxSum: 4 * 6,
        ));
  });

  test('1d2', () {
    expect(
        roller.roll('1d2'),
        boundsOf(
          minResult: 1,
          maxResult: 2,
          minSum: 1,
          maxSum: 2,
        ));
  });

  test('1d8', () {
    expect(
        roller.roll('1d8'),
        boundsOf(
          minResult: 1,
          maxResult: 8,
          minSum: 1,
          maxSum: 8,
        ));
  });

  test('3d6', () {
    expect(
        roller.roll('3d6'),
        boundsOf(
          minResult: 1,
          maxResult: 6,
          minSum: 1 * 3,
          maxSum: 6 * 3,
        ));
  });

  test('4d20', () {
    expect(
        roller.roll('4d20'),
        boundsOf(
          minResult: 1,
          maxResult: 20,
          minSum: 1 * 4,
          maxSum: 20 * 4,
        ));
  });

  test('100d10', () {
    expect(
        roller.roll('100d10'),
        boundsOf(
          minResult: 1,
          maxResult: 100,
          minSum: 1 * 100,
          maxSum: 10 * 100,
        ));
  });
}

Matcher boundsOf({int minResult, int maxResult, int minSum, int maxSum}) {
  return _DiceMatcher(minResult, maxResult, minSum, maxSum);
}

class _DiceMatcher extends Matcher {
  final int minResult;
  final int maxResult;
  final int minSum;
  final int maxSum;

  _DiceMatcher(this.minResult, this.maxResult, this.minSum, this.maxSum);

  @override
  Description describe(Description description) {
    return description
        .add('Result of $minResult -> $maxResult')
        .add('Sum of $minSum = > $maxSum');
  }

  @override
  bool matches(covariant Iterable<int> results, _) {
    var sum = 0;
    for (final result in results) {
      if (result < minResult || result > maxResult) {
        return false;
      }
      sum += result;
    }
    return sum >= minSum && sum <= maxSum;
  }
}
