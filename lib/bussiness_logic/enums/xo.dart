enum XO {
  x,
  o,
  non
}

XO getXOFromString(String value) {
  switch (value) {
    case 'X':
      return XO.x;
    case 'O':
      return XO.o;
    case 'non':
      return XO.non;
    default:
      throw Exception("Invalid value: $value");
  }
}
