import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unit_converter/backdrop.dart';
import 'package:unit_converter/back_layer/controller_menu.dart';
import 'package:unit_converter/front_layer/convert_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  String _currentCategory = 'Время';
  final List<Widget> _frontLayers = [
    ConvertTime(),
    ConvertPressure(),
    ConvertLength(),
    ConvertMass(),
    ConvertVolume(),
    ConvertDigitalStorage(),
    ConvertCorner(),
    ConvertArea(),
    ConvertFuel(),
    ConvertSpeed(),
    ConvertSpeedInternet(),
    ConvertTemperature(),
    ConvertFrequency(),
    ConvertEnergy(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return BackDrop(
      backLayer: ListItem(
        selectedItem: _currentIndex,
        onTileIndex: _onTileIndex,
        onTileCategory: _onTileCategory,
      ),
      frontLayer: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: _frontLayers[_currentIndex],
        ),
      ),
      currentIndex: _currentIndex,
      currentCategory: _currentCategory,
    );
  }

  void _onTileIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTileCategory(String category) {
    setState(() {
      _currentCategory = category;
    });
  }
}

class ConvertTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Время');
  }
}

class ConvertPressure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Давление');
  }
}

class ConvertLength extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Длина');
  }
}

class ConvertMass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Масса');
  }
}

class ConvertVolume extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Объём');
  }
}

class ConvertDigitalStorage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Объём информации');
  }
}

class ConvertCorner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Плоский угол');
  }
}

class ConvertArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Площадь');
  }
}

class ConvertFuel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Расход топлива');
  }
}

class ConvertSpeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Скорость');
  }
}

class ConvertSpeedInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Скорость Передачи Данных');
  }
}

class ConvertTemperature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Температура');
  }
}

class ConvertFrequency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Частота');
  }
}

class ConvertEnergy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetConvert('Энергия');
  }
}
