//MIT License (MIT) Copyright (c) 2020 Alex Collette
//https://github.com/randomdude583/baseconvert
////////////////////////////////////////////////////////////////////////////////
library baseconvert;

import 'dart:math';

List representAsList(String string) {
  /*
  Represent a number-string in the form of a tuple of digits.
  "868.0F" -> (8, 6, 8, '.', 0, 15)
  Args:
      string - Number represented as a string of digits.
  Returns:
      Number represented as an iterable container of digits*/

  List keep = [".", "[", "]"];
  List output = [];
  for (int i = 0; i < string.length; i++) {
    if (!keep.contains(string[i])) {
      output.add(_strDigitToInt(string[i]));
    } else {
      output.add(string[i]);
    }
  }
  return output;
}

String representAsString(List list) {
  /*
  Represent a number in the form of a string.
  (8, 6, 8, '.', 0, 15) -> "868.0F"
  Args:
      iterable - Number represented as an iterable container of digits.
  Returns:
      Number represented as a string of digits.*/

  List keep = [".", "[", "]"];
  String output = "";
  for (dynamic i in list) {
    if (!keep.contains(i)) {
      output += _intToStrDigit(i);
    } else {
      output += i;
    }
  }
  return output;
}

int _digit(int decimal, int digit, [int inBase = 10]) {
  /*
  Find the value of an integer at a specific digit when represented in a
  particular base.
  Args:
      decimal(int): A number represented in base 10 (positive integer).
      digit(int): The digit to find where zero is the first, lowest, digit.
      base(int): The base to use (default 10).
  Returns:
      The value at specified digit in the input decimal.
      This output value is represented as a base 10 integer.*/

  if (decimal == 0) {
    return 0;
  }
  if (digit != 0) {
    return (decimal ~/ pow(inBase, digit)) % inBase;
  } else {
    return decimal % inBase;
  }
}

int _digits(int number, [int base = 10]) {
  /*
  Determines the number of digits of a number in a specific base.
  Args:
      number(int): An integer number represented in base 10.
      base(int): The base to find the number of digits.
  Returns:
      Number of digits when represented in a particular base (integer).*/
  if (number < 1) {
    return 0;
  }
  int digits = 0;
  while (number >= 1) {
    number ~/= base;
    digits += 1;
  }
  return digits;
}

List<List> _integerFractionalParts(List number) {
  /*
  Returns a List of the integer and fractional parts of a number.
  Args:
      number(iterable container): A number in the following form:
      [..., ".", int, int, int, ...]
  Returns:
      (integer_part, fractional_part): List.*/

  int radixPoint = number.indexOf(".");
  List integerPart = number.sublist(0, radixPoint);
  List fractionalPart = number.sublist(radixPoint);
  return ([integerPart, fractionalPart]);
}

List _fromBase10(int decimal, [outBase = 10]) {
  /*
  Converts a decimal integer to a specific base.
  Args:
      decimal(int) A base 10 number.
      outBase(int) base to convert to.
  Returns:
      A list of digits in the specified base.*/

  if (decimal <= 0) {
    return [0];
  }
  if (outBase == 1) {
    return List.generate(decimal, (i) => 1);
  }
  int length = _digits(decimal, outBase);
  List converted = List.generate(length, (i) => _digit(decimal, i, outBase));
  return converted.reversed.toList();
}

int _toBase10(List n, int inBase) {
  /*
  Converts an integer in any base into it's decimal representation.
  Args:
      n - An integer represented as a List of digits in the specified base.
      input_base - the base of the input number.
  Returns:
      integer converted into base 10.*/

  int sum = 0;
  for (int i = 0; i < n.length; i++) {
    sum += n.reversed.elementAt(i) * pow(inBase, i);
  }
  return sum;
}

List _integerBase(List number, [int inBase = 10, int outBase = 10]) {
  /*
  Converts the integer part of a number from one base to another.
  Args:
      number  - An number in the following form:
          (int, int, int, ...)
          (iterable container) containing positive integers of input base.
      input_base    - The base to convert from.
      output_base   - The base to convert to.
  Returns:
      A List of digits.*/

  return _fromBase10(_toBase10(number, inBase), outBase);
}

