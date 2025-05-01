import 'package:flutter/material.dart';

class ColorExtension extends ThemeExtension<ColorExtension> {
  const ColorExtension({required this.primaryColor, required this.songArtColor});

  final Color primaryColor;
  final Color songArtColor;

  @override
  ColorExtension copyWith({Color? brandColor, Color? danger}) {
    return ColorExtension(primaryColor: brandColor ?? this.primaryColor, songArtColor: danger ?? this.songArtColor);
  }

  @override
  ColorExtension lerp(ColorExtension? other, double t) {
    if (other is! ColorExtension) {
      return this;
    }
    return ColorExtension(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t) ?? primaryColor,
      songArtColor: Color.lerp(songArtColor, other.songArtColor, t) ?? primaryColor,
    );
  }

}