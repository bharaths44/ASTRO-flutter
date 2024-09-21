import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';

class SvgViewerWidget extends StatelessWidget {
  final String svgFilePath;

  const SvgViewerWidget({super.key, required this.svgFilePath});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SvgPicture.file(
      File(svgFilePath),
      placeholderBuilder: (BuildContext context) =>
          const CircularProgressIndicator(),
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
    ));
  }
}
