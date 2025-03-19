import 'package:flutter/material.dart';
import 'package:makeitcode/theme/theme.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color midnightBlue;
  final Color dark;
  final Color white;
  final Color softWhite;
  final Color skyBlue;
  final Color pureWhite;
  final Color pureBlack;
  final Color amber;
  final Color oceanBlue;
  final Color deepAqua;
  final Color vibrantBlue;
  final Color sandyBrown;
  final Color semiTransparentBlack;
  final Color deepSlateBlue;
  final Color darkPeriwinkle;
  final Color mistySlate;
  final Color slateGrey;
  final Color semiTransparentWhite;
  final Color softLavender;
  final Color lightLavender;
  final Color paleLavender;
  final Color lightSteelBlue;
  final Color darkPurple;
  final Color deepShadow;
  final Color seafoamGreen;
  final Color goldenrodYellow;
  final Color midnightBlueDark;
  final Color deepBlue;
  final Color steelBlue;
  final Color softGreen;
  final Color fieryRed;
  final Color mutedAmethyst;
  final Color twilightPurple;
  final Color lightIceBlue;
  final Color yellow;
  final Color grey;
  final Color midnightIndigo;
  final Color darkSlateBlue;
  final Color mutedPurple;
  final Color lightSkyBlue;
  final Color paleCyan;
  final Color burntCaramel;
  final Color goldenOak;
  final Color shadowBlack;
  final Color twilightShadow;
  final Color translucentWhite;
  final Color lightGrey;
  final Color mediumGrey;
  final Color darkNight;
  final Color deepOcean;
  final Color blackShadow;
  final Color darkSlate;
  final Color deepBlueShade;
  final Color offWhite;
  final Color beigeTan;
  final Color lightGray;
  final Color warmGray;
  final Color goldenGlow;
  final Color smokyPurple;
  final Color otherMessageGray;
  final Color userMessageBlue;
  final Color lightBlue;
  final Color darkGreyShade;
  final Color darkGrey;
  final Color red;
  final Color blue;
  final Color deepNavy;
  final Color blueback;

  const CustomColors({
    required this.midnightBlue,
    required this.dark,
    required this.white,
    required this.softWhite,
    required this.skyBlue,
    required this.pureWhite,
    required this.pureBlack,
    required this.amber,
    required this.oceanBlue,
    required this.deepAqua,
    required this.vibrantBlue,
    required this.sandyBrown,
    required this.semiTransparentBlack,
    required this.deepSlateBlue,
    required this.darkPeriwinkle,
    required this.mistySlate,
    required this.slateGrey,
    required this.semiTransparentWhite,
    required this.softLavender,
    required this.lightLavender,
    required this.paleLavender,
    required this.lightSteelBlue,
    required this.darkPurple,
    required this.deepShadow,
    required this.seafoamGreen,
    required this.goldenrodYellow,
    required this.midnightBlueDark,
    required this.deepBlue,
    required this.steelBlue,
    required this.softGreen,
    required this.fieryRed,
    required this.mutedAmethyst,
    required this.twilightPurple,
    required this.lightIceBlue,
    required this.yellow,
    required this.grey,
    required this.midnightIndigo,
    required this.darkSlateBlue,
    required this.mutedPurple,
    required this.lightSkyBlue,
    required this.paleCyan,
    required this.burntCaramel,
    required this.goldenOak,
    required this.shadowBlack,
    required this.twilightShadow,
    required this.translucentWhite,
    required this.lightGrey,
    required this.mediumGrey,
    required this.darkNight,
    required this.deepOcean,
    required this.blackShadow,
    required this.darkSlate,
    required this.deepBlueShade,
    required this.offWhite,
    required this.beigeTan,
    required this.lightGray,
    required this.warmGray,
    required this.goldenGlow,
    required this.smokyPurple,
    required this.otherMessageGray,
    required this.userMessageBlue,
    required this.lightBlue,
    required this.darkGreyShade,
    required this.darkGrey,
    required this.red,
    required this.blue,
    required this.deepNavy,
    required this.blueback,
  });

  @override
  CustomColors copyWith({Color? blue2, Color? orange2, Color? customGreen}) {
    return CustomColors(

      midnightBlue: midnightBlue ?? this.midnightBlue,
      dark: dark ?? this.dark,
      white: white ?? this.white,
      softWhite: softWhite ?? this.softWhite,
      skyBlue: skyBlue ?? this.skyBlue,
      pureWhite: pureWhite ?? this.pureWhite, 
      pureBlack: pureBlack ?? this.pureBlack,
      amber: amber ?? this.amber,
      oceanBlue:oceanBlue  ?? this.oceanBlue,
      deepAqua: deepAqua ?? this.deepAqua,
      vibrantBlue: vibrantBlue ?? this.vibrantBlue,
      sandyBrown: sandyBrown ?? this.sandyBrown,
      semiTransparentBlack: semiTransparentBlack ?? this.semiTransparentBlack,
      deepSlateBlue: deepSlateBlue ?? this.deepSlateBlue,
      darkPeriwinkle: darkPeriwinkle ?? this.darkPeriwinkle,
      mistySlate: mistySlate ?? this.mistySlate,
      slateGrey: slateGrey ?? this.slateGrey,
      semiTransparentWhite: semiTransparentWhite ?? this.semiTransparentWhite,
      softLavender: softLavender ?? this.softLavender,
      lightLavender: lightLavender ?? this.lightLavender,
      paleLavender: paleLavender ?? this.paleLavender,
      lightSteelBlue: lightSteelBlue ?? this.lightSteelBlue,
      darkPurple: darkPurple ?? this.darkPurple,
      deepShadow: deepShadow ?? this.deepShadow,
      seafoamGreen: seafoamGreen ?? this.seafoamGreen,
      goldenrodYellow: goldenrodYellow ?? this.goldenrodYellow,
      midnightBlueDark: midnightBlueDark ?? this.midnightBlueDark,
      deepBlue: deepBlue ?? this.deepBlue,
      steelBlue: steelBlue ?? this.steelBlue,
      softGreen: softGreen ?? this.softGreen,
      fieryRed: fieryRed ?? this.fieryRed,
      mutedAmethyst: mutedAmethyst ?? this.mutedAmethyst,
      twilightPurple: twilightPurple ?? this.twilightPurple,
      lightIceBlue: lightIceBlue ?? this.lightIceBlue,
      yellow: yellow ?? this.yellow,
      grey: grey ?? this.grey,
      midnightIndigo: midnightIndigo ?? this.midnightIndigo,
      darkSlateBlue: darkSlateBlue ?? this.darkSlateBlue,
      mutedPurple: mutedPurple ?? this.mutedPurple,
      lightSkyBlue: lightSkyBlue ?? this.lightSkyBlue,
      paleCyan: paleCyan ?? this.paleCyan,
      burntCaramel: burntCaramel ?? this.burntCaramel,
      goldenOak: goldenOak ?? this.goldenOak,
      shadowBlack: shadowBlack ?? this.shadowBlack,
      twilightShadow: twilightShadow ?? this.twilightShadow,
      translucentWhite: translucentWhite ?? this.translucentWhite,
      lightGrey: lightGrey ?? this.lightGrey,
      mediumGrey: mediumGrey ?? this.mediumGrey,
      darkNight: darkNight ?? this.darkNight,
      deepOcean: deepOcean ?? this.deepOcean,
      blackShadow: blackShadow ?? this.blackShadow,
      darkSlate: darkSlate ?? this.darkSlate,
      deepBlueShade: deepBlueShade ?? this.deepBlueShade,
      offWhite: offWhite ?? this.offWhite,
      beigeTan: beigeTan ?? this.beigeTan,
      lightGray: lightGray ?? this.lightGray,
      warmGray: warmGray ?? this.warmGray,
      goldenGlow: goldenGlow ?? this.goldenGlow,
      smokyPurple: smokyPurple ?? this.smokyPurple,
      otherMessageGray: otherMessageGray ?? this.otherMessageGray,
      userMessageBlue: userMessageBlue ?? this.userMessageBlue,
      lightBlue: lightBlue ?? this.lightBlue,
      darkGreyShade: darkGreyShade ?? this.darkGreyShade,
      darkGrey: darkGrey ?? this.darkGrey,
      red: red ?? this.red,
      blue: blue ?? this.blue,
      deepNavy: deepNavy ?? this.deepNavy,
      blueback: blueback ?? this.blueback,
    );
  }

  @override
  CustomColors lerp(CustomColors? other, double t) {
    if (other == null) return this;
    return CustomColors(
      midnightBlue: Color.lerp(midnightBlue, other.midnightBlue, t) ?? midnightBlue,  
      dark: Color.lerp(dark, other.dark, t) ?? dark,
      white: Color.lerp(white, other.white, t) ?? white,
      softWhite: Color.lerp(softWhite, other.softWhite, t) ?? softWhite,
      skyBlue: Color.lerp(skyBlue, other.skyBlue, t) ?? skyBlue,
      pureWhite: Color.lerp(pureWhite, other.pureWhite, t) ?? pureWhite,
      pureBlack: Color.lerp(pureBlack, other.pureBlack, t) ?? pureBlack,
      amber: Color.lerp(amber, other.amber, t) ?? amber,
      oceanBlue: Color.lerp(oceanBlue, other.oceanBlue, t) ?? oceanBlue,
      deepAqua: Color.lerp(deepAqua, other.deepAqua, t) ?? deepAqua,
      vibrantBlue: Color.lerp(vibrantBlue, other.vibrantBlue, t) ?? vibrantBlue,
      sandyBrown: Color.lerp(sandyBrown, other.sandyBrown, t) ?? sandyBrown,
      semiTransparentBlack: Color.lerp(semiTransparentBlack, other.semiTransparentBlack, t) ?? semiTransparentBlack,
      deepSlateBlue: Color.lerp(deepSlateBlue, other.deepSlateBlue, t) ?? deepSlateBlue,
      darkPeriwinkle: Color.lerp(darkPeriwinkle, other.darkPeriwinkle, t) ?? darkPeriwinkle,
      mistySlate: Color.lerp(mistySlate, other.mistySlate, t) ?? mistySlate,
      slateGrey: Color.lerp(slateGrey, other.slateGrey, t) ?? slateGrey,
      semiTransparentWhite: Color.lerp(semiTransparentWhite, other.semiTransparentWhite, t) ?? semiTransparentWhite,
      softLavender: Color.lerp(softLavender, other.softLavender, t) ?? softLavender,
      lightLavender: Color.lerp(lightLavender, other.lightLavender, t) ?? lightLavender,
      paleLavender: Color.lerp(paleLavender, other.paleLavender, t) ?? paleLavender,
      lightSteelBlue: Color.lerp(lightSteelBlue, other.lightSteelBlue, t) ?? lightSteelBlue,
      darkPurple: Color.lerp(darkPurple, other.darkPurple, t) ?? darkPurple,
      deepShadow: Color.lerp(deepShadow, other.deepShadow, t) ?? deepShadow,
      seafoamGreen: Color.lerp(seafoamGreen, other.seafoamGreen, t) ?? seafoamGreen,
      goldenrodYellow: Color.lerp(goldenrodYellow, other.goldenrodYellow, t) ?? goldenrodYellow,
      midnightBlueDark: Color.lerp(midnightBlueDark, other.midnightBlueDark, t) ?? midnightBlueDark,
      deepBlue: Color.lerp(deepBlue, other.deepBlue, t) ?? deepBlue,
      steelBlue: Color.lerp(steelBlue, other.steelBlue, t) ?? steelBlue,
      softGreen: Color.lerp(softGreen, other.softGreen, t) ?? softGreen,
      fieryRed: Color.lerp(fieryRed, other.fieryRed, t) ?? fieryRed,
      mutedAmethyst: Color.lerp(mutedAmethyst, other.mutedAmethyst, t) ?? mutedAmethyst,
      twilightPurple: Color.lerp(twilightPurple, other.twilightPurple, t) ?? twilightPurple,
      lightIceBlue: Color.lerp(lightIceBlue, other.lightIceBlue, t) ?? lightIceBlue,
      yellow: Color.lerp(yellow, other.yellow, t) ?? yellow,
      grey: Color.lerp(grey, other.grey, t) ?? grey,
      midnightIndigo: Color.lerp(midnightIndigo, other.midnightIndigo, t) ?? midnightIndigo,
      darkSlateBlue: Color.lerp(darkSlateBlue, other.darkSlateBlue, t) ?? darkSlateBlue,
      mutedPurple: Color.lerp(mutedPurple, other.mutedPurple, t) ?? mutedPurple,
      lightSkyBlue: Color.lerp(lightSkyBlue, other.lightSkyBlue, t) ?? lightSkyBlue,
      paleCyan: Color.lerp(paleCyan, other.paleCyan, t) ?? paleCyan,
      burntCaramel: Color.lerp(burntCaramel, other.burntCaramel, t) ?? burntCaramel,
      goldenOak: Color.lerp(goldenOak, other.goldenOak, t) ?? goldenOak,
      shadowBlack: Color.lerp(shadowBlack, other.shadowBlack, t) ?? shadowBlack,
      twilightShadow: Color.lerp(twilightShadow, other.twilightShadow, t) ?? twilightShadow,
      translucentWhite: Color.lerp(translucentWhite, other.translucentWhite, t) ?? translucentWhite,
      lightGrey: Color.lerp(lightGrey, other.lightGrey, t) ?? lightGrey,
      mediumGrey: Color.lerp(mediumGrey, other.mediumGrey, t) ?? mediumGrey,
      darkNight: Color.lerp(darkNight, other.darkNight, t) ?? darkNight,
      deepOcean: Color.lerp(deepOcean, other.deepOcean, t) ?? deepOcean,
      blackShadow: Color.lerp(blackShadow, other.blackShadow, t) ?? blackShadow,
      darkSlate: Color.lerp(darkSlate, other.darkSlate, t) ?? darkSlate,
      deepBlueShade: Color.lerp(deepBlueShade, other.deepBlueShade, t) ?? deepBlueShade,
      offWhite: Color.lerp(offWhite, other.offWhite, t) ?? offWhite,
      beigeTan: Color.lerp(beigeTan, other.beigeTan, t) ?? beigeTan,
      lightGray: Color.lerp(lightGray, other.lightGray, t) ?? lightGray,
      warmGray: Color.lerp(warmGray, other.warmGray, t) ?? warmGray,
      goldenGlow: Color.lerp(goldenGlow, other.goldenGlow, t) ?? goldenGlow,
      smokyPurple: Color.lerp(smokyPurple, other.smokyPurple, t) ?? smokyPurple,
      otherMessageGray: Color.lerp(otherMessageGray, other.otherMessageGray, t) ?? otherMessageGray,
      userMessageBlue: Color.lerp(userMessageBlue, other.userMessageBlue, t) ?? userMessageBlue,
      lightBlue: Color.lerp(lightBlue, other.lightBlue, t) ?? lightBlue,
      darkGreyShade: Color.lerp(darkGreyShade, other.darkGreyShade, t) ?? darkGreyShade,
      darkGrey: Color.lerp(darkGrey, other.darkGrey, t) ?? darkGrey,
      red: Color.lerp(red, other.red, t) ?? red,
      blue: Color.lerp(blue, other.blue, t) ?? blue,
      deepNavy: Color.lerp(deepNavy, other.deepNavy, t) ?? deepNavy,
      blueback: Color.lerp(blueback, other.blueback, t) ?? blueback,
    );
  }
}
