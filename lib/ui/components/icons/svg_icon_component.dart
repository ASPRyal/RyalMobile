import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIconComponent extends StatelessWidget {
  const SvgIconComponent({
    required this.iconPath,
    required this.size,
    BoxFit? boxFit,
    this.color,
    this.height,
    this.width,
    super.key,
  }) : _boxFit = boxFit ?? BoxFit.scaleDown;

  final String iconPath;
  final double size;
  final BoxFit _boxFit;
  final Color? color;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SizedBox(
            height: height ?? size,
            width: width ?? size,
            child: ImageFiltered(
              imageFilter: 
                   ImageFilter.blur(),
              child: color != null
                  ? SvgPicture.asset(
                      iconPath,
                      fit: _boxFit,
                      colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
                    )
                  : SvgPicture.asset(
                      iconPath,
                      fit: _boxFit,
                    ),
            ),
          ),
        ],
      );
}