List _fractionalBase(List fractionalPart,
    [int inBase = 10, int outBase = 10, int maxDepth = 100]) {
  /*
  Convert the fractional part of a number from any base to any base.
  Args:
      fractional_part(iterable container): The fractional part of a number in
          the following form:    ( ".", int, int, int, ...)
      input_base(int): The base to convert from (default 10).
      output_base(int): The base to convert to (default 10).
      max_depth(int): The maximum number of decimal digits to output.
  Returns:
      The converted number as a tuple of digits.*/

  fractionalPart = fractionalPart.sublist(1);
  int fractionalDigits = fractionalPart.length;
  BigInt numerator = BigInt.from(0);
  for (int i = 0; i < fractionalPart.length; i++) {
    numerator = BigInt.from(numerator.toInt() +
        (fractionalPart[i] * pow(inBase, fractionalDigits - (i + 1))));
  }
  BigInt denominator = BigInt.from(pow(inBase, fractionalDigits));
  List digits = [];
  for (int i = 1; i < maxDepth + 1; i++) {
    numerator *= BigInt.from(pow(outBase, i));
    int digit = (numerator ~/ denominator).toInt();
    numerator -= BigInt.from(digit) * denominator;
    denominator *= BigInt.from(pow(outBase, i));
    digits.add(digit);

    BigInt greatestCommonDivisor = numerator.gcd(denominator);
    numerator ~/= greatestCommonDivisor;
    denominator ~/= greatestCommonDivisor;
  }
  digits.insert(0, ".");
  return digits;
}

List _truncate(List n) {
  /*
  Removes trailing zeros.
  Args:
      n:  The number to truncate.
          This number should be in the following form:
          (..., '.', int, int, int, ..., 0)
  Returns:
      n with all trailing zeros removed*/

  int count = 0;
  for (int i = 0; i < n.length; i++) {
    if (n.reversed.elementAt(i) != 0) {
      break;
    }
    count += 1;
  }
  if (count > 0) {
    return n.sublist(0, n.length - count);
  } else {
    return n;
  }
}

