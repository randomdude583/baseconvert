library baseconvert;

import 'dart:math';

List _stringToList(String string) {
  //Convert string to List
  List list = [];
  for (int i = 0; i < string.length; i++) {
    list.add(int.tryParse(string[i]) ?? string[i]);
  }
  return list;
}

String _listToString(List list) {
  // Convert binary string to a list
  String output = "";
  list.forEach((i) {
    output += i.toString();
  });
  return output;
}

int digit(int decimal, int digit, [int inputBase = 10]) {
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
    return (decimal ~/ pow(inputBase, digit)) % inputBase;
  } else {
    return decimal % inputBase;
  }
}

int digits(int number, [int base = 10]) {
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

List<List> integerFractionalParts(List number) {
  /*
  Returns a List of the integer and fractional parts of a number.
  Args:
      number(iterable container): A number in the following form:
      [..., ".", int, int, int, ...]
  Returns:
      (integer_part, fractional_part): List.*/

  int radix_point = number.indexOf(".");
  List integer_part = number.sublist(0, radix_point);
  List fractional_part = number.sublist(radix_point);
  return ([integer_part, fractional_part]);
}

List fromBase10(int decimal, [outputBase = 10]) {
  /*
  Converts a decimal integer to a specific base.
  Args:
      decimal(int) A base 10 number.
      outputBase(int) base to convert to.
  Returns:
      A list of digits in the specified base.*/

  if (decimal <= 0) {
    return [0];
  }
  if (outputBase == 1) {
    return List.generate(outputBase, (number) => 1);
  }
  int length = digits(decimal, outputBase);
  List converted = List.generate(length, (i) => digit(decimal, i, outputBase));
  return converted.reversed.toList();
}

int toBase10(List n, int inputBase) {
  /*
  Converts an integer in any base into it's decimal representation.
  Args:
      n - An integer represented as a List of digits in the specified base.
      input_base - the base of the input number.
  Returns:
      integer converted into base 10.*/

  int sum = 0;
  for (int i = 0; i < n.length; i++) {
    sum += n.reversed.elementAt(i) * pow(inputBase, i);
  }
  return sum;
}

List integerBase(List number, [int inputBase = 10, int outputBase = 10]) {
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

  return fromBase10(toBase10(number, inputBase), outputBase);
}

List fractionalBase(List fractionalPart,
    [int inputBase = 10, int outputBase = 10, int maxDepth = 100]) {
  /*
  Convert the fractional part of a number from any base to any base.
  Args:
      fractional_part(iterable container): The fractional part of a number in
          the following form:    ( ".", int, int, int, ...)
      input_base(int): The base to convert from (defualt 10).
      output_base(int): The base to convert to (default 10).
      max_depth(int): The maximum number of decimal digits to output.
  Returns:
      The converted number as a tuple of digits.*/

  fractionalPart = fractionalPart.sublist(1);
  int fractionalDigits = fractionalPart.length;
  BigInt numerator = BigInt.from(0);
  for (int i = 0; i < fractionalPart.length; i++) {
    numerator = BigInt.from(numerator.toInt() +
        (fractionalPart[i] * pow(inputBase, fractionalDigits - (i + 1))));
  }
  BigInt denominator = BigInt.from(pow(inputBase, fractionalDigits));
  List digits = [];
  for (int i = 1; i < maxDepth + 1; i++) {
    numerator *= BigInt.from(pow(outputBase, i));
    int digit = (numerator ~/ denominator).toInt();
    numerator -= BigInt.from(digit) * denominator;
    denominator *= BigInt.from(pow(outputBase, i));
    digits.add(digit);

    BigInt greatestCommonDivisor = numerator.gcd(denominator);
    numerator ~/= greatestCommonDivisor;
    denominator ~/= greatestCommonDivisor;
  }
  digits.insert(0, ".");
  return digits;
}

List truncate(List n) {
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

int strDigitToInt(String chr) {
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
  }

  //A-Z
  if (n < 91) {
    n -= 55;
  } else {
    //a-z or higher
    n -= 61;
  }
  return n;
}

String intToStrDigit(int n) {
  /*
  Converts a positive integer, to a single string character.
  Where: 9 -> "9", 10 -> "A", 11 -> "B", 12 -> "C", ...etc
  Args:
      n(int): A positve integer number.
  Returns:
      The character representation of the input digit of value n (str).*/

  //0-9
  if (n < 10) {
    return n.toString();
  }
  //A-Z
  else if (n < 36) {
    return String.fromCharCode(n);
  }
  //a-z or higher
  else {
    return String.fromCharCode(n + 61);
  }
}

findRecurring(List number, {int minRepeat = 5}) {
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
  //Seperate the number into integer and fractional parts.
  List integerPart = integerFractionalParts(number)[0];
  List fractionalPart = integerFractionalParts(number)[1];
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
    if (number[number.length - 1] == digit) {
      number = number.sublist(0, number.length - 2);
      patternTemp = patternTemp.sublist(1) + (patternTemp[0]);
    }
    pattern = patternTemp;
    //Return the number with the recurring pattern enclosed with '[' and ']'
    return number + ["["] + pattern.reversed.toList() + ["]"];
  }
}

