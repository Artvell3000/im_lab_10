import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:window_size/window_size.dart';

import 'model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux)) {
    setWindowMaxSize(const Size(668, 752));
    setWindowMinSize(const Size(668, 752));
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IM-Lab-10'),
        ),
        body: const BodyWidget(),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final p1Controller = TextEditingController(text: '0.1');
  final p2Controller = TextEditingController(text: '0.1');
  final p3Controller = TextEditingController(text: '0.1');
  final p4Controller = TextEditingController(text: '0.1');
  final nController = TextEditingController(text: '100');
  Model? model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('P1:'),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: p1Controller,
                  ),
                  const SizedBox(height: 20,),
                  const Text('P2:'),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: p2Controller,
                  ),
                  const SizedBox(height: 20,),
                  const Text('P3:'),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: p3Controller,
                  ),
                  const SizedBox(height: 20,),
                  const Text('P4:'),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: p4Controller,
                  ),
                  const SizedBox(height: 20,),
                  const Text('N:'),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: nController,
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(onPressed: (){
                    final p1 = double.tryParse(p1Controller.text);
                    final p2 = double.tryParse(p2Controller.text);
                    final p3 = double.tryParse(p3Controller.text);
                    final p4 = double.tryParse(p4Controller.text);
                    final n = int.tryParse(nController.text);
                    if(p1!=null && p2!=null && p3!=null && p4!=null && n!= null){
                      setState(() {
                        model = Model([p1,p2,p3,p4], n);
                      });
                    }
                  }, child: const Center(child: Text('generate')))
                ],
              ),
            ),
          ),
          if(model!=null) ... [
            SizedBox(
                child: ChartWidget(
                  key: ValueKey(model?.getHash()),
                    model: model!
                )
            )
          ]
        ],
      ),
    );
  }
}




class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key, required this.model});
  final Model model;
  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  late final int maximum;

  @override
  void initState() {
    maximum = widget.model.getMax();
    data = [
      _ChartData(widget.model.getExperimentalP(0).toString(), widget.model.getCountP(0).toDouble()),
      _ChartData(widget.model.getExperimentalP(1).toString(), widget.model.getCountP(1).toDouble()),
      _ChartData(widget.model.getExperimentalP(2).toString(), widget.model.getCountP(2).toDouble()),
      _ChartData(widget.model.getExperimentalP(3).toString(), widget.model.getCountP(3).toDouble()),
      _ChartData(widget.model.getExperimentalP(4).toString(), widget.model.getCountP(4).toDouble())
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(minimum: 0, maximum: maximum + 10, interval: maximum % 10),
            tooltipBehavior: _tooltip,
            series: <CartesianSeries<_ChartData, String>>[
              ColumnSeries<_ChartData, String>(
                  dataSource: data,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  name: 'Data:',
                  color: const Color.fromRGBO(8, 142, 255, 1))
            ]);
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}