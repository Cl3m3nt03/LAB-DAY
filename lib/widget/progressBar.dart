import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';

class Progressbar extends StatefulWidget {
  final double percentageCompletion;
  final bool showPercentage;
  const Progressbar({super.key, required this.percentageCompletion,
  required this.showPercentage});

  @override
  State<Progressbar> createState() => _ProgressbarState();
}

class _ProgressbarState extends State<Progressbar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double progressWidth =
            (widget.percentageCompletion / 100) * constraints.maxWidth;

        return Container(
          height: 15,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Color(0xff010101).withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            children: [
              Container(
                height: double.maxFinite,
                width: progressWidth.clamp(0, constraints.maxWidth),
                decoration: BoxDecoration(
                  color: const Color(0xffE8B228),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              if(widget.showPercentage)
              Align(
                alignment: Alignment.center,
                child: Text(
                  '${widget.percentageCompletion.truncate()}%',
                    style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,fontSize: 10),
                  )
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
