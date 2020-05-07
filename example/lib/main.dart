//MIT License (MIT) Copyright (c) 2020 Alex Collette
//https://github.com/randomdude583/baseconvert
////////////////////////////////////////////////////////////////////////////////
import 'package:collection/collection.dart';

import 'package:baseconvert/baseconvert.dart';


void main(){

  // FORMAT:
  // base(
  //  List number,
  //  {int inputBase=10,
  //  int outputBase=10,
  //  int maxDepth=10,
  //  bool string=false,
  //  bool recurring=true})


  //------------------  base() Examples  ------------------

  //Convert FF0.8 (Base 16) to Base 10
  print(base([15, 15, 0, ".", 8], inBase: 16, outBase: 10));
  // --> [4, 0, 8, 0, ., 5]

  //Convert FF0.8 (Base 16) to Base 10
  print(base("FF0.8", inBase: 16, outBase: 10, string: true));
  // --> 4080.5

  //Convert 4080.5 (Base 10) to Base 16
  print(base("4080.5", inBase: 10, outBase: 16, string: true));
  // --> FF0.8



  //---------------  BaseConverter Examples  --------------

  //Create BaseConverter object.
  BaseConverter b = BaseConverter(inBase: 16, outBase: 8);

  //Convert FF (Base 16) to Base 8
  print(b.convert("FF"));
  // --> [3, 7, 7]

  //Convert FF (Base 15) to Base 15
  print(b.convert([15, 15]));
  // --> [3, 7, 7]

  //Convert FF (Base 16) to Base 8
  //Convert FF (Base 15) to Base 15
  //Compare the two
  print(ListEquality().equals(b.convert("FF"), b.convert([15,15])));
  // --> true


  //------------  representAsList() Example  ------------

  //Convert FF0 from String representation to List representation
  print(representAsList("FF0"));
  // --> [15, 15, 0]


  //-----------  representAsString() Example  -----------

  //Convert FF0 from List representation to String representation
  print(representAsString([15,15,0]));
  // --> FF0

}

