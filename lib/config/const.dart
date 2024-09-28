import 'package:flutter/material.dart';

const urlLogo = 'assets/images/Logo.png';

const light = Color(0xFFFFFFFF);
const branchColor = Color(0xFFE89967);
const branchColor2 = Color(0xFFFF914D);

const textButton = TextStyle(
  color: Colors.white,
  fontSize: 30,
  fontFamily: 'Inter',
);

const title = TextStyle(
  color: branchColor2,
  fontSize: 50,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
);

const title2 = TextStyle(
  color: branchColor2,
  fontSize: 30,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
);

const label = TextStyle(
  color: Colors.black,
  fontSize: 25,
  fontFamily: 'Inter',
  fontWeight: FontWeight.normal,
);

const text = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontFamily: 'Inter',
  fontWeight: FontWeight.normal,
);

dynamic myOutlineInputBorder1() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
    borderSide: BorderSide(color: branchColor, width: 1),
  );
}

dynamic myOutlineInputBorder2() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
    borderSide: BorderSide(color: branchColor, width: 2),
  );
}

dynamic myOutlineInputBorder3() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
    borderSide: BorderSide(color: branchColor, width: 2),
  );
}
