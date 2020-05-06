# baseconvert
Convert any rational number, from any (positive integer) base, to any (positive integer) base. Output numbers as tuple or string.
- Any rational number
- Arbitrary precision
- Fractions
- Recurring/repeating fractional digits.
- Input numbers as tuple or string or number.
- Output numbers as tuple or string.

MIT License (MIT) Copyright (c) 2020 Alex Collette

[Github](https://github.com/randomdude583/baseconvert "GitHub Repo")

- - - - 
This repository is a port of [Joshua Deakin's](https://github.com/squdle "github/squdle") baseconvert library for Python.
- His original repository can be found [Here](https://github.com/squdle/baseconvert "squdle/baseconvert")
- - - -

## Usage
```// base(number, {inputBase=10, outputBase=10, maxDepth=10, string=false, recurring=true})

base([15, 15, 0, ".", 8], inBase: 16, outBase: 10);
--> [4, 0, 8, 0, '.', 5]

base("FF0.8", inBase: 16, outBase: 10, string: true);
--> '4080.5'

base("4080.5", inBase: 10, outBase: 16, string: true);
--> 'FF0.8'
```

## List Representation
Numbers are represented as a sequence of digits. Each digit is a base-10 integer value. The radix point, which separates the integer and fractional parts, is denoted by a String period.

``` 
[int, int, int, ... , '.', ... , int, int, int]
[   integer part    , '.',  fractional part   ]
```

## String Representation
String digits (after z the values are in ascending Unicode):
```0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz

|  Value  | Representation |
|---------|----------------|
|  0 -  9 |    0  -  9     |
| 10 - 53 |    A  -  Z     |
| 36 - 61 |    a  -  z     |
| 62 +    | unicode 123 +  |

For bases higher than 61 it's recommended to use List representation.
```

## Recurring Digits
Recurring digits at the end of a fractional part will be enclosed by "[" and "]" in both string and List representation. This behavior can be turned off by setting the recurring argument of base or BaseConverter object to false.
```
base("0.1", inBase: 3, outBase: 10, string: true);
--> '0.[3]'
base("0.1", inBase: 3, outBase: 10, string: true, recurring: false);
--> '0.3333333333'
```

## Max Fractional Depth
Integer parts are always of arbitrary size. Fractional depth (number of digits) can must be specified by setting the maxDepth argument of base or a BaseConverter object (default 10).
```
base("0.2", inBase: 10, outBase: 8);
--> [0, '.', 1, 4, 6, 3, 1, 4, 6, 3, 1, 4]
base("0.2", inBase: 10, outBase: 8, maxDepth=1);
--> [0, '.', 1]
```

## Callable BaseConverter
An object can also be created. This is useful for when several numbers need to be converted.
```
BaseConverter b = BaseConverter(inputBase: 16, outputBase: 8);
b("FF");
--> [3, 7, 7]
b([15, 15]);
--> [3, 7, 7]
b("FF") == b([15,15]);
--> true
```
