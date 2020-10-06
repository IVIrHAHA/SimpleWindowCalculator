import 'dart:collection';

import './ConstructionTag.dart';
import './DifficultyTag.dart';
import './DirtyTag.dart';
import './OneSideTag.dart';
import './Tag.dart';

class Window {
  static const String ONESIDE_TAG = OneSideTag.mName;
  static const String DIRTY_TAG = DirtyTag.mName;
  static const String DIFFICULT_TAG = DifficultyTag.mName;
  static const String CONSTRUCTION_TAG = ConstructionTag.mName;

  // Default Values
  static const double _mPRICE = 12;
  static const String _mNAME = 'Standard Window';
  static const Duration _mDURATION = Duration(minutes: 10);

  final double price;
  final String name;
  final Duration duration;

  double count;

  Map<String, Tag> tagList;

  Window({this.price, this.duration, this.name}) {
    this.count = 0.0;

    this.tagList = {
      ONESIDE_TAG: OneSideTag(this.price),
      DIRTY_TAG: DirtyTag(this.price),
      DIFFICULT_TAG: DifficultyTag(this.price),
      CONSTRUCTION_TAG: ConstructionTag(this.price),
    };
  }

  getName() {
    return name != null ? name : _mNAME;
  }

  getPrice() {
    return price != null ? price : _mPRICE;
  }

  getDuration() {
    return duration != null ? duration : _mDURATION;
  }

  getTotalDuration() {
    return this.getDuration() * count;
  }

  getTotal() {
    var standardTotal = this.getPrice() * this.getCount();

    tagList.forEach((key, value) {
      standardTotal += value.getTotal();
    });

    return standardTotal;
  }

  /*
   * Indicate what tag if any is also being added
   */
  setCount({double count, String tagName}) {
    if (tagName != null) {
      tagList.update(tagName, (value) => value.setCount(count));
    }

    // Keep window count updating here
    this.count = count;
  }

  getCount() {
    return count != null ? count : 0.0;
  }
}
