import '../Tools/Format.dart';

import '../objects/Window.dart';
import 'package:flutter/material.dart';

class WindowPallet extends StatelessWidget {
  final List<Window> windowList;

  WindowPallet(this.windowList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text('windows in use'),
          Divider(
            thickness: 2,
            height: 4,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: windowList.map((window) {
                    return window.getPicture() != null
                        ? Column(
                            children: [
                              ListTile(
                                leading: Text(
                                  '${Format.format(window.getCount())}',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                trailing: Text(
                                    '\$${Format.format(window.grandTotal())}'),
                              ),
                              Container(
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    // Sets the width of the Column
                                    Container(
                                      child: window.getPicture(),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6,
                                    ),
                                    Positioned(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: window.factorList.entries
                                              .map((entry) {
                                            return Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      '${Format.format(entry.value.getCount())}'),
                                                  entry.value.getImage(),
                                                ],
                                              ),
                                              height: 20,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      top: 10,
                                      right: 10,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 2,
                                height: 5,
                                endIndent: 8,
                                indent: 8,
                              ),
                            ],
                          )
                        : Icon(Icons.explicit);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
