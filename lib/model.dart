
import 'dart:math';

import 'package:logger/logger.dart';

import 'base_generator.dart';

class Model{
  final List<Segment> _segments = [];
  final _generator = DoubleBaseGenerator();
  final _counts = <int>[0,0,0,0,0];
  final int n;

  String getHash(){
    return '${_counts[0]} : ${_counts[1]} : ${_counts[2]} : ${_counts[3]} : ${_counts[4]}';
}

  Model(List<double> p, this.n){
    double a = 0;
    for(int i=0;i<p.length;i++){
      final start = a;
      a+=p[i];
      final end = a;
      _segments.add(Segment(start, end));
    }

    _segments.add(Segment(a, 1));
    Logger().i(_segments);

    for(int i=0;i<n;i++){
      final result = _generator.nextDouble;
      final index = _binarySearch(result);
      _counts[index]++;
    }
  }

  double getExperimentalP(int index){
    return _counts[index] / n;
  }

  int getCountP(int index){
    return _counts[index];
  }

  int getMax(){
    return _counts.reduce((currentMax, element) => max(currentMax, element));
  }



  int _binarySearch(double target) {
    int low = 0;
    int high = _segments.length - 1;

    while (low <= high) {
      int mid = low + ((high - low) ~/ 2);
      int compareResult = _segments[mid].contain(target);

      if (compareResult == 0) {
        return mid;
      } else if (compareResult > 0) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    return -1;
  }
}

class Segment{
  Segment(this.start, this.end);
  final double start;
  final double end;

  int contain(double point){
    if(point >= start && point < end) return 0;
    if(point < start) return -1;
    return 1;
  }

  @override
  String toString() {
    return 'Segment($start ; $end)';
  }
}