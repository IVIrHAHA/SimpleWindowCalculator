import 'package:SimpleWindowCalculator/objects/CounterObsverver.dart';
import 'package:SimpleWindowCalculator/widgets/TechDetails.dart';
import 'package:flutter/material.dart';
import 'WindowTile.dart';
import '../objects/Window.dart';

class OverviewModule extends StatefulWidget {
  final double height;
  final List<Window> windowList;
  final CounterObserver observer;

  OverviewModule({this.height, this.windowList, this.observer});

  @override
  _OverviewModuleState createState() =>
      _OverviewModuleState(height, windowList, observer);
}

class _OverviewModuleState extends State<OverviewModule>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  final double mHeight;
  final List<Window> _list;
  final CounterObserver _observer;

  _OverviewModuleState(this.mHeight, this._list, this._observer);

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mHeight,
      child: Column(
        children: [
          //Body
          Flexible(
            fit: FlexFit.tight,     
            child: ResultList(_list, _observer),
          ),
        ],
      ),
    );
  }
}

class ResultList extends StatelessWidget {
  final List<Window> items;
  final CounterObserver observer;

  ResultList(this.items, this.observer);

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? Text('List is empty')
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return WindowTile(
                name: '${items[index].getName()}',
                countDisplay: items[index].getCount(),
              );
            },
          );
  }
}
