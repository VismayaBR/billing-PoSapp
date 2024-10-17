

import 'package:flutter/material.dart';



const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
const Widget horizontalSpaceSX = SizedBox(width: 15.0);
const Widget horizontalSpaceMedium = SizedBox(width: 18.0);
const Widget horizontalSpaceLarge = SizedBox(width: 18.0);
const Widget horizontalSpaceExtraLarge = SizedBox(width: 50.0);
const emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))';
const numberPattern=r'(^(?:[+0]9)?[0-9]{10}$)';
const uaeNumberPattern=r'(^(?:[+0]9)?[0-9]{9}$)';
const discountPattern= r'^[\d.]+$';

const Widget verticalSpaceTiny = SizedBox(height: 5.0);
const Widget verticalSpaceSmall = SizedBox(height: 10.0);
const Widget verticalSpaceSX = SizedBox(height: 15.0);
const Widget verticalSpaceMedium = SizedBox(height: 25.0);
const Widget verticalSpaceLarge = SizedBox(height: 50.0);
const Widget verticalSpaceMassive = SizedBox(height: 120.0);


///
double getHeight({@required context}) => MediaQuery.of(context).size.height;

double getWidth({@required context}) => MediaQuery.of(context).size.width;





///
/// Style for input text field
///
///





