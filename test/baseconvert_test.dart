//MIT License (MIT) Copyright (c) 2020 Alex Collette
//https://github.com/randomdude583/baseconvert
////////////////////////////////////////////////////////////////////////////////
import 'package:test/test.dart';

import 'package:baseconvert/baseconvert.dart';

void main() {
  List B2 = [1, 0, 1, 0, 1, 0, 0];
  List B3 = [1, 0, 0, 1, 0];
  List B4 = [1, 1, 1, 0];
  List B5 = [3, 1, 4];
  List B6 = [2, 2, 0];

  group("representAsList", () {
    test("", () {
      expect(representAsList("868.0F"), [8, 6, 8, '.', 0, 15]);
    });
  });

  group("representAsString", () {
    test("[8, 6, 8, '.', 0, 15]", () {
      expect(representAsString([8, 6, 8, '.', 0, 15]), "868.0F");
    });
  });

  group('base()', () {
    test("B2_B3", () {
      expect(base(B2, inBase: 2, outBase: 3), B3);
    });
    test("B3_B4", () {
      expect(base(B3, inBase: 3, outBase: 4), B4);
    });
    test("B4_B5", () {
      expect(base(B4, inBase: 4, outBase: 5), B5);
    });
    test("B5_B6", () {
      expect(base(B5, inBase: 5, outBase: 6), B6);
    });
  });

  group('BaseConverter()', () {
    group("2_4", () {
      BaseConverter b = new BaseConverter(inBase: 2, outBase: 4);
      test("", () {
        expect(b.convert([0, 1, 0, 1, 0, 1, 0, 0]), [1, 1, 1, 0]);
      });
    });
  });
}
