import 'package:flutter/material.dart';

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider(
      {@required this.sliderImageUrl,
      @required this.sliderHeading,
      @required this.sliderSubHeading});
}

final sliderArrayList = [
  Slider(
      sliderImageUrl: 'assets/images/slider_1.png',
      sliderHeading: 'Your bin is special',
      sliderSubHeading:
          'Open the app and scan the bin. Then document the throw and gain points.'),
  Slider(
      sliderImageUrl: 'assets/images/slider_2.png',
      sliderHeading: 'Scan the product',
      sliderSubHeading:
          'Not sure where to put a pizza box ? Enter the name and let the app do the work for you.'),
  Slider(
      sliderImageUrl: 'assets/images/slider_3.png',
      sliderHeading: 'Set your goals',
      sliderSubHeading:
          'Set recycling goals and achieve the greatness in the bin world. Your group can impact the world !'),
  Slider(
      sliderImageUrl: 'assets/images/slider_2.png',
      sliderHeading: 'Follow your statistics',
      sliderSubHeading:
          'It\'s more fun when you can measure your impact on the environment. Track your habits and improvements.'),
];
