import 'dart:math';

import 'package:test/test.dart';
import 'package:baseconvert/baseconvert.dart';

void main() {
  
  group('digit()', (){
    test('201_0', (){
      expect(digit(201, 0), 1);
    });
    test('201_1', (){
      expect(digit(201, 1), 0);
    });
    test('201_2', (){
      expect(digit(201, 2), 2);
    });
    test('generate', (){
      expect(List.generate(8, (num) {return digit(253, num, 2);}), [1, 0, 1, 1, 1, 1, 1, 1]);
    });
    test('hex', (){
      expect(digit(123456789123456789, 0, 16), 5);
    });
  });

  group('digits()', (){
    test('255', (){
      expect(digits(255), 3);
    });
    test('255_16', (){
      expect(digits(255, 16), 2);
    });
    test('256_16', (){
      expect(digits(256, 16), 3);
    });
    test('256_2', (){
      expect(digits(256, 2), 9);
    });
    test('0_678363', (){
      expect(digits(0, 678363), 0);
    });
    test('-1_678363', (){
      expect(digits(-1, 678363), 0);
    });
    test('12345_10', (){
      expect(digits(12345, 10), 5);
    });
  });


  group('integerFractionalParts()',(){
    test('[1,2,3,".",4,5,6]', (){
      expect(integerFractionalParts([1,2,3,".",4,5,6]), [[1, 2, 3], ['.', 4, 5, 6]]);
    });
  });
  
  group('fromBase10()', (){
    test('255', (){
      expect(fromBase10(255), [2, 5, 5]);
    });
    test('255_16', (){
      expect(fromBase10(255, 16), [15, 15]);
    });
    test('9988664439_8', (){
      expect(fromBase10(9988664439, 8), [1, 1, 2, 3, 2, 7, 5, 6, 6, 1, 6, 7]);
    });
    test('0_17', (){
      expect(fromBase10(0, 17), [0]);
    });
  });


  group('toBase10()', (){
    test('[8,1]_16', (){
      expect(toBase10([8,1], 16), 129);
    });
  });

  group('integerBase()',(){
    test('[2, 5, 5]', (){
      expect(integerBase([2, 5, 5]), [2, 5, 5]);
    });
    test('[2, 5, 4]_10_16', (){
      expect(integerBase([2, 5, 4], 10, 16), [15, 14]);
    });
    test('[2, 5, 5]_10_16', (){
      expect(integerBase([2, 5, 5], 10, 16), [15, 15]);
    });
    test('[3, 1, 0]_10_16', (){
      expect(integerBase([3, 1, 0], 10, 16), [1, 3, 6]);
    });
    test('[11, 4, 1, 8, 10]_13_20', (){
      expect(integerBase([11, 4, 1, 8, 10], 13, 20), [2, 0, 8, 2, 2]);
    });
    test('[10, 10, 1, 13]_15_20', (){
      expect(integerBase([10, 10, 1, 13], 15, 20), [4, 10, 1, 8]);
    });
  });


  group('fractionalBase()', (){
    test('[".", 6,]_10_16_10', (){
      expect(fractionalBase([".", 6], 10, 16, 10),
          ['.', 9, 9, 9, 9, 9, 9, 9, 9, 9, 9]);
    });
  });


  group('truncate()', (){
    test("[9, 9, 9, '.', 9, 9, 9, 9, 0, 0, 0, 0]", (){
      expect(truncate([9, 9, 9, '.', 9, 9, 9, 9, 0, 0, 0, 0]),
          [9, 9, 9, '.', 9, 9, 9, 9]);
    });
    test("['.',]", (){
      expect(truncate(['.',]), ['.']);
    });
  });


  group("findRecurring()", (){
    test("[3, 2, 1, '.', 1, 2, 3, 1, 2, 3], minRepeat: 1", (){
      expect(findRecurring([3, 2, 1, '.', 1, 2, 3, 1, 2, 3], minRepeat: 1),
          [3, 2, 1, '.', '[', 1, 2, 3, ']']);
    });
  });
  
  
  group("expandRecurring()", (){
    test('[1, ".", 0, "[", 9, "]"], repeat=3', (){
      expect(expandRecurring([1, ".", 0, "[", 9, "]"], repeat: 3),
          [1, '.', 0, 9, 9, 9, 9]);
    });
  });



  
  
  group('checkValid()', (){
    test("[1,9,6,'.',5,1,6]_12", (){
      expect(checkValid([1,9,6,'.',5,1,6], 12), true);
    });
    test("[8,1,15,9]_15", (){
      expect(checkValid([8,1,15,9], 15), false);
    });
  });


  group('base()', (){
    test("[1,9,6,'.',5,1,6], 17, 20", (){
      expect(base([1,9,6,'.',5,1,6], inputBase: 17, outputBase: 20),
          [1, 2, 8, '.', 5, 19, 10, 7, 17, 2, 13, 13, 1, 8]);
    });
  });


  group('BaseConverter()', (){
    group("2_4", (){
      BaseConverter b = new BaseConverter(inputBase: 2, outputBase: 4);
      test("", (){
        expect(b.convert([0,1,0,1,0,1,0,0]), [1,1,1,0]);
      });
    });
  });











/*
  group('base', () {
    test('base_numberWrongType_exception', () {
      expect(() => baseconvert(0, 2, 3, string: true), throwsException);
    });

    test('base_base2IN/base3-10OUT', () {
      expect(baseconvert("01010100", 2, 3, string: true), "10010");
      expect(baseconvert("01010100", 2, 4, string: true), "1110");
      expect(baseconvert("01010100", 2, 5, string: true), "314");
      expect(baseconvert("01010100", 2, 6, string: true), "220");
      expect(baseconvert("01010100", 2, 7, string: true), "150");
      expect(baseconvert("01010100", 2, 8, string: true), "124");
      expect(baseconvert("01010100", 2, 9, string: true), "103");
      expect(baseconvert("01010100", 2, 10, string: true), "84");
    });

    test('base_base3IN/base2-10OUT', () {
      expect(baseconvert("0012001", 3, 2, string: true), "10001000");
      expect(baseconvert("0012001", 3, 4, string: true), "2020");
      expect(baseconvert("0012001", 3, 5, string: true), "1021");
      expect(baseconvert("0012001", 3, 6, string: true), "344");
      expect(baseconvert("0012001", 3, 7, string: true), "253");
      expect(baseconvert("0012001", 3, 8, string: true), "210");
      expect(baseconvert("0012001", 3, 9, string: true), "161");
      expect(baseconvert("0012001", 3, 10, string: true), "136");
    });

    test('base_base10IN/base10OUT', () {
      expect(baseconvert("1945", 10, 10, string: true), "1945");
    });

    test('base_base2IN/base10OUT', () {
      expect(baseconvert("11110011001", 2, 10, string: true), "1945");
    });

    test('base_StringIN/StringOUT', () {
      expect(baseconvert("01010100", 2, 3, string: true), "10010");
    });
    test('base_List<int>IN/StringOUT', () {
      expect(baseconvert([0, 1, 0, 1, 0, 1, 0, 0], 2, 3, string: true), "10010");
    });
    test('base_StringIN/List<int>OUT', () {
      expect(baseconvert("01010100", 2, 3, string: false), [1, 0, 0, 1, 0]);
    });
    test('base_list<int>IN/List<int>OUT', () {
      expect(baseconvert(['F', 'F', 0], 16, 10, string: false), [4, 0, 8, 0]);
    });
  });


  group('baseconvert', (){
    test('baseconvert_create_noExceptions', (){
      BaseConverter b = BaseConverter(2,10);
    });

    test('baseconvert_base2IN/base4OUT', (){
      BaseConverter b = BaseConverter(2,4, string: true);
      expect(b.convert("01010100"), "1110");
    });
  });*/







}
