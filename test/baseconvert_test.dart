import 'package:test/test.dart';
import 'package:baseconvert/baseconvert.dart';

void main() {
  group('base', () {
    test('base_numberWrongType_exception', () {
      expect(() => base(0, 2, 3, string: true), throwsException);
    });

    test('base_base2IN/base3-10OUT', () {
      expect(base("01010100", 2, 3, string: true), "10010");
      expect(base("01010100", 2, 4, string: true), "1110");
      expect(base("01010100", 2, 5, string: true), "314");
      expect(base("01010100", 2, 6, string: true), "220");
      expect(base("01010100", 2, 7, string: true), "150");
      expect(base("01010100", 2, 8, string: true), "124");
      expect(base("01010100", 2, 9, string: true), "103");
      expect(base("01010100", 2, 10, string: true), "84");
    });

    test('base_base3IN/base2-10OUT', () {
      expect(base("0012001", 3, 2, string: true), "10001000");
      expect(base("0012001", 3, 4, string: true), "2020");
      expect(base("0012001", 3, 5, string: true), "1021");
      expect(base("0012001", 3, 6, string: true), "344");
      expect(base("0012001", 3, 7, string: true), "253");
      expect(base("0012001", 3, 8, string: true), "210");
      expect(base("0012001", 3, 9, string: true), "161");
      expect(base("0012001", 3, 10, string: true), "136");
    });

    test('base_base10IN/base10OUT', () {
      expect(base("1945", 10, 10, string: true), "1945");
    });

    test('base_base2IN/base10OUT', () {
      expect(base("11110011001", 2, 10, string: true), "1945");
    });

    test('base_StringIN/StringOUT', () {
      expect(base("01010100", 2, 3, string: true), "10010");
    });
    test('base_List<int>IN/StringOUT', () {
      expect(base([0, 1, 0, 1, 0, 1, 0, 0], 2, 3, string: true), "10010");
    });
    test('base_StringIN/List<int>OUT', () {
      expect(base("01010100", 2, 3, string: false), [1, 0, 0, 1, 0]);
    });
    test('base_list<int>IN/List<int>OUT', () {
      expect(base(['F', 'F', 0], 16, 10, string: false), [4, 0, 8, 0]);
    });
  });


  group('baseconvert', (){
    test('baseconvert_create_noExceptions', (){
      BaseConvert b = BaseConvert(2,10);
    });

    test('baseconvert_base2IN/base4OUT', (){
      BaseConvert b = BaseConvert(2,4, string: true);
      expect(b.convert("01010100"), "1110");
    });




  });







}
