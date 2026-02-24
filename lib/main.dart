

import 'package:flutter/material.dart';
import 'package:device_preview_plus/device_preview_plus.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEADAC0)),
        scaffoldBackgroundColor: const Color(0xFFF1EADA),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Contador de Pizzas 🍕'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  List<Widget> _pizzas = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
      _playPizzaAnimation();
    });
  }

  void _decrementCounter() {
    if (_counter > 0) {
      setState(() {
        _counter--;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O contador não pode ter fatias negativas!')),
      );
    }
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _playPizzaAnimation() {
    Key key = UniqueKey();
    setState(() {
      _pizzas.add(
        _PizzaFlyingItem(
          key: key,
          onComplete: () { 
            setState(() {
              _pizzas.removeWhere((p) => p.key == key);
            });
          },
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text (
                  'Total de fatias:',
                  style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),  
            ),
          ],
        ),
      ),
          ..._pizzas,
    ],
  ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(onPressed: _decrementCounter, child: const Icon(Icons.remove), backgroundColor: const Color(0xFFC32105),),

          FloatingActionButton(onPressed: _resetCounter, child: const Icon(Icons.refresh), backgroundColor: const Color(0xFFAE7A47),),

          FloatingActionButton(onPressed: _incrementCounter, child: const Icon(Icons.add), backgroundColor: const Color(0xFF807E2A),),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _PizzaFlyingItem extends StatefulWidget {
  final VoidCallback onComplete;
  const _PizzaFlyingItem({super.key, required this.onComplete});

  @override
  State<_PizzaFlyingItem> createState() => _PizzaFlyingItemState();
}

class _PizzaFlyingItemState extends State<_PizzaFlyingItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationY;
  late Animation<double> _animationOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationY = Tween<double>(begin: 0, end: -200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _animationOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          bottom: 120 + _animationY.value,
          left: MediaQuery.of(context).size.width / 2 - 24,
          child: Opacity(
            opacity: _animationOpacity.value,
            child: const Text('🍕', style: TextStyle(fontSize: 50),),
          ),
        );
      },
    );
  }
}