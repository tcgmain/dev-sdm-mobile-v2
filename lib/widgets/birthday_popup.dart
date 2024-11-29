import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:sdm/utils/constants.dart';

class BirthdayPopup extends StatefulWidget {

final String ownerName;
  
  const BirthdayPopup({
    super.key,
    required this.ownerName
  });

  

  @override
  State<BirthdayPopup> createState() => _BirthdayPopupState();
}

class _BirthdayPopupState extends State<BirthdayPopup> {
  late ConfettiController _centerController;

  static const Color textColorWhite = Color(0xFFFFFFFF);

  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _centerController =
        ConfettiController(duration: const Duration(milliseconds: 240));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerController.play();
      _showBirthdayDialog();
    });
  }

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

  void _showBirthdayDialog() {
    showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => Dialog(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ConfettiWidget(
              confettiController: _centerController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: true,
              gravity: 0.08,
              numberOfParticles: 240,
              emissionFrequency: 0.05,
            ),
            Opacity(
              opacity:  _visible ? 1.0 : 0.0,
              child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                 gradient: LinearGradient (
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                     Color.fromARGB(255, 37, 35, 35).withOpacity(0.95),
                     Color.fromARGB(255, 151, 47, 47).withOpacity(0.95),
                  ],
                  ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0), 
                child: Container( 
                  child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    children: [
                      Text(
                        "Today is ${widget.ownerName}'s Birthday! ",
                        style: TextStyle(
                          color: textColorWhite, 
                          fontSize: getFontSizeLarge(),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "We thought you wouldn't want to miss a chnace to wish him happy birthday!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColorWhite, 
                          fontSize: getFontSize(),
                        ),
                      ),
                      Image.asset('images/white_cake.png'),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),              
            ),
          ],
        ),
      ),
    );

    // Automatically dismiss the dialog after 15 seconds
    Future.delayed(const Duration(seconds: 9), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
