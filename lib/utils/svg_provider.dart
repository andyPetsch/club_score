// lib/utils/svg_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/billiards_ball.dart';

/// Provides SVG assets for the billiards app
class BilliardsSVG {
  // Ball definitions
  static const String ballCue = 'assets/svg/ball_0.svg';
  static const String ball1 = 'assets/svg/ball_1.svg';
  static const String ball2 = 'assets/svg/ball_2.svg';
  static const String ball3 = 'assets/svg/ball_3.svg';
  static const String ball4 = 'assets/svg/ball_4.svg';
  static const String ball5 = 'assets/svg/ball_5.svg';
  static const String ball6 = 'assets/svg/ball_6.svg';
  static const String ball7 = 'assets/svg/ball_7.svg';
  static const String ball8 = 'assets/svg/ball_8.svg';
  static const String ball9 = 'assets/svg/ball_9.svg';
  static const String ball10 = 'assets/svg/ball_10.svg';
  static const String ball11 = 'assets/svg/ball_11.svg';
  static const String ball12 = 'assets/svg/ball_12.svg';
  static const String ball13 = 'assets/svg/ball_13.svg';
  static const String ball14 = 'assets/svg/ball_14.svg';
  static const String ball15 = 'assets/svg/ball_15.svg';

  // Action icons
  static const String iconUndo = 'assets/svg/icon_undo.svg';
  static const String iconScoreSheet = 'assets/svg/icon_score_sheet.svg';
  static const String iconChevron = 'assets/svg/icon_chevron.svg';
  static const String iconTrophy = 'assets/svg/icon_trophy.svg';
  static const String iconRerack = 'assets/svg/icon_rerack.svg';
  static const String iconFoulX = 'assets/svg/icon_foul_x.svg';
  static const String iconWarning = 'assets/svg/icon_warning.svg';

  /// Get a ball SVG widget by number - replaced with template-based implementation
  static Widget getBall(int number, {double size = 40, bool inactive = false}) {
    // Use new BilliardsBall implementation
    return BilliardsBall(
      number: number,
      isActive: !inactive,
      size: size,
    ).build();
  }

  /// Legacy SVG file-based implementation - kept for backward compatibility
  static Widget getLegacyBall(int number,
      {double size = 40, bool inactive = false}) {
    String assetPath;

    switch (number) {
      case 0:
        assetPath = ballCue;
        break;
      case 1:
        assetPath = ball1;
        break;
      case 2:
        assetPath = ball2;
        break;
      case 3:
        assetPath = ball3;
        break;
      case 4:
        assetPath = ball4;
        break;
      case 5:
        assetPath = ball5;
        break;
      case 6:
        assetPath = ball6;
        break;
      case 7:
        assetPath = ball7;
        break;
      case 8:
        assetPath = ball8;
        break;
      case 9:
        assetPath = ball9;
        break;
      case 10:
        assetPath = ball10;
        break;
      case 11:
        assetPath = ball11;
        break;
      case 12:
        assetPath = ball12;
        break;
      case 13:
        assetPath = ball13;
        break;
      case 14:
        assetPath = ball14;
        break;
      case 15:
        assetPath = ball15;
        break;
      default:
        assetPath = ballCue;
    }

    // Instead of applying a filter to the entire SVG,
    // wrap it in an opacity widget to preserve transparency
    return Opacity(
      opacity: inactive ? 0.5 : 1.0,
      child: SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
      ),
    );
  }

  /// Get an icon SVG widget by name
  static Widget getIcon(String iconName, {double size = 24, Color? color}) {
    String assetPath;

    switch (iconName) {
      case 'undo':
        assetPath = iconUndo;
        break;
      case 'score_sheet':
        assetPath = iconScoreSheet;
        break;
      case 'chevron':
        assetPath = iconChevron;
        break;
      case 'trophy':
        assetPath = iconTrophy;
        break;
      case 'rerack':
        assetPath = iconRerack;
        break;
      case 'foul_x':
        assetPath = iconFoulX;
        break;
      case 'warning':
        assetPath = iconWarning;
        break;
      default:
        assetPath = iconUndo;
    }

    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}
