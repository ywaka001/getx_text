import 'package:flutter/material.dart';

// Globalkeyを使わないで座標位置を取得する方法
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Container Position Example')),
        body: ContainerPositionExample(),
      ),
    );
  }
}

class PositionedContainer extends StatelessWidget {
  final double height;
  final ValueChanged<Offset> onPositionChanged;

  PositionedContainer({required this.height, required this.onPositionChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.blue,
      child: GestureDetector(
        onTap: () {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset containerPosition = renderBox.localToGlobal(Offset.zero);
          onPositionChanged(containerPosition);
        },
        child: Center(
          child: Text(
            'Container',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ContainerPositionExample extends StatefulWidget {
  @override
  _ContainerPositionExampleState createState() =>
      _ContainerPositionExampleState();
}

class _ContainerPositionExampleState extends State<ContainerPositionExample> {
  Offset? targetContainerPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 50, color: Colors.red),
        Container(height: 50, color: Colors.green),
        PositionedContainer(
          height: 50,
          onPositionChanged: (position) {
            setState(() {
              targetContainerPosition = position;
            });
          },
        ),
        SizedBox(height: 20),
        if (targetContainerPosition != null)
          Text(
              'Target Container Position: ${targetContainerPosition.toString()}'),
      ],
    );
  }
}
