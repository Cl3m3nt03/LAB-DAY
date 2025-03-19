import 'package:flutter/material.dart';
import 'custom_colors.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(

    ),
    extensions: <ThemeExtension<dynamic>>[
      const CustomColors(
        
        dark: Colors.black,
        softWhite: Colors.white70,
        
        pureWhite: Color.fromARGB(255, 255, 255, 255),
        pureBlack: Color.fromARGB(255, 0, 0, 0),
        amber: Colors.amber,
        oceanBlue: Color.fromARGB(255, 6, 146, 194),

        deepAqua: Color.fromRGBO(6, 146, 194, 1),
        vibrantBlue: Color.fromRGBO(11, 153, 253, 1),
        sandyBrown: Color.fromARGB(250, 175, 142, 88),
        semiTransparentBlack: Colors.black26,
        deepSlateBlue: Color.fromARGB(255, 50, 52, 76),
        darkPeriwinkle: Color.fromARGB(255, 222, 226, 255),
        mistySlate: Color.fromRGBO(119, 146, 155, 0.7),
        slateGrey: Color.fromARGB(255, 79, 89, 115),
        semiTransparentWhite: Colors.white24,
        softLavender: Color.fromARGB(104, 191, 199, 237),
        lightLavender: Color.fromARGB(255, 191, 199, 237),
        paleLavender: Color.fromARGB(255, 232, 228, 243),
        lightSteelBlue: Color.fromARGB(255, 169, 186, 220),
        darkPurple: Color.fromARGB(255, 47, 3, 69),
        deepShadow: Color.fromARGB(255, 59, 49, 64),
        seafoamGreen: Color(0xff5FC2BA),
        goldenrodYellow: Color(0xffE8B228),
        midnightBlueDark: Color.fromARGB(255, 11, 15, 44),
        deepBlue: Color.fromRGBO(52, 96, 148, 1),
        steelBlue: Color.fromARGB(255, 52, 96, 148),
        softGreen: Color.fromARGB(255, 160, 202, 133),
        fieryRed: Color.fromARGB(255, 175, 58, 54),
        mutedAmethyst: Color.fromRGBO(141, 117, 179, 0.702),
        twilightPurple : Color.fromRGBO(70, 46, 109, 0.851),
        lightIceBlue: Color.fromARGB(255, 225, 240, 254),
        yellow: Colors.yellow,
        grey: Colors.grey,
        midnightIndigo: Color.fromARGB(255, 18, 27, 56),
        darkSlateBlue: Color.fromARGB(204, 24, 37, 63),
        mutedPurple: Color.fromARGB(255, 94, 79, 115),
        lightSkyBlue: Color.fromARGB(255, 209, 223, 255),
        paleCyan: Color.fromARGB(255, 141, 227, 255),
        burntCaramel: Color.fromARGB(249, 161, 119, 51),
        goldenOak: Color.fromARGB(248, 211, 157, 70),
        shadowBlack: Color.fromRGBO(0, 0, 0, 0.3),
        twilightShadow: Color.fromRGBO(24, 37, 63, 0.4),
        translucentWhite: Color.fromARGB(70, 255, 255, 255),
        lightGrey: Color(0xffE6E6E6),
        mediumGrey: Color(0xffC6C6C6),
        darkNight: Color.fromARGB(255, 19, 19, 25),
        
        blackShadow: Color(0xff010101),
        darkSlate: Color(0xff0b0c0d),
        deepBlueShade: Color(0xff0d1e30),
        offWhite: Color(0xfffdfffd),
        beigeTan: Color(0xffd4b394),
        lightGray: Color(0xffcad0cf),
        warmGray: Color(0xff9c9790),
        goldenGlow:  Color(0xffE8B228),
        red: Colors.red ,
        blue: Colors.blue,
        deepNavy: Color.fromARGB(255, 11, 22, 44),

        smokyPurple: Color(0xD95E4F73),// Equivalent to Color(0xFF5E4F73).withOpacity(0.85);
        otherMessageGray: Color(0xFFE0E0E0),// Equivalent to Colors.grey.shade300
        userMessageBlue: Color(0xFF64B5F6), // Equivalent to Colors.blue.shade300
        lightBlue: Color(0xFFBBDEFB), // Equivalent to Colors.blue[100]
        darkGreyShade: Color(0xFF616161), // Equivalent to Colors.grey.shade700
        darkGrey: Color(0xFF424242), // Equivalent to Colors.grey[800]
        
        deepOcean: Color.fromRGBO(135, 4, 152, 1),
        skyBlue: Color.fromRGBO(135, 4, 152, 1),
        midnightBlue: Color.fromRGBO(221, 192, 209, 1), 
        white: Colors.black,
        blueback: Color.fromRGBO(135, 4, 152, 0.5),
      ),
    ],
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
    ),
    extensions: <ThemeExtension<dynamic>>[
      const CustomColors(
        midnightBlue: Color.fromARGB(255, 11, 22, 44), 
        dark: Colors.black,
        white: Colors.white,

        softWhite: Colors.white70,
        skyBlue: Color.fromRGBO(0, 113, 152, 1),
        pureWhite: Color.fromARGB(255, 255, 255, 255),
        pureBlack: Color.fromARGB(255, 0, 0, 0),
        amber: Colors.amber,
        oceanBlue: Color.fromARGB(255, 6, 146, 194),
        deepAqua: Color.fromRGBO(6, 146, 194, 1),
        vibrantBlue: Color.fromRGBO(11, 153, 253, 1),
        sandyBrown: Color.fromARGB(250, 175, 142, 88),
        semiTransparentBlack: Colors.black26,
        deepSlateBlue: Color.fromARGB(255, 50, 52, 76),
        darkPeriwinkle: Color.fromARGB(255, 222, 226, 255),
        mistySlate: Color.fromRGBO(119, 146, 155, 0.7),
        slateGrey: Color.fromARGB(255, 79, 89, 115),
        semiTransparentWhite: Colors.white24,
        softLavender: Color.fromARGB(104, 191, 199, 237),
        lightLavender: Color.fromARGB(255, 191, 199, 237),
        paleLavender: Color.fromARGB(255, 232, 228, 243),
        lightSteelBlue: Color.fromARGB(255, 169, 186, 220),
        darkPurple: Color.fromARGB(255, 47, 3, 69),
        deepShadow: Color.fromARGB(255, 59, 49, 64),
        seafoamGreen: Color(0xff5FC2BA),
        goldenrodYellow: Color(0xffE8B228),
        midnightBlueDark: Color.fromARGB(255, 11, 15, 44),
        deepBlue: Color.fromRGBO(52, 96, 148, 1),
        steelBlue: Color.fromARGB(255, 52, 96, 148),
        softGreen: Color.fromARGB(255, 160, 202, 133),
        fieryRed: Color.fromARGB(255, 175, 58, 54),
        mutedAmethyst: Color.fromRGBO(141, 117, 179, 0.702),
        twilightPurple : Color.fromRGBO(70, 46, 109, 0.851),
        lightIceBlue: Color.fromARGB(255, 225, 240, 254),
        yellow: Colors.yellow,
        grey: Colors.grey,
        midnightIndigo: Color.fromARGB(255, 18, 27, 56),
        darkSlateBlue: Color.fromARGB(204, 24, 37, 63),
        mutedPurple: Color.fromARGB(255, 94, 79, 115),
        lightSkyBlue: Color.fromARGB(255, 209, 223, 255),
        paleCyan: Color.fromARGB(255, 141, 227, 255),
        burntCaramel: Color.fromARGB(249, 161, 119, 51),
        goldenOak: Color.fromARGB(248, 211, 157, 70),
        shadowBlack: Color.fromRGBO(0, 0, 0, 0.3),
        twilightShadow: Color.fromRGBO(24, 37, 63, 0.4),
        translucentWhite: Color.fromARGB(70, 255, 255, 255),
        lightGrey: Color(0xffE6E6E6),
        mediumGrey: Color(0xffC6C6C6),
        darkNight: Color.fromARGB(255, 19, 19, 25),
        deepOcean: Color.fromRGBO(11, 22, 44, 1),
        blackShadow: Color(0xff010101),
        darkSlate: Color(0xff0b0c0d),
        deepBlueShade: Color(0xff0d1e30),
        offWhite: Color(0xfffdfffd),
        beigeTan: Color(0xffd4b394),
        lightGray: Color(0xffcad0cf),
        warmGray: Color(0xff9c9790),
        goldenGlow:  Color(0xffE8B228),
        red: Colors.red ,
        blue: Colors.blue,
        deepNavy: Color.fromARGB(255, 11, 22, 44),
        blueback: Color(0xff0692C2),
        smokyPurple: Color(0xD95E4F73),// Equivalent to Color(0xFF5E4F73).withOpacity(0.85);
        otherMessageGray: Color(0xFFE0E0E0),// Equivalent to Colors.grey.shade300
        userMessageBlue: Color(0xFF64B5F6), // Equivalent to Colors.blue.shade300
        lightBlue: Color(0xFFBBDEFB), // Equivalent to Colors.blue[100]
        darkGreyShade: Color(0xFF616161), // Equivalent to Colors.grey.shade700
        darkGrey: Color(0xFF424242), // Equivalent to Colors.grey[800]
      ),
    ],
  );
}
