// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class HomePageModel {

  final unfocusNode = FocusNode();
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
 CarouselController? carouselController;

  int carouselCurrentIndex = 1;

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }
}
