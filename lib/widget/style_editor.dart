import 'package:flutter/material.dart';
/// Theme containing text styles with various shades of purple.

const Color lavenderMist = Color.fromARGB(255, 225, 225, 255); 
const Color blushPink = Color.fromARGB(255, 205, 247, 255); 
const Color lilacDream = Color(0xFFD1C4E9); 
const Color palePeriwinkle = Color(0xFFEDE7F6); 
const Color softOrchid = Color(0xFFF3E5F5); 


const shadesOfPurpleTheme = {
  'root': TextStyle(backgroundColor: Color(0xFF2B2D42), color: Color(0xFFBFBFBF)),
  'title': TextStyle(color: Color(0xfffad000), fontWeight: FontWeight.normal),
  'name': TextStyle(color: Color(0xffa1feff), fontWeight: FontWeight.normal),
  'tag': TextStyle(color: Color(0xffffffff)),
  'attr': TextStyle(color: Color(0xfff8d000), fontStyle: FontStyle.italic),
  'built_in': TextStyle(color: Color(0xfffb9e00)),
  'selector-tag':
      TextStyle(color: Color(0xfffb9e00), fontWeight: FontWeight.normal),
  'section': TextStyle(color: Color(0xfffb9e00)),
  'keyword': TextStyle(color: Color(0xfffb9e00), fontWeight: FontWeight.normal),
  'subst': TextStyle(color: Color(0xffe3dfff)),
  'string': TextStyle(color: Color(0xff4cd213)),
  'attribute': TextStyle(color: Color(0xff4cd213)),
  'symbol': TextStyle(color: Color(0xff4cd213)),
  'bullet': TextStyle(color: Color(0xff4cd213)),
  'addition': TextStyle(color: Color(0xff4cd213)),
  'code': TextStyle(color: Color(0xff4cd213)),
  'regexp': TextStyle(color: Color(0xff4cd213)),
  'selector-class': TextStyle(color: Color(0xff4cd213)),
  'selector-attr': TextStyle(color: Color(0xff4cd213)),
  'selector-pseudo': TextStyle(color: Color(0xff4cd213)),
  'template-tag': TextStyle(color: Color(0xff4cd213)),
  'quote': TextStyle(color: Color(0xff4cd213)),
  'deletion': TextStyle(color: Color(0xff4cd213)),
  'meta': TextStyle(color: Color(0xfffb9e00)),
  'meta-string': TextStyle(color: Color(0xfffb9e00)),
  'comment': TextStyle(color: Color(0xffac65ff)),
  'literal': TextStyle(fontWeight: FontWeight.normal, color: Color(0xfffa658d)),
  'strong': TextStyle(fontWeight: FontWeight.bold),
  'number': TextStyle(color: Color(0xfffa658d)),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
};