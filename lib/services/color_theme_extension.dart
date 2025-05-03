import 'package:flutter/material.dart';

class ColorExtension extends ThemeExtension<ColorExtension> {
  const ColorExtension({required this.primaryColor, required this.songArtColor, required this.oppositeToTheme});

  final Color primaryColor;
  final Color songArtColor;
  final Color oppositeToTheme;

  @override
  ColorExtension copyWith({Color? primaryColor, Color? songArtColor, Color? oppositeToTheme}) {
    return ColorExtension(primaryColor: primaryColor ?? this.primaryColor, songArtColor: songArtColor ?? this.songArtColor, oppositeToTheme: oppositeToTheme ?? this.oppositeToTheme);
  }

  @override
  ColorExtension lerp(ColorExtension? other, double t) {
    if (other is! ColorExtension) {
      return this;
    }
    return ColorExtension(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t) ?? primaryColor,
      songArtColor: Color.lerp(songArtColor, other.songArtColor, t) ?? primaryColor,
      oppositeToTheme: Color.lerp(oppositeToTheme, other.oppositeToTheme, t) ?? oppositeToTheme,
    );
  }

}