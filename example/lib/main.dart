import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'location_demo.dart';
import 'ralphs_demo.dart';
import 'text_shrink_demo.dart';
import 'custom_demo.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        title: 'DynamicSliverHeader Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: child,
      ),
      child: const DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  int _index = 0;

  static const _pages = <Widget>[
    LocationDemo(),
    RalphsDemo(),
    TextShrinkDemo(),
    CustomDemo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) =>
            setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.location_on),
              label: 'Location'),
          NavigationDestination(
              icon: Icon(Icons.store), label: 'Ralphs'),
          NavigationDestination(
              icon: Icon(Icons.text_fields),
              label: 'TextShrink'),
          NavigationDestination(
              icon: Icon(Icons.dashboard_customize),
              label: 'Custom'),
        ],
      ),
    );
  }
}
