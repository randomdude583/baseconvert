library baseconvert;



base(dynamic number, int inBase, int outBase,
    {bool string = false}){

  //Ensure input is String
  if(number is List){
    number = number.join("");
  } else if(!(number is String)){
    throw Exception("Number must be List or String");
  }


  //If in and out are base10, return.
  if(inBase == 10 && outBase ==10){
    if(string){
      return number;
    } else {
      return _stringToList(number);
    }
  }


  //Convert inBase number to base10
  int b10Number = int.parse(number, radix: inBase);
  if(outBase == 10){
    String output = b10Number.toString();
    if(string){
      return output;
    } else {
      return _stringToList(output);
    }
  } else {
    //Convert base10 number to outBase
    String output = b10Number.toRadixString(outBase);
    if(string){
      return output;
    } else {
      return _stringToList(output);
    }
  }
}




// Convert binary string to a list
List _stringToList(String str){
  List output = [];
  for(int i=0; i < str.length; i++){
    try{
      output.add(int.parse(str[i]));
    } catch (Exception){
      output.add(str[i]);
    }
  }
  return output;
}






class BaseConvert {

  final int inBase;
  final int outBase;
  final bool string;

  BaseConvert(this.inBase, this.outBase, {this.string = false});

  convert(dynamic number){
    return base(number, inBase, outBase, string: string);
  }

}



