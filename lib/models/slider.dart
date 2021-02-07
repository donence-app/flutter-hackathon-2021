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
      sliderHeading: 'Your books are special',
      sliderSubHeading:
          'Donence, stores your wishes. Then match with donations and keeps reading greener.'),
  Slider(
      sliderImageUrl: 'assets/images/slider_2.png',
      sliderHeading: 'Scan the book',
      sliderSubHeading:
          'Donence, will find your book from millions of publication. List the books you have read, donate and save nature. Improve literacy rate!'),
  Slider(
      sliderImageUrl: 'assets/images/slider_3.png',
      sliderHeading: 'Match with those nearby',
      sliderSubHeading:
          'All things work anonymous, find donations, get wishes. Information increases as it is shared. You can change the world!'),
  Slider(
      sliderImageUrl: 'assets/images/slider_4.png',
      sliderHeading: 'Create your Library',
      sliderSubHeading:
          'It\'s fun as crazy when you follow your library with smart classification. Track your readings, get motivated.'),
];
