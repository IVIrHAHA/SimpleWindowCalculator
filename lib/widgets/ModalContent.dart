import 'package:SimpleWindowCalculator/Routes/Window_Object_Screen.dart';
import 'package:SimpleWindowCalculator/Tools/GlobalValues.dart';

import '../objects/OManager.dart';
import 'package:flutter/material.dart';

class ModalContent extends StatelessWidget {
  final Function addWindow;
  final Color backgroundColor;

  ModalContent({this.addWindow, this.backgroundColor = Colors.white});

  void createWindow(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return WindowObjectScreen(null);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double modalSheetHeight = (MediaQuery.of(context).size.height) / 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildSearchHeading(modalSheetHeight * .15, context),
        Flexible(
            fit: FlexFit.loose,
            child: buildBody(modalSheetHeight * .8, context)),
        buildButtonFooter(modalSheetHeight * .15, context),
      ],
    );
  }

  Container buildSearchHeading(double size, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GlobalValues.appMargin),
      alignment: Alignment.topRight,
      width: double.infinity,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        height: size * .7,
        width: MediaQuery.of(context).size.width * .4,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.centerRight,
        child: Text(
          'search ...',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'OpenSans',
            fontStyle: FontStyle.italic,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Container buildBody(double size, BuildContext context) {
    return Container(
      color: backgroundColor,
      //height: size,
      child: GridView.count(
        crossAxisCount: 3,
        children: OManager.windows.map((element) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Card(
              elevation: 2,
              child: Column(
                children: [
                  Container(
                    child: element.getImage(),
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                  Text(element.getName()),
                ],
              ),
            ),
            onTap: () {
              addWindow(element);
            },
          );
        }).toList(),
      ),
    );
  }

  Container buildButtonFooter(double size, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: size,
      width: double.infinity,
      color: backgroundColor,
      child: Card(
        elevation: 4,
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => createWindow(context),
          splashColor: Theme.of(context).primaryColorLight,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * .5,
            child: Text(
              'create',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 2),
            ),
          ),
        ),
      ),
    );
  }
}
