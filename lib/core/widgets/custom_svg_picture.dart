import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/theme_controller.dart';

class CustomSvgPicture extends StatelessWidget {
  final String imgPath;
  bool withFilterColor;
  double? width;
  double? height;

  CustomSvgPicture({
    super.key,
    required this.imgPath,
    this.withFilterColor = true,
    this.width,
    this.height,
  });

  CustomSvgPicture.withOutFilterColor({
    super.key,
    required this.imgPath,
    this.width,
    this.height,
  }) : withFilterColor = false;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/images/$imgPath.svg",
      width: width,
      height: height,
      colorFilter: withFilterColor
          ? ColorFilter.mode(
              ThemeController.isDark() ? Color(0xFFC6C6C6) : Color(0xFF3A4640),
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