int _strDigitToInt(String chr) {
  /*
  Converts a String character to a decimal number.
  Where "A"->10, "B"->11, "C"->12, ...etc
  Args:
      chr(String): A single character in the form of a String.
  Returns:
      The integer value of the input String digit.*/

  int n;

  //0-9
  if (["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(chr)) {
    n = int.parse(chr);
  } else {
    n = chr.codeUnits[0];
    //A-Z
    if (n < 91) {
      n -= 55;
    } else {
      //a-z or higher
      n -= 61;
    }
  }
  return n;
}

String _intToStrDigit(int n) {
  /*
  Converts a positive integer, to a single string character.
  Where: 9 -> "9", 10 -> "A", 11 -> "B", 12 -> "C", ...etc
  Args:
      n(int): A positive integer number.
  Returns:
      The character representation of the input digit of value n (str).*/

  //0-9
  if (n < 10) {
    return n.toString();
  }
  //A-Z
  else if (n < 36) {
    return String.fromCharCode(n + 55);
  }
  //a-z or higher
  else {
    return String.fromCharCode(n + 61);
  }
}

List _findRecurring(List number, {int minRepeat = 5}) {
  /*
  Attempts to find repeating digits in the fractional component of a number.
  Args:
      number(List): the number to process in the form:
          (int, int, int, ... ".", ... , int int int)
      min_repeat(int): the minimum number of times a pattern must occur to be
          defined as recurring. A min_repeat of n would mean a pattern must
          occur at least n + 1 times, so as to be repeated n times.
  Returns:
      The original number with repeating digits (if found) enclosed by  "["
      and "]" (List).*/

  // Return number if it has no fractional part, or minRepeat value is invalid.
  if (!number.contains(".") || minRepeat < 1) {
    return number;
  }
  //Separate the number into integer and fractional parts.
  List integerPart = _integerFractionalParts(number)[0];
  List fractionalPart = _integerFractionalParts(number)[1];
  //Reverse fractional part to get a sequence.
  List sequence = fractionalPart.reversed.toList();
  //Initialize counters
  //The 'period' is the number of digits in a pattern.
  int period = 0;
  //The best pattern found will be stored.
  int best = 0;
  int bestPeriod = 0;
  int bestRepeat = 0;
  //Find recurring pattern.
  while (period < sequence.length) {
    period += 1;
    List pattern = sequence.sublist(0, period - 1);
    int repeat = 0;
    int digit = period;
    bool patternMatch = true;
    while (patternMatch && digit < sequence.length) {
      for (int i = 0; i < pattern.length; i++) {
        if (sequence[digit + i] != pattern[i]) {
          patternMatch = false;
          break;
        }
        if (i == pattern.length - 1) {
          repeat += 1;
        }
      }
      digit += period;
    }
    //Give each pattern found a rank and use the best.
    int rank = period * repeat;
    if (rank > best) {
      bestPeriod = period;
      bestRepeat = repeat;
      best = rank;
    }
  }
  //If the pattern does not repeat often enough, return the original number.
  if (bestRepeat < minRepeat) {
    return number;
  }
  //Use the best pattern found.
  List pattern = sequence.sublist(0, bestPeriod);
  //Remove the pattern from our original number.
  number = integerPart +
      fractionalPart.sublist(0, fractionalPart.length - (best + bestPeriod));
  //Ensure we are at the start of the pattern.
  List patternTemp = pattern;
  for (int i = 0; i < pattern.length; i++) {
    if (number[number.length - 1] == _digit) {
      number = number.sublist(0, number.length - 2);
      patternTemp = patternTemp.sublist(1) + (patternTemp[0]);
    }
  }
  pattern = patternTemp;
  //Return the number with the recurring pattern enclosed with '[' and ']'
  return number + ["["] + pattern.reversed.toList() + ["]"];
}

List _expandRecurring(List number, {int repeat = 5}) {
  /*
  Expands a recurring pattern within a number.
  Args:
      number(List): the number to process in the form:
          (int, int, int, ... ".", ... , int int int)
      repeat: the number of times to expand the pattern.
  Returns:
      The original number with recurring pattern expanded.
  */

  if (number.contains("[")) {
    int patternIndex = number.indexOf("[");
    List pattern = number.sublist(patternIndex + 1, number.length - 1);
    number = number.sublist(0, patternIndex);
    for (int i = 0; i < repeat + 1; i++) {
      number = number + pattern;
    }
  }
  return number;
}

bool _checkValid(List number, [int inBase = 10]) {
  /*
  Checks if there is an invalid digit in the input number.
  Args:
      number: An number in the following form:
          (int, int, int, ... , '.' , int, int, int)
          (iterable container) containing positive integers of the input base
      input_base(int): The base of the input number.
  Returns:
      bool, true if all digits valid, else false.*/

  for (dynamic n in number) {
    if ([".", "[", "]"].contains(n)) {
      continue;
    } else if (n >= inBase) {
      if (n == 1 && inBase == 1) {
        continue;
      } else {
        return false;
      }
    }
  }
  return true;
}

base(dynamic number,
    {int inBase = 10,
    int outBase = 10,
    int maxDepth = 10,
    bool string = false,
    bool recurring = true}) {
  /*
  Converts a number from any base to any another.
  Args:
      number(List|String|int): The number to convert.
      inBase(int): The base to convert from (default 10).
      outBase(int): The base to convert to (default 10).
      maxDepth(int): The maximum number of fractional digits (default 10).
      string(bool): If true output will be in String representation,
          if false output will be in List representation (default false).
      recurring(bool): Attempt to find repeating digits in the fractional
          part of a number. Repeated digits will be enclosed with "[" and "]"
          (default true).
  Returns:
      A List of digits in the specified base:
      (int, int, int, ... , '.' , int, int, int)
      If the string flag is set to true,
      a String representation will be used instead.
  Raises:
      ValueError if a digit value is too high for the inBase.*/

  //Check for invalid bases
  if (inBase < 1) {
    throw Exception("Invalid inBase");
  }
  if (outBase < 1) {
    throw Exception();
  }

  //Convert number to List representation
  if (number is int || number is double) {
    number = number.toString();
  }
  if (number is String) {
    number = representAsList(number);
  }
  //Check that the number is valid for the input base
  if (!_checkValid(number, inBase)) {
    throw Exception("Invalid!");
  }
  //Deal with base 1 special case
  if (inBase == 1) {
    int count = 0;
    for (dynamic item in number) {
      if (item == 1) {
        count++;
      }
    }
    number = List.generate(count, (number) => 1);
  }
  //Expand any recurring digits
  number = _expandRecurring(number, repeat: 5);
  //Convert a fractional number
  if (number.contains(".")) {
    int radixPoint = number.indexOf(".");
    List integerPart = number.sublist(0, radixPoint);
    List fractionalPart = number.sublist(radixPoint);
    integerPart = _integerBase(integerPart, inBase, outBase);
    fractionalPart = _fractionalBase(fractionalPart, inBase, outBase, maxDepth);

    number = integerPart + fractionalPart;
    number = _truncate(number);
  }

  //Convert an integer number
  else {
    number = _integerBase(number, inBase, outBase);
  }

  if (recurring) {
    number = _findRecurring(number, minRepeat: 2);
  }

  //Return the converted number as a string or list
  if (string) {
    return representAsString(number);
  } else {
    return number;
  }
}

class BaseConverter {
  final int inBase;
  final int outBase;
  final int maxDepth;
  final bool string;
  final bool recurring;

  BaseConverter(
      {this.inBase = 10,
      this.outBase = 10,
      this.maxDepth = 10,
      this.string = false,
      this.recurring = true}) {
    //Check for invalid bases
    if (inBase < 1) {
      throw Exception("Invalid inBase");
    }
    if (outBase < 1) {
      throw Exception();
    }
  }

  convert(dynamic number) {
    return base(number,
        inBase: inBase,
        outBase: outBase,
        maxDepth: maxDepth,
        string: string,
        recurring: recurring);
  }
}
