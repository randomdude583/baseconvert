//MIT License (MIT) Copyright (c) 2020 Alex Collette
//https://github.com/randomdude583/baseconvert
////////////////////////////////////////////////////////////////////////////////
import 'package:test/test.dart';

import 'package:baseconvert/baseconvert.dart';

void main() {
  List B1 = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
  List B2 = [1, 0, 1, 0, 1, 0, 0];
  List B3 = [1, 0, 0, 1, 0];
  List B4 = [1, 1, 1, 0];
  List B5 = [3, 1, 4];
  List B6 = [2, 2, 0];

  group("representAsList", () {
    test("868.0F", () {
      expect(representAsList("868.0F"), [8, 6, 8, '.', 0, 15]);
    });
  });

  group("representAsString", () {
    test("[8, 6, 8, '.', 0, 15]", () {
      expect(representAsString([8, 6, 8, '.', 0, 15]), "868.0F");
    });
  });


  group('base()', () {
    group("normal", (){
      test("B1_B2", (){
        expect(base(B1, inBase: 1, outBase: 2), B2);
      });
      test("B2_B1", (){
        expect(base(B2, inBase: 2, outBase: 1), B1);
      });
      test("B2_B2", (){
        expect(base(B2, inBase: 2, outBase: 2), B2);
      });
      test("B2_B3", (){
        expect(base(B2, inBase: 2, outBase: 3), B3);
      });
      test("noOptionalParams", (){
        expect(base(B5), B5);
      });
    });

    group("exception", (){
      test("invalidInBase", (){
        expect(() => base(B5, inBase: -1, outBase: 3), throwsException);
      });
      test("invalidOutBase", (){
        expect(() => base(B5, inBase: 5, outBase: 0),  throwsException);
      });
      test("valueMismatch", (){
        expect(() => base(B5, inBase: 2, outBase: 10), throwsException);
      });
    });



  });

  group('BaseConverter()', () {
    group("expect", () {
      BaseConverter b = new BaseConverter(inBase: 2, outBase: 4);
      test("2_4", () {
        expect(b.convert([0, 1, 0, 1, 0, 1, 0, 0]), [1, 1, 1, 0]);
      });
    });

    group("exception", (){
      test("invalidInBase", (){
        expect((){BaseConverter b = new BaseConverter(inBase: -1, outBase: 3);}, throwsException);
      });
      test("invalidOutBase", (){
        expect((){BaseConverter b = new BaseConverter(inBase: 2, outBase: -1);}, throwsException);
      });
      test("valueMismatch", (){
        BaseConverter b = new BaseConverter(inBase: 2, outBase: 4);
        expect(() => b.convert("FF0"), throwsException);
      });
    });
  });
}