expandRecurring(List number, {int repeat = 5}) {
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

bool checkValid(List number, [int inputBase = 10]) {
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
    } else if (n >= inputBase) {
      if (n == 1 && inputBase == 1) {
        continue;
      } else {
        return false;
      }
    }
  }
  return true;
}

base(dynamic number,
    {int inputBase = 10,
    int outputBase = 10,
    int maxDepth = 10,
    bool string = false,
    bool recurring = true}) {
  /*
  Converts a number from any base to any another.
  Args:
      number(List|String|int): The number to convert.
      inputBase(int): The base to convert from (defualt 10).
      outputBase(int): The base to convert to (default 10).
      maxDepth(int): The maximum number of fractional digits (defult 10).
      string(bool): If true output will be in String representation,
          if false output will be in List representation (defult false).
      recurring(bool): Attempt to find repeating digits in the fractional
          part of a number. Repeated digits will be enclosed with "[" and "]"
          (default true).
  Returns:
      A List of digits in the specified base:
      (int, int, int, ... , '.' , int, int, int)
      If the string flag is set to true,
      a String representation will be used instead.
  Raises:
      ValueError if a digit value is too high for the inputBase.*/

  //Convert number to List representation
  if (number is int || number is double) {
    number = number.toString();
  }
  if (number is String) {
    number = _stringToList(number);
  }
  //Check that the number is valid for the input base
  if (!checkValid(number, inputBase)) {
    throw Exception("Invalid!");
  }
  //Deal with base-1 special case
  if (inputBase == 1) {
    number = List.generate(number.length, (number) => 1);
  }
  //Expand any recurring digits
  number = expandRecurring(number, repeat: 5);
  //Convert a fractional number
  if (number.contains(".")) {
    int radixPoint = number.indexOf(".");
    List integerPart = number.sublist(0, radixPoint);
    List fractionalPart = number.sublist(radixPoint);
    integerPart = integerBase(integerPart, inputBase, outputBase);
    fractionalPart =
        fractionalBase(fractionalPart, inputBase, outputBase, maxDepth);

    number = integerPart + fractionalPart;
    number = truncate(number);
  }

  //Convert an integer number
  else {
    number = integerBase(number, inputBase, outputBase);
  }

  if (recurring) {
    number = findRecurring(number, minRepeat: 2);
  }

  //Return the converted number as a string or list
  if (string) {
    return _listToString(number);
  } else {
    return number;
  }
}

class BaseConverter {
  final int inputBase;
  final int outputBase;
  final int maxDepth;
  final bool string;
  final bool recurring;

  BaseConverter({
    this.inputBase = 10,
    this.outputBase = 10,
    this.maxDepth = 10,
    this.string = false,
    this.recurring = true});

  convert(dynamic number){
    return base(number, inputBase: inputBase, outputBase: outputBase,
        maxDepth: maxDepth, string: string, recurring: recurring);
  }

}
