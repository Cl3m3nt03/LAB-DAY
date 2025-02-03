import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:makeitcode/pages/projects/project_detail_page.dart';
import 'package:makeitcode/widget/progressBar.dart';

class ProjectCard extends StatefulWidget {
  final Map<String, dynamic> projet;
  const ProjectCard({super.key, required this.projet});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {

  final double _projectCardWidth = 150;
  final double _projectCardHeight = 300;
  late double percentageCompletion;

  @override
  void initState() {
    super.initState();
    percentageCompletion = (widget.projet['actualStep'] / widget.projet['nbSteps']) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          height: _projectCardHeight,
          width: _projectCardWidth,
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              )
            ],
            image: DecorationImage(
              image: AssetImage('assets/images/${widget.projet['name']}.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                            height: 60,
                            width: 130,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.projet['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Monsterrat',
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 5),

                                  if(widget.projet['state'] == 'began')
                                  Progressbar(percentageCompletion: percentageCompletion, showPercentage: true,),
                                  if(widget.projet['state'] == 'unlocked')
                                  showMore(),

                                ],
                              ),
                            ),
                          ),
                  ),
                )
              )
            ],
          ),
        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return ProjectDetailPage(projet: widget.projet, projetName: widget.projet['name'],);
            }
          ));
        },
    );
  }

  Widget showMore(){
    return Container(
      height: 23,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: <Color>[
            Color(0xff0b0c0d),
            Color(0xff0d1e30),
          ]
        ),
        borderRadius: BorderRadius.circular(50)
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
        ),
        onPressed: (){}, 
        child: Text(
          'Commencer',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white
            ),
          )
        )
    );
  }
  }