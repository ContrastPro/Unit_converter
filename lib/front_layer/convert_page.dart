import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetConvert extends StatefulWidget {
  final String _category;

  SetConvert(this._category);

  @override
  _SetConvertState createState() => _SetConvertState(_category);
}

class _SetConvertState extends State<SetConvert> {
  TextEditingController _controller;
  String _category;
  String _formula;
  String _dropdownValueInput;
  String _dropdownValueOutput;
  double _valueInput;
  double _valueOutput;
  String _parseValueOutput;
  int _dropdownIndexInput;
  int _dropdownIndexOutput;
  var _listValues;

  _SetConvertState(this._category);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = '1';
    _valueInput = 1;
    _formula = 'Test formula';
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18.0, 32.0, 18.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            textInputAction: TextInputAction.go,
            inputFormatters: [
              WhitelistingTextInputFormatter(
                RegExp("[0-9.]"),
              )
            ],
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefix: SizedBox(width: 4.0),
              suffixIcon: IconButton(
                tooltip: 'Удалить',
                icon: Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  setState(() {
                    /// Old milliseconds: 50
                    Future.delayed(Duration(milliseconds: 10)).then((_) {
                      _controller.clear();
                      FocusScope.of(context).unfocus();
                    });
                    _valueInput = 0;
                    _counter();
                  });
                },
              ),
              border: OutlineInputBorder(),
              labelText: 'Ваше значение',
              labelStyle: TextStyle(fontWeight: FontWeight.w300),
            ),
            onChanged: (value) {
              setState(() {
                _valueInput = double.parse(value);
                _counter();
              });
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 14.0),
            padding: EdgeInsets.fromLTRB(0.0, 4.5, 8.0, 4.5),
            decoration: myBoxDecoration(),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _dropdownValueInput,
                  hint: Text('Выберите значение'),
                  items:
                      _listValues.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      if (newValue != _dropdownValueOutput) {
                        _dropdownValueInput = newValue;
                        _dropdownIndexInput = _listValues.indexOf(newValue);
                        _counter();
                      } else {
                        _changeItems();
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            child: IconButton(
              tooltip: 'Поменять местами',
              icon: Icon(
                Icons.swap_vert,
                size: 35.0,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _changeItems();
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 5.0, 0.0, 5.0),
            decoration: myBoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _parseValueOutput,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                ),
                IconButton(
                  tooltip: 'Копировать',
                  icon: Icon(
                    Icons.content_copy,
                  ),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: '$_valueOutput'),
                    );
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(milliseconds: 700),
                        backgroundColor: Colors.green[600],
                        content: Text(
                          'Скопированно в буфер обмена',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 14.0),
            padding: EdgeInsets.fromLTRB(0.0, 4.5, 8.0, 4.5),
            decoration: myBoxDecoration(),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text('Выберите значение'),
                  value: _dropdownValueOutput,
                  items:
                      _listValues.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      if (newValue != _dropdownValueInput) {
                        _dropdownValueOutput = newValue;
                        _dropdownIndexOutput = _listValues.indexOf(newValue);
                        _counter();
                      } else {
                        _changeItems();
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 15.0),
            child: Text(
              'Формула',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22.0),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 48.0),
            child: Text(
              _formula,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
    );
  }

  void _changeItems() {
    String _change = _dropdownValueInput;
    _dropdownValueInput = _dropdownValueOutput;
    _dropdownValueOutput = _change;
    _dropdownIndexInput = _listValues.indexOf(_dropdownValueInput);
    _dropdownIndexOutput = _listValues.indexOf(_dropdownValueOutput);
    _counter();
  }

  void _loadData() {
    switch (_category) {
      case 'Время':
        _listValues = <String>[
          'Наносекунда',
          'Микросекунда',
          'Миллисекунда',
          'Секунда',
          'Минута',
          'Час',
          'Сутки',
          'Неделя',
          'Месяц',
          'Год',
          'Десятилетие',
          'Век',
        ];
        break;
      case 'Давление':
        _listValues = <String>[
          'Атмосфера',
          'Бар',
          'Паскаль',
          'Торр',
          'Фунт-сила на квадратный дюйм',
        ];
        break;
      case 'Длина':
        _listValues = <String>[
          'Километр',
          'Метр',
          'Сантиметр',
          'Миллиметр',
          'Микрометр',
          'Нанометр',
          'Миля',
          'Ярд',
          'Фут',
          'Дюйм',
          'Морская миля',
        ];
        break;
      case 'Масса':
        _listValues = <String>[
          'Тонна',
          'Килограмм',
          'Грамм',
          'Миллиграмм',
          'Микрограмм',
          'Английская тонна',
          'Американская тонна',
          'Стон',
          'Фунт',
          'Унция',
        ];
        break;
      case 'Объём':
        _listValues = <String>[
          'Американский галлон',
          'Американская жидкая кварта',
          'Американская жидкая пинта',
          'Американская чашка',
          'Американская жидкая унция',
          'Американская столовая ложка',
          'Американская чайная ложка',
          'Кубический метр',
          'Литр',
          'Миллилитр',
          'Имперский галлон',
          'Имперская кварта',
          'Имперская пинта',
          'Imperial cup',
          'Имперская жидкая унция',
          'Британская столовая ложка',
          'Британская чайная ложка',
          'Кубический фут',
          'Кубический дюйм',
        ];
        break;
      case 'Объём информации':
        _listValues = <String>[
          'Бит',
          'Килобит',
          'Кибибит',
          'Мегабит',
          'Мебибит',
          'Гигабит',
          'Гибибит',
          'Терабит',
          'Тебибит',
          'Петабит',
          'Пебибит',
          'Байт',
          'Килобайт',
          'Кибибайт',
          'Мегабайт',
          'Мебибайт',
          'Гигабайт',
          'Гибибайт',
          'Терабайт',
          'Тебибайт',
          'Петабайт',
          'Пебибайт',
        ];
        break;
      case 'Плоский угол':
        _listValues = <String>[
          'Град',
          'Градус',
          'Минута дуги',
          'Радиан',
          'Тысячная',
          'Угловая секунда',
        ];
        break;
      case 'Площадь':
        _listValues = <String>[
          'Квадратный километр',
          'Квадратный метр',
          'Квадратная миля',
          'Квадратный ярд',
          'Квадратный фут',
          'Квадратный дюйм',
          'Гектар',
          'Акр',
        ];
        break;
      case 'Расход топлива':
        _listValues = <String>[
          'Миля на галлон США',
          'Miles per gallon (Imperial)',
          'Километр на литр',
          'Литр на 100 километров',
        ];
        break;
      case 'Скорость':
        _listValues = <String>[
          'Миля в час',
          'Фут в секунду',
          'Метр в секунду',
          'Километр в час',
          'Узел',
        ];
        break;
      case 'Скорость Передачи Данных':
        _listValues = <String>[
          'Бит в секунду',
          'Килобит в секунду',
          'Килобайт в секунду',
          'Кибибит в секунду',
          'Мегабит в секунду',
          'Мегабайт в секунду',
          'Мебибит в секунду',
          'Гигабит в секунду',
          'Гигабайт в секунду',
          'Гибибит в секунду',
          'Терабит в секунду',
          'Терабайт в секунду',
          'Тебибит в секунду',
        ];
        break;
      case 'Температура':
        _listValues = <String>[
          'Градус Цельсия',
          'Градус Фаренгейта',
          'Кельвин',
        ];
        break;
      case 'Частота':
        _listValues = <String>[
          'Герц',
          'Килогерц',
          'Мегагерц',
          'Гигагерц',
        ];
        break;
      case 'Энергия':
        _listValues = <String>[
          'Джоуль',
          'Килоджоуль',
          'Грамм-калория',
          'Килокалория',
          'Ватт-час',
          'Киловатт-час',
          'Электронвольт',
          'Британская тепловая единица',
          'Американский терм',
          'Фут-фунт',
        ];
        break;
    }
    _dropdownValueInput = _listValues[0];
    _dropdownValueOutput = _listValues[1];
    _counter();
  }

  void _counter() {
    _dropdownIndexInput = _listValues.indexOf(_dropdownValueInput);
    _dropdownIndexOutput = _listValues.indexOf(_dropdownValueOutput);
    switch (_category) {
      case 'Время':
        _counterTime();
        break;
      case 'Давление':
        _counterPressure();
        break;
      case 'Длина':
        _counterLength();
        break;
      case 'Масса':
        _counterMass();
        break;
      case 'Объём':
        break;
      case 'Объём информации':
        break;
      case 'Плоский угол':
        _countCorner();
        break;
      case 'Площадь':
        _counterArea();
        break;
      case 'Расход топлива':
        _counterFuel();
        break;
      case 'Скорость':
        _counterSpeed();
        break;
      case 'Скорость Передачи Данных':
        break;
      case 'Температура':
        _counterTemperature();
        break;
      case 'Частота':
        _counterFrequency();
        break;
      case 'Энергия':
        break;
    }
    _valueOutput.toString().length > 15
        ? _parseValueOutput = _valueOutput.toStringAsExponential(4)
        : _parseValueOutput = _valueOutput.toString();
  }

  void _counterTime() {
    switch (_dropdownIndexInput) {

      /// Наносекунда
      case 0:
        switch (_dropdownIndexOutput) {

          /// Микросекунда
          case 1:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Миллисекунда
          case 2:
            _formula = 'Разделите значение "$_category" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;

          /// Секунда
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1e+9';
            _valueOutput = _valueInput / 1000000000;
            break;

          /// Минута
          case 4:
            _formula = 'Разделите значение "$_category" на 6e+10';
            _valueOutput = _valueInput / 60000000000;
            break;

          /// Час
          case 5:
            _formula = 'Разделите значение "$_category" на 3,6e+12';
            _valueOutput = _valueInput / 3600000000000;
            break;

          /// Сутки
          case 6:
            _formula = 'Разделите значение "$_category" на 8,64e+13';
            _valueOutput = _valueInput / 86400000000000;
            break;

          /// Неделя
          case 7:
            _formula = 'Разделите значение "$_category" на 6,048e+14';
            _valueOutput = _valueInput / 604800000000000;
            break;

          /// Месяц
          case 8:
            _formula = 'Разделите значение "$_category" на 2,628e+15';
            _valueOutput = _valueInput / 2628000000000000;
            break;

          /// Год
          case 9:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+16';
            _valueOutput = _valueInput / 31540000000000000;
            break;

          /// Десятилетие
          case 10:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+17';
            _valueOutput = _valueInput / 315400000000000000;
            break;

          /// Век
          case 11:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+18';
            _valueOutput = _valueInput / 3154000000000000000;
            break;
        }
        break;

      /// Микросекунда
      case 1:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula = 'Умножьте значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Миллисекунда
          case 2:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Секунда
          case 3:
            _formula = 'Разделите значение "$_category" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;

          /// Минута
          case 4:
            _formula = 'Разделите значение "$_category" на 6e+7';
            _valueOutput = _valueInput / 60000000;
            break;

          /// Час
          case 5:
            _formula = 'Разделите значение "$_category" на 3,6e+9';
            _valueOutput = _valueInput / 3600000000;
            break;

          /// Сутки
          case 6:
            _formula = 'Разделите значение "$_category" на 8,64e+10';
            _valueOutput = _valueInput / 86400000000;
            break;

          /// Неделя
          case 7:
            _formula = 'Разделите значение "$_category" на 6,048e+11';
            _valueOutput = _valueInput / 604800000000;
            break;

          /// Месяц
          case 8:
            _formula = 'Разделите значение "$_category" на 2,628e+12';
            _valueOutput = _valueInput / 2628000000000;
            break;

          /// Год
          case 9:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+13';
            _valueOutput = _valueInput / 31540000000000;
            break;

          /// Десятилетие
          case 10:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+14';
            _valueOutput = _valueInput / 315400000000000;
            break;

          /// Век
          case 11:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+15';
            _valueOutput = _valueInput / 3154000000000000;
            break;
        }
        break;

      /// Миллисекунда
      case 2:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula = 'Умножьте значение "$_category" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Микросекунда
          case 1:
            _formula = 'Умножьте значение "$_category" на 100';
            _valueOutput = _valueInput * 1000;
            break;

          /// Секунда
          case 3:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Минута
          case 4:
            _formula = 'Разделите значение "$_category" на 60000';
            _valueOutput = _valueInput / 60000;
            break;

          /// Час
          case 5:
            _formula = 'Разделите значение "$_category" на 3,6e+6';
            _valueOutput = _valueInput / 3600000;
            break;

          /// Сутки
          case 6:
            _formula = 'Разделите значение "$_category" на 8,64e+7';
            _valueOutput = _valueInput / 86400000;
            break;

          /// Неделя
          case 7:
            _formula = 'Разделите значение "$_category" на 6,048e+8';
            _valueOutput = _valueInput / 604800000;
            break;

          /// Месяц
          case 8:
            _formula = 'Разделите значение "$_category" на 2,628e+9';
            _valueOutput = _valueInput / 2628000000;
            break;

          /// Год
          case 9:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+10';
            _valueOutput = _valueInput / 31540000000;
            break;

          /// Десятилетие
          case 10:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+11';
            _valueOutput = _valueInput / 315400000000;
            break;

          /// Век
          case 11:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+12';
            _valueOutput = _valueInput / 3154000000000;
            break;
        }
        break;

      /// Секунда
      case 3:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1e+9';
            _valueOutput = _valueInput * 1000000000;
            break;

          /// Микросекунда
          case 1:
            _formula = 'Умножьте значение "$_category" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Миллисекунда
          case 2:
            _formula = 'Умножьте значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Минута
          case 4:
            _formula = 'Разделите значение "$_category" на 60';
            _valueOutput = _valueInput / 60;
            break;

          /// Час
          case 5:
            _formula = 'Разделите значение "$_category" на 3600';
            _valueOutput = _valueInput / 3600;
            break;

          /// Сутки
          case 6:
            _formula = 'Разделите значение "$_category" на 86400';
            _valueOutput = _valueInput / 86400;
            break;

          /// Неделя
          case 7:
            _formula = 'Разделите значение "$_category" на 604800';
            _valueOutput = _valueInput / 604800;
            break;

          /// Месяц
          case 8:
            _formula = 'Разделите значение "$_category" на 2,628e+6';
            _valueOutput = _valueInput / 2628000;
            break;

          /// Год
          case 9:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+7';
            _valueOutput = _valueInput / 31540000;
            break;

          /// Десятилетие
          case 10:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+8';
            _valueOutput = _valueInput / 315400000;
            break;

          /// Век
          case 11:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,154e+9';
            _valueOutput = _valueInput / 3154000000;
            break;
        }
        break;

      /// Минута
      case 4:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula = 'Умножьте значение "$_category" на 6e+10';
            _valueOutput = _valueInput * 60000000000;
            break;

          /// Микросекунда
          case 1:
            _formula = 'Умножьте значение "$_category" на 6e+7';
            _valueOutput = _valueInput * 60000000;
            break;

          /// Миллисекунда
          case 2:
            _formula = 'Умножьте значение "$_category" на 60000';
            _valueOutput = _valueInput * 60000;
            break;

          /// Секунда
          case 3:
            _formula = 'Умножьте значение "$_category" на 60';
            _valueOutput = _valueInput * 60;
            break;

          /// Час
          case 5:
            _formula = 'Разделите значение "$_category" на 60';
            _valueOutput = _valueInput / 60;
            break;

          /// Сутки
          case 6:
            _formula = 'Разделите значение "$_category" на 1440';
            _valueOutput = _valueInput / 1440;
            break;

          /// Неделя
          case 7:
            _formula = 'Разделите значение "$_category" на 10080';
            _valueOutput = _valueInput / 10080;
            break;

          /// Месяц
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 43800';
            _valueOutput = _valueInput / 43800;
            break;

          /// Год
          case 9:
            _formula = 'Разделите значение "$_category" на 525600';
            _valueOutput = _valueInput / 525600;
            break;

          /// Десятилетие
          case 10:
            _formula = 'Разделите значение "$_category" на 5,256e+6';
            _valueOutput = _valueInput / 5256000;
            break;

          /// Век
          case 11:
            _formula = 'Разделите значение "$_category" на 5,256e+7';
            _valueOutput = _valueInput / 52560000;
            break;
        }
        break;

      /// Час
      case 5:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula = 'Умножьте значение "$_category" на 3,6e+12';
            _valueOutput = _valueInput * 3600000000000;
            break;

          /// Микросекунда
          case 1:
            _formula = 'Умножьте значение "$_category" на 3,6e+9';
            _valueOutput = _valueInput * 3600000000;
            break;

          /// Миллисекунда
          case 2:
            _formula = 'Умножьте значение "$_category" на 3,6e+6';
            _valueOutput = _valueInput * 3600000;
            break;

          /// Секунда
          case 3:
            _formula = 'Умножьте значение "$_category" на 3600';
            _valueOutput = _valueInput * 3600;
            break;

          /// Минута
          case 4:
            _formula = 'Умножьте значение "$_category" на 60';
            _valueOutput = _valueInput * 60;
            break;

          /// Сутки
          case 6:
            _formula = 'Разделите значение "$_category" на 24';
            _valueOutput = _valueInput / 24;
            break;

          /// Неделя
          case 7:
            _formula = 'Разделите значение "$_category" на 168';
            _valueOutput = _valueInput / 168;
            break;

          /// Месяц
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 730';
            _valueOutput = _valueInput / 730;
            break;

          /// Год
          case 9:
            _formula = 'Разделите значение "$_category" на 8760';
            _valueOutput = _valueInput / 8760;
            break;

          /// Десятилетие
          case 10:
            _formula = 'Разделите значение "$_category" на 87600';
            _valueOutput = _valueInput / 87600;
            break;

          /// Век
          case 11:
            _formula = 'Разделите значение "$_category" на 876000';
            _valueOutput = _valueInput / 876000;
            break;
        }
        break;

      /// Сутки
      case 6:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula = 'Умножьте значение "$_category" на 8,64e+13';
            _valueOutput = _valueInput * 86400000000000;
            break;

          /// Микросекунда
          case 1:
            _formula = 'Умножьте значение "$_category" на 8,64e+10';
            _valueOutput = _valueInput * 86400000000;
            break;

          /// Миллисекунда
          case 2:
            _formula = 'Умножьте значение "$_category" на 8,64e+7';
            _valueOutput = _valueInput * 86400000;
            break;

          /// Секунда
          case 3:
            _formula = 'Умножьте значение "$_category" на 86400';
            _valueOutput = _valueInput * 86400;
            break;

          /// Минута
          case 4:
            _formula = 'Умножьте значение "$_category" на 1440';
            _valueOutput = _valueInput * 1440;
            break;

          /// Час
          case 5:
            _formula = 'Умножьте значение "$_category" на 24';
            _valueOutput = _valueInput * 24;
            break;

          /// Неделя
          case 7:
            _formula = 'Разделите значение "$_category" на 7';
            _valueOutput = _valueInput / 7;
            break;

          /// Месяц
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 30,417';
            _valueOutput = _valueInput / 30.417;
            break;

          /// Год
          case 9:
            _formula = 'Разделите значение "$_category" на 365';
            _valueOutput = _valueInput / 365;
            break;

          /// Десятилетие
          case 10:
            _formula = 'Разделите значение "$_category" на 3650';
            _valueOutput = _valueInput / 3650;
            break;

          /// Век
          case 11:
            _formula = 'Разделите значение "$_category" на 36500';
            _valueOutput = _valueInput / 36500;
            break;
        }
        break;

      /// Неделя
      case 7:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula = 'Умножьте значение "$_category" на 6,048e+14';
            _valueOutput = _valueInput * 604800000000000;
            break;

          /// Микросекунда
          case 1:
            _formula = 'Умножьте значение "$_category" на 6,048e+11';
            _valueOutput = _valueInput * 604800000000;
            break;

          /// Миллисекунда
          case 2:
            _formula = 'Умножьте значение "$_category" на 6,048e+8';
            _valueOutput = _valueInput * 604800000;
            break;

          /// Секунда
          case 3:
            _formula = 'Умножьте значение "$_category" на 604800';
            _valueOutput = _valueInput * 604800;
            break;

          /// Минута
          case 4:
            _formula = 'Умножьте значение "$_category" на 10080';
            _valueOutput = _valueInput * 10080;
            break;

          /// Час
          case 5:
            _formula = 'Умножьте значение "$_category" на 168';
            _valueOutput = _valueInput * 168;
            break;

          /// Сутки
          case 6:
            _formula = 'Умножьте значение "$_category" на 7';
            _valueOutput = _valueInput * 7;
            break;

          /// Месяц
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 4,345';
            _valueOutput = _valueInput / 4.345;
            break;

          /// Год
          case 9:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 52,143';
            _valueOutput = _valueInput / 52.143;
            break;

          /// Десятилетие
          case 10:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 521';
            _valueOutput = _valueInput / 521;
            break;

          /// Век
          case 11:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 5214';
            _valueOutput = _valueInput / 5214;
            break;
        }
        break;

      /// Месяц
      case 8:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula = 'Умножьте значение "$_category" на 2,628e+15';
            _valueOutput = _valueInput * 2628000000000000;
            break;

          /// Микросекунда
          case 1:
            _formula = 'Умножьте значение "$_category" на 2,628e+12';
            _valueOutput = _valueInput * 2628000000000;
            break;

          /// Миллисекунда
          case 2:
            _formula = 'Умножьте значение "$_category" на 2,628e+9';
            _valueOutput = _valueInput * 2628000000;
            break;

          /// Секунда
          case 3:
            _formula = 'Умножьте значение "$_category" на 2,628e+6';
            _valueOutput = _valueInput * 2628000;
            break;

          /// Минута
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 43800';
            _valueOutput = _valueInput * 43800;
            break;

          /// Час
          case 5:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 730';
            _valueOutput = _valueInput * 730;
            break;

          /// Сутки
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 30,417';
            _valueOutput = _valueInput * 30.417;
            break;

          /// Неделя
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 4,345';
            _valueOutput = _valueInput * 4.345;
            break;

          /// Год
          case 9:
            _formula = 'Разделите значение "$_category" на 12';
            _valueOutput = _valueInput / 12;
            break;

          /// Десятилетие
          case 10:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 120';
            _valueOutput = _valueInput / 120;
            break;

          /// Век
          case 11:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1200';
            _valueOutput = _valueInput / 1200;
            break;
        }
        break;

      /// Год
      case 9:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+16';
            _valueOutput = _valueInput * 31540000000000000;
            break;

          /// Микросекунда
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+13';
            _valueOutput = _valueInput * 31540000000000;
            break;

          /// Миллисекунда
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+10';
            _valueOutput = _valueInput * 31540000000;
            break;

          /// Секунда
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+7';
            _valueOutput = _valueInput * 31540000;
            break;

          /// Минута
          case 4:
            _formula = 'Умножьте значение "$_category" на 525600';
            _valueOutput = _valueInput * 525600;
            break;

          /// Час
          case 5:
            _formula = 'Умножьте значение "$_category" на 8760';
            _valueOutput = _valueInput * 8760;
            break;

          /// Сутки
          case 6:
            _formula = 'Умножьте значение "$_category" на 365';
            _valueOutput = _valueInput * 365;
            break;

          /// Неделя
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 52,143';
            _valueOutput = _valueInput * 52.143;
            break;

          /// Месяц
          case 8:
            _formula = 'Умножьте значение "$_category" на 12';
            _valueOutput = _valueInput * 12;
            break;

          /// Десятилетие
          case 10:
            _formula = 'Разделите значение "$_category" на 10';
            _valueOutput = _valueInput / 10;
            break;

          /// Век
          case 11:
            _formula = 'Разделите значение "$_category" на 100';
            _valueOutput = _valueInput / 100;
            break;
        }
        break;

      /// Десятилетие
      case 10:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+17';
            _valueOutput = _valueInput * 315400000000000000;
            break;

          /// Микросекунда
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+14';
            _valueOutput = _valueInput * 315400000000000;
            break;

          /// Миллисекунда
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+11';
            _valueOutput = _valueInput * 315400000000;
            break;

          /// Секунда
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+8';
            _valueOutput = _valueInput * 315400000;
            break;

          /// Минута
          case 4:
            _formula = 'Умножьте значение "$_category" на 5,256e+6';
            _valueOutput = _valueInput * 5256000;
            break;

          /// Час
          case 5:
            _formula = 'Умножьте значение "$_category" на 87600';
            _valueOutput = _valueInput * 87600;
            break;

          /// Сутки
          case 6:
            _formula = 'Умножьте значение "$_category" на 3650';
            _valueOutput = _valueInput * 3650;
            break;

          /// Неделя
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 521';
            _valueOutput = _valueInput * 521;
            break;

          /// Месяц
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 120';
            _valueOutput = _valueInput * 120;
            break;

          /// Год
          case 9:
            _formula = 'Умножьте значение "$_category" на 10';
            _valueOutput = _valueInput * 10;
            break;

          /// Век
          case 11:
            _formula = 'Разделите значение "$_category" на 10';
            _valueOutput = _valueInput / 10;
            break;
        }
        break;

      /// Век
      case 11:
        switch (_dropdownIndexOutput) {

          /// Наносекунда
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+18';
            _valueOutput = _valueInput * 3154000000000000000;
            break;

          /// Микросекунда
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+15';
            _valueOutput = _valueInput * 3154000000000000;
            break;

          /// Миллисекунда
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+12';
            _valueOutput = _valueInput * 3154000000000;
            break;

          /// Секунда
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,154e+9';
            _valueOutput = _valueInput * 3154000000;
            break;

          /// Минута
          case 4:
            _formula = 'Умножьте значение "$_category" на 5,256e+7';
            _valueOutput = _valueInput * 52560000;
            break;

          /// Час
          case 5:
            _formula = 'Умножьте значение "$_category" на 876000';
            _valueOutput = _valueInput * 876000;
            break;

          /// Сутки
          case 6:
            _formula = 'Умножьте значение "$_category" на 36500';
            _valueOutput = _valueInput * 36500;
            break;

          /// Неделя
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 5214';
            _valueOutput = _valueInput * 5214;
            break;

          /// Месяц
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1200';
            _valueOutput = _valueInput * 1200;
            break;

          /// Год
          case 9:
            _formula = 'Умножьте значение "$_category" на 100';
            _valueOutput = _valueInput * 100;
            break;

          /// Десятилетие
          case 10:
            _formula = 'Умножьте значение "$_category" на 10';
            _valueOutput = _valueInput * 10;
            break;
        }
        break;
    }
  }

  void _counterPressure() {
    switch (_dropdownIndexInput) {

      /// Атмосфера
      case 0:
        switch (_dropdownIndexOutput) {

          /// Бар
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1,013';
            _valueOutput = _valueInput * 1.013;
            break;

          /// Паскаль
          case 2:
            _formula = 'Умножьте значение "$_category" на 101325';
            _valueOutput = _valueInput * 101325;
            break;

          /// Торр
          case 3:
            _formula = 'Умножьте значение "$_category" на 760';
            _valueOutput = _valueInput * 760;
            break;

          /// Фунт-сила на квадратный дюйм
          case 4:
            _formula = 'Умножьте значение "$_category" на 14,696';
            _valueOutput = _valueInput * 14.696;
            break;
        }
        break;

      /// Бар
      case 1:
        switch (_dropdownIndexOutput) {

          /// Атмосфера
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1,013';
            _valueOutput = _valueInput / 1.013;
            break;

          /// Паскаль
          case 2:
            _formula = 'Умножьте значение "$_category" на 100000';
            _valueOutput = _valueInput * 100000;
            break;

          /// Торр
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 750';
            _valueOutput = _valueInput * 750;
            break;

          /// Фунт-сила на квадратный дюйм
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 14,504';
            _valueOutput = _valueInput * 14.504;
            break;
        }
        break;

      /// Паскаль
      case 2:
        switch (_dropdownIndexOutput) {

          /// Атмосфера
          case 0:
            _formula = 'Разделите значение "$_category" на 101325';
            _valueOutput = _valueInput / 101325;
            break;

          /// Бар
          case 1:
            _formula = 'Разделите значение "$_category" на 100000';
            _valueOutput = _valueInput / 100000;
            break;

          /// Торр
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 133';
            _valueOutput = _valueInput / 133;
            break;

          /// Фунт-сила на квадратный дюйм
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 6895';
            _valueOutput = _valueInput / 6895;
            break;
        }
        break;

      /// Торр
      case 3:
        switch (_dropdownIndexOutput) {

          /// Атмосфера
          case 0:
            _formula = 'Разделите значение "$_category" на 760';
            _valueOutput = _valueInput / 760;
            break;

          /// Бар
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 750';
            _valueOutput = _valueInput / 750;
            break;

          /// Паскаль
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 133';
            _valueOutput = _valueInput * 133;
            break;

          /// Фунт-сила на квадратный дюйм
          case 4:
            _formula = 'Разделите значение "$_category" на 51,715';
            _valueOutput = _valueInput / 51.715;
            break;
        }
        break;

      /// Фунт-сила на квадратный дюйм
      case 4:
        switch (_dropdownIndexOutput) {

          /// Атмосфера
          case 0:
            _formula = 'Разделите значение "$_category" на 14,696';
            _valueOutput = _valueInput / 14.696;
            break;

          /// Бар
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 14,504';
            _valueOutput = _valueInput / 14.504;
            break;

          /// Паскаль
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 6895';
            _valueOutput = _valueInput * 6895;
            break;

          /// Торр
          case 3:
            _formula = 'Умножьте значение "$_category" на 51,715';
            _valueOutput = _valueInput * 51.715;
            break;
        }
        break;
    }
  }

  void _counterLength() {
    switch (_dropdownIndexInput) {

      /// Километр
      case 0:
        switch (_dropdownIndexOutput) {

          /// Метр
          case 1:
            _formula = 'Умножьте значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Сантиметр
          case 2:
            _formula = 'Умножьте значение "$_category" на 100000';
            _valueOutput = _valueInput * 100000;
            break;

          /// Миллиметр
          case 3:
            _formula = 'Умножьте значение "$_category" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Микрометр
          case 4:
            _formula = 'Умножьте значение "$_category" на 1e+9';
            _valueOutput = _valueInput * 1000000000;
            break;

          /// Нанометр
          case 5:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1e+12';
            _valueOutput = _valueInput * 1000000000000;
            break;

          /// Миля
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1,609';
            _valueOutput = _valueInput / 1.609;
            break;

          /// Ярд
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1094';
            _valueOutput = _valueInput * 1094;
            break;

          /// Фут
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3281';
            _valueOutput = _valueInput * 3281;
            break;

          /// Дюйм
          case 9:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 39370';
            _valueOutput = _valueInput * 39370;
            break;

          /// Морская миля
          case 10:
            _formula = 'Разделите значение "$_category" на 1,852';
            _valueOutput = _valueInput / 1.852;
            break;
        }
        break;

      /// Метр
      case 1:
        switch (_dropdownIndexOutput) {

          /// Километр
          case 0:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Сантиметр
          case 2:
            _formula = 'Умножьте значение "$_category" на 100';
            _valueOutput = _valueInput * 100;
            break;

          /// Миллиметр
          case 3:
            _formula = 'Умножьте значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Микрометр
          case 4:
            _formula = 'Умножьте значение "$_category" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Нанометр
          case 5:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1e+9';
            _valueOutput = _valueInput * 1000000000;
            break;

          /// Миля
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1609';
            _valueOutput = _valueInput / 1609;
            break;

          /// Ярд
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1,094';
            _valueOutput = _valueInput * 1.094;
            break;

          /// Фут
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 3,281';
            _valueOutput = _valueInput * 3.281;
            break;

          /// Дюйм
          case 9:
            _formula = 'Умножьте значение "$_category" на 39,37';
            _valueOutput = _valueInput * 39.37;
            break;

          /// Морская миля
          case 10:
            _formula = 'Разделите значение "$_category" на 1852';
            _valueOutput = _valueInput / 1852;
            break;
        }
        break;

      /// Сантиметр
      case 2:
        switch (_dropdownIndexOutput) {

          /// Километр
          case 0:
            _formula = 'Разделите значение "$_category" на 100000';
            _valueOutput = _valueInput / 100000;
            break;

          /// Метр
          case 1:
            _formula = 'Разделите значение "$_category" на 100';
            _valueOutput = _valueInput / 100;
            break;

          /// Миллиметр
          case 3:
            _formula = 'Умножьте значение "$_category" на 10';
            _valueOutput = _valueInput * 10;
            break;

          /// Микрометр
          case 4:
            _formula = 'Умножьте значение "$_category" на 10000';
            _valueOutput = _valueInput * 10000;
            break;

          /// Нанометр
          case 5:
            _formula = 'Умножьте значение "$_category" на 1e+7';
            _valueOutput = _valueInput * 10000000;
            break;

          /// Миля
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 160934';
            _valueOutput = _valueInput / 160934;
            break;

          /// Ярд
          case 7:
            _formula = 'Разделите значение "$_category" на 91,44';
            _valueOutput = _valueInput / 91.44;
            break;

          /// Фут
          case 8:
            _formula = 'Разделите значение "$_category" на 30,48';
            _valueOutput = _valueInput / 30.48;
            break;

          /// Дюйм
          case 9:
            _formula = 'Разделите значение "$_category" на 2,54';
            _valueOutput = _valueInput / 2.54;
            break;

          /// Морская миля
          case 10:
            _formula = 'Разделите значение "$_category" на 185200';
            _valueOutput = _valueInput / 185200;
            break;
        }
        break;

      /// Миллиметр
      case 3:
        switch (_dropdownIndexOutput) {

          /// Километр
          case 0:
            _formula = 'Разделите значение "$_category" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;

          /// Метр
          case 1:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Сантиметр
          case 2:
            _formula = 'Разделите значение "$_category" на 10';
            _valueOutput = _valueInput / 10;
            break;

          /// Микрометр
          case 4:
            _formula = 'Умножьте значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Нанометр
          case 5:
            _formula = 'Умножьте значение "$_category" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Миля
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1,609e+6';
            _valueOutput = _valueInput / 1609000;
            break;

          /// Ярд
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 914';
            _valueOutput = _valueInput / 914;
            break;

          /// Фут
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 305';
            _valueOutput = _valueInput / 305;
            break;

          /// Дюйм
          case 9:
            _formula = 'Разделите значение "$_category" на 25,4';
            _valueOutput = _valueInput / 25.4;
            break;

          /// Морская миля
          case 10:
            _formula = 'Разделите значение "$_category" на 1,852e+6';
            _valueOutput = _valueInput / 1852000;
            break;
        }
        break;

      /// Микрометр
      case 4:
        switch (_dropdownIndexOutput) {

          /// Километр
          case 0:
            _formula = 'Разделите значение "$_category" на 1e+9';
            _valueOutput = _valueInput / 1000000000;
            break;

          /// Метр
          case 1:
            _formula = 'Разделите значение "$_category" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;

          /// Сантиметр
          case 2:
            _formula = 'Разделите значение "$_category" на 10000';
            _valueOutput = _valueInput / 10000;
            break;

          /// Миллиметр
          case 3:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Нанометр
          case 5:
            _formula = 'Умножьте значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Миля
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1,609e+9';
            _valueOutput = _valueInput / 1609000000;
            break;

          /// Ярд
          case 7:
            _formula = 'Разделите значение "$_category" на 914400';
            _valueOutput = _valueInput / 914400;
            break;

          /// Фут
          case 8:
            _formula = 'Разделите значение "$_category" на 304800';
            _valueOutput = _valueInput / 304800;
            break;

          /// Дюйм
          case 9:
            _formula = 'Разделите значение "$_category" на 25400';
            _valueOutput = _valueInput / 25400;
            break;

          /// Морская миля
          case 10:
            _formula = 'Разделите значение "$_category" на 1,852e+9';
            _valueOutput = _valueInput / 1852000000;
            break;
        }
        break;

      /// Нанометр
      case 5:
        switch (_dropdownIndexOutput) {

          /// Километр
          case 0:
            _formula = 'Разделите значение "$_category" на 1e+12';
            _valueOutput = _valueInput / 1000000000000;
            break;

          /// Метр
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1e+9';
            _valueOutput = _valueInput / 1000000000;
            break;

          /// Сантиметр
          case 2:
            _formula = 'Разделите значение "$_category" на 1e+7';
            _valueOutput = _valueInput / 10000000;
            break;

          /// Миллиметр
          case 3:
            _formula = 'Разделите значение "$_category" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;

          /// Микрометр
          case 4:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Миля
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1,609e+12';
            _valueOutput = _valueInput / 1609000000000;
            break;

          /// Ярд
          case 7:
            _formula = 'Разделите значение "$_category" на 9,144e+8';
            _valueOutput = _valueInput / 914400000;
            break;

          /// Фут
          case 8:
            _formula = 'Разделите значение "$_category" на 3,048e+8';
            _valueOutput = _valueInput / 304800000;
            break;

          /// Дюйм
          case 9:
            _formula = 'Разделите значение "$_category" на 2,54e+7';
            _valueOutput = _valueInput / 25400000;
            break;

          /// Морская миля
          case 10:
            _formula = 'Разделите значение "$_category" на 1,852e+12';
            _valueOutput = _valueInput / 1852000000000;
            break;
        }
        break;

      /// Миля
      case 6:
        switch (_dropdownIndexOutput) {

          /// Километр
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1,609';
            _valueOutput = _valueInput * 1.609;
            break;

          /// Метр
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1609';
            _valueOutput = _valueInput * 1609;
            break;

          /// Сантиметр
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 160934';
            _valueOutput = _valueInput * 160934;
            break;

          /// Миллиметр
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1,609e+6';
            _valueOutput = _valueInput * 1609000;
            break;

          /// Микрометр
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1,609e+9';
            _valueOutput = _valueInput * 1609000000;
            break;

          /// Нанометр
          case 5:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1,609e+12';
            _valueOutput = _valueInput * 1609000000000;
            break;

          /// Ярд
          case 7:
            _formula = 'Умножьте значение "$_category" на 1760';
            _valueOutput = _valueInput * 1760;
            break;

          /// Фут
          case 8:
            _formula = 'Умножьте значение "$_category" на 5280';
            _valueOutput = _valueInput * 5280;
            break;

          /// Дюйм
          case 9:
            _formula = 'Умножьте значение "$_category" на 63360';
            _valueOutput = _valueInput * 63360;
            break;

          /// Морская миля
          case 10:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1,151';
            _valueOutput = _valueInput / 1.151;
            break;
        }
        break;

      /// Ярд
      case 7:
        switch (_dropdownIndexOutput) {

          /// Километр
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1094';
            _valueOutput = _valueInput / 1094;
            break;

          /// Метр
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1,094';
            _valueOutput = _valueInput / 1.094;
            break;

          /// Сантиметр
          case 2:
            _formula = 'Умножьте значение "$_category" на 91,44';
            _valueOutput = _valueInput * 91.44;
            break;

          /// Миллиметр
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 914';
            _valueOutput = _valueInput * 914;
            break;

          /// Микрометр
          case 4:
            _formula = 'Умножьте значение "$_category" на 914400';
            _valueOutput = _valueInput * 914400;
            break;

          /// Нанометр
          case 5:
            _formula = 'Умножьте значение "$_category" на 9,144e+8';
            _valueOutput = _valueInput * 914400000;
            break;

          /// Миля
          case 6:
            _formula = 'Разделите значение "$_category" на 1760';
            _valueOutput = _valueInput / 1760;
            break;

          /// Фут
          case 8:
            _formula = 'Умножьте значение "$_category" на 3';
            _valueOutput = _valueInput * 3;
            break;

          /// Дюйм
          case 9:
            _formula = 'Умножьте значение "$_category" на 36';
            _valueOutput = _valueInput * 36;
            break;

          /// Морская миля
          case 10:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 2025';
            _valueOutput = _valueInput / 2025;
            break;
        }
        break;

      /// Фут
      case 8:
        switch (_dropdownIndexOutput) {

          /// Километр
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3281';
            _valueOutput = _valueInput / 3281;
            break;

          /// Метр
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 3,281';
            _valueOutput = _valueInput / 3.281;
            break;

          /// Сантиметр
          case 2:
            _formula = 'Умножьте значение "$_category" на 30,48';
            _valueOutput = _valueInput * 30.48;
            break;

          /// Миллиметр
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 305';
            _valueOutput = _valueInput * 305;
            break;

          /// Микрометр
          case 4:
            _formula = 'Умножьте значение "$_category" на 304800';
            _valueOutput = _valueInput * 304800;
            break;

          /// Нанометр
          case 5:
            _formula = 'Умножьте значение "$_category" на 3,048e+8';
            _valueOutput = _valueInput * 304800000;
            break;

          /// Миля
          case 6:
            _formula = 'Разделите значение "$_category" на 5280';
            _valueOutput = _valueInput / 5280;
            break;

          /// Ярд
          case 7:
            _formula = 'Разделите значение "$_category" на 3';
            _valueOutput = _valueInput / 3;
            break;

          /// Дюйм
          case 9:
            _formula = 'Умножьте значение "$_category" на 12';
            _valueOutput = _valueInput * 12;
            break;

          /// Морская миля
          case 10:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 6076';
            _valueOutput = _valueInput / 6076;
            break;
        }
        break;

      /// Дюйм
      case 9:
        switch (_dropdownIndexOutput) {

          /// Километр
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 39370';
            _valueOutput = _valueInput / 39370;
            break;

          /// Метр
          case 1:
            _formula = 'Разделите значение "$_category" на 39,37';
            _valueOutput = _valueInput / 39.37;
            break;

          /// Сантиметр
          case 2:
            _formula = 'Умножьте значение "$_category" на 2,54';
            _valueOutput = _valueInput * 2.54;
            break;

          /// Миллиметр
          case 3:
            _formula = 'Умножьте значение "$_category" на 25,4';
            _valueOutput = _valueInput * 25.4;
            break;

          /// Микрометр
          case 4:
            _formula = 'Умножьте значение "$_category" на 25400';
            _valueOutput = _valueInput * 25400;
            break;

          /// Нанометр
          case 5:
            _formula = 'Умножьте значение "$_category" на 2,54e+7';
            _valueOutput = _valueInput * 25400000;
            break;

          /// Миля
          case 6:
            _formula = 'Разделите значение "$_category" на 63360';
            _valueOutput = _valueInput / 63360;
            break;

          /// Ярд
          case 7:
            _formula = 'Разделите значение "$_category" на 36';
            _valueOutput = _valueInput / 36;
            break;

          /// Фут
          case 8:
            _formula = 'Разделите значение "$_category" на 12';
            _valueOutput = _valueInput / 12;
            break;

          /// Морская миля
          case 10:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 72913';
            _valueOutput = _valueInput / 72913;
            break;
        }
        break;

      /// Морская миля
      case 10:
        switch (_dropdownIndexOutput) {

          /// Километр
          case 0:
            _formula = 'Умножьте значение "$_category" на 1,852';
            _valueOutput = _valueInput * 1.852;
            break;

          /// Метр
          case 1:
            _formula = 'Умножьте значение "$_category" на 1852';
            _valueOutput = _valueInput * 1852;
            break;

          /// Сантиметр
          case 2:
            _formula = 'Умножьте значение "$_category" на 185200';
            _valueOutput = _valueInput * 185200;
            break;

          /// Миллиметр
          case 3:
            _formula = 'Умножьте значение "$_category" на 1,852e+6';
            _valueOutput = _valueInput * 1852000;
            break;

          /// Микрометр
          case 4:
            _formula = 'Умножьте значение "$_category" на 1,852e+9';
            _valueOutput = _valueInput * 1852000000;
            break;

          /// Нанометр
          case 5:
            _formula = 'Умножьте значение "$_category" на 1,852e+12';
            _valueOutput = _valueInput * 1852000000000;
            break;

          /// Миля
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 1,151';
            _valueOutput = _valueInput * 1.151;
            break;

          /// Ярд
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 2025';
            _valueOutput = _valueInput * 2025;
            break;

          /// Фут
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 6076';
            _valueOutput = _valueInput * 6076;
            break;

          /// Дюйм
          case 9:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 72913';
            _valueOutput = _valueInput * 72913;
            break;
        }
        break;
    }
  }

  void _counterMass() {
    switch (_dropdownIndexInput) {

      /// Тонна
      case 0:
        switch (_dropdownIndexOutput) {

          /// Килограмм
          case 1:
            _formula = 'Умножьте значение "масса" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Грамм
          case 2:
            _formula = 'Умножьте значение "масса" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Миллиграмм
          case 3:
            _formula = 'Умножьте значение "масса" на 1e+9';
            _valueOutput = _valueInput * 1000000000;
            break;

          /// Микрограмм
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 1e+12';
            _valueOutput = _valueInput * 1000000000000;
            break;

          /// Английская тонна
          case 5:
            _formula = 'Разделите значение "масса" на 1,016';
            _valueOutput = _valueInput / 1.016;
            break;

          /// Американская тонна
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 1,102';
            _valueOutput = _valueInput * 1.102;
            break;

          /// Стон
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 157';
            _valueOutput = _valueInput * 157;
            break;

          /// Фунт
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 2205';
            _valueOutput = _valueInput * 2205;
            break;

          /// Унция
          case 9:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 35274';
            _valueOutput = _valueInput * 35274;
            break;
        }
        break;

      /// Килограмм
      case 1:
        switch (_dropdownIndexOutput) {

          /// Тонна
          case 0:
            _formula = 'Разделите значение "масса" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Грамм
          case 2:
            _formula = 'Умножьте значение "масса" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Миллиграмм
          case 3:
            _formula = 'Умножьте значение "масса" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Микрограмм
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 1e+9';
            _valueOutput = _valueInput * 1000000000;
            break;

          /// Английская тонна
          case 5:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 1016';
            _valueOutput = _valueInput / 1016;
            break;

          /// Американская тонна
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 907';
            _valueOutput = _valueInput / 907;
            break;

          /// Стон
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 6,35';
            _valueOutput = _valueInput / 6.35;
            break;

          /// Фунт
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 2,205';
            _valueOutput = _valueInput * 2.205;
            break;

          /// Унция
          case 9:
            _formula = 'Умножьте значение "масса" на 35,274';
            _valueOutput = _valueInput * 35.274;
            break;
        }
        break;

      /// Грамм
      case 2:
        switch (_dropdownIndexOutput) {

          /// Тонна
          case 0:
            _formula = 'Разделите значение "масса" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;

          /// Килограмм
          case 1:
            _formula = 'Разделите значение "масса" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Миллиграмм
          case 3:
            _formula = 'Умножьте значение "масса" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Микрограмм
          case 4:
            _formula = 'Умножьте значение "масса" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Английская тонна
          case 5:
            _formula = 'Разделите значение "масса" на 1,016e+6';
            _valueOutput = _valueInput / 1016000;
            break;

          /// Американская тонна
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 907185';
            _valueOutput = _valueInput / 907185;
            break;

          /// Стон
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 6350';
            _valueOutput = _valueInput / 6350;
            break;

          /// Фунт
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 454';
            _valueOutput = _valueInput / 454;
            break;

          /// Унция
          case 9:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 28,35';
            _valueOutput = _valueInput / 28.35;
            break;
        }
        break;

      /// Миллиграмм
      case 3:
        switch (_dropdownIndexOutput) {

          /// Тонна
          case 0:
            _formula = 'Разделите значение "масса" на 1e+9';
            _valueOutput = _valueInput / 1000000000;
            break;

          /// Килограмм
          case 1:
            _formula = 'Разделите значение "масса" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;

          /// Грамм
          case 2:
            _formula = 'Разделите значение "масса" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Микрограмм
          case 4:
            _formula = 'Умножьте значение "масса" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Английская тонна
          case 5:
            _formula = 'Разделите значение "масса" на 1,016e+9';
            _valueOutput = _valueInput / 1016000000;
            break;

          /// Американская тонна
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 9,072e+8';
            _valueOutput = _valueInput / 907200000;
            break;

          /// Стон
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 6,35e+6';
            _valueOutput = _valueInput / 6350000;
            break;

          /// Фунт
          case 8:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 453592';
            _valueOutput = _valueInput / 453592;
            break;

          /// Унция
          case 9:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 28350';
            _valueOutput = _valueInput / 28350;
            break;
        }
        break;

      /// Микрограмм
      case 4:
        switch (_dropdownIndexOutput) {

          /// Тонна
          case 0:
            _formula = 'Разделите значение "масса" на 1e+12';
            _valueOutput = _valueInput / 1000000000000;
            break;

          /// Килограмм
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 1e+9';
            _valueOutput = _valueInput / 1000000000;
            break;

          /// Грамм
          case 2:
            _formula = 'Разделите значение "масса" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;

          /// Миллиграмм
          case 3:
            _formula = 'Разделите значение "масса" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Английская тонна
          case 5:
            _formula = 'Разделите значение "масса" на 1,016e+12';
            _valueOutput = _valueInput / 1016000000000;
            break;

          /// Американская тонна
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 9,072e+11';
            _valueOutput = _valueInput / 907200000000;
            break;

          /// Стон
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 6,35e+9';
            _valueOutput = _valueInput / 6350000000;
            break;

          /// Фунт
          case 8:
            _formula = 'Разделите значение "масса" на 4,536e+8';
            _valueOutput = _valueInput / 453600000;
            break;

          /// Унция
          case 9:
            _formula = 'Разделите значение "масса" на 2,835e+7';
            _valueOutput = _valueInput / 28350000;
            break;
        }
        break;

      /// Английская тонна
      case 5:
        switch (_dropdownIndexOutput) {

          /// Тонна
          case 0:
            _formula = 'Умножьте значение "масса" на 1,016';
            _valueOutput = _valueInput * 1.016;
            break;

          /// Килограмм
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 1016';
            _valueOutput = _valueInput * 1016;
            break;

          /// Грамм
          case 2:
            _formula = 'Умножьте значение "масса" на 1,016e+6';
            _valueOutput = _valueInput * 1016000;
            break;

          /// Миллиграмм
          case 3:
            _formula = 'Умножьте значение "масса" на 1,016e+9';
            _valueOutput = _valueInput * 1016000000;
            break;

          /// Микрограмм
          case 4:
            _formula = 'Умножьте значение "масса" на 1,016e+12';
            _valueOutput = _valueInput * 1016000000000;
            break;

          /// Американская тонна
          case 6:
            _formula = 'Умножьте значение "масса" на 1,12';
            _valueOutput = _valueInput * 1.12;
            break;

          /// Стон
          case 7:
            _formula = 'Умножьте значение "масса" на 160';
            _valueOutput = _valueInput * 160;
            break;

          /// Фунт
          case 8:
            _formula = 'Умножьте значение "масса" на 2240';
            _valueOutput = _valueInput * 2240;
            break;

          /// Унция
          case 9:
            _formula = 'Умножьте значение "масса" на 35840';
            _valueOutput = _valueInput * 35840;
            break;
        }
        break;

      /// Американская тонна
      case 6:
        switch (_dropdownIndexOutput) {

          /// Тонна
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 1,102';
            _valueOutput = _valueInput / 1.102;
            break;

          /// Килограмм
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 907';
            _valueOutput = _valueInput * 907;
            break;

          /// Грамм
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 907185';
            _valueOutput = _valueInput * 907185;
            break;

          /// Миллиграмм
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 9,072e+8';
            _valueOutput = _valueInput * 907200000;
            break;

          /// Микрограмм
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 9,072e+11';
            _valueOutput = _valueInput * 907200000000;
            break;

          /// Английская тонна
          case 5:
            _formula = 'Разделите значение "масса" на 1,12';
            _valueOutput = _valueInput / 1.12;
            break;

          /// Стон
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 143';
            _valueOutput = _valueInput * 143;
            break;

          /// Фунт
          case 8:
            _formula = 'Умножьте значение "масса" на 2000';
            _valueOutput = _valueInput * 2000;
            break;

          /// Унция
          case 9:
            _formula = 'Умножьте значение "масса" на 32000';
            _valueOutput = _valueInput * 32000;
            break;
        }
        break;

      /// Стон
      case 7:
        switch (_dropdownIndexOutput) {

          /// Тонна
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 157';
            _valueOutput = _valueInput / 157;
            break;

          /// Килограмм
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 6,35';
            _valueOutput = _valueInput * 6.35;
            break;

          /// Грамм
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 6350';
            _valueOutput = _valueInput * 6350;
            break;

          /// Миллиграмм
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 6,35e+6';
            _valueOutput = _valueInput * 6350000;
            break;

          /// Микрограмм
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 6,35e+9';
            _valueOutput = _valueInput * 6350000000;
            break;

          /// Английская тонна
          case 5:
            _formula = 'Разделите значение "масса" на 160';
            _valueOutput = _valueInput / 160;
            break;

          /// Американская тонна
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 143';
            _valueOutput = _valueInput / 143;
            break;

          /// Фунт
          case 8:
            _formula = 'Умножьте значение "масса" на 14';
            _valueOutput = _valueInput * 14;
            break;

          /// Унция
          case 9:
            _formula = 'Умножьте значение "масса" на 224';
            _valueOutput = _valueInput * 224;
            break;
        }
        break;

      /// Фунт
      case 8:
        switch (_dropdownIndexOutput) {

          /// Тонна
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 2205';
            _valueOutput = _valueInput / 2205;
            break;

          /// Килограмм
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 2,205';
            _valueOutput = _valueInput / 2.205;
            break;

          /// Грамм
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 454';
            _valueOutput = _valueInput * 454;
            break;

          /// Миллиграмм
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 453592';
            _valueOutput = _valueInput * 453592;
            break;

          /// Микрограмм
          case 4:
            _formula = 'Умножьте значение "масса" на 4,536e+8';
            _valueOutput = _valueInput * 453600000;
            break;

          /// Английская тонна
          case 5:
            _formula = 'Разделите значение "масса" на 2240';
            _valueOutput = _valueInput / 2240;
            break;

          /// Американская тонна
          case 6:
            _formula = 'Разделите значение "масса" на 2000';
            _valueOutput = _valueInput / 2000;
            break;

          /// Стон
          case 7:
            _formula = 'Разделите значение "масса" на 14';
            _valueOutput = _valueInput / 14;
            break;

          /// Унция
          case 9:
            _formula = 'Умножьте значение "масса" на 16';
            _valueOutput = _valueInput * 16;
            break;
        }
        break;

      /// Унция
      case 9:
        switch (_dropdownIndexOutput) {

          /// Тонна
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "масса" на 35274';
            _valueOutput = _valueInput / 35274;
            break;

          /// Килограмм
          case 1:
            _formula = 'Разделите значение "масса" на 35,274';
            _valueOutput = _valueInput / 35.274;
            break;

          /// Грамм
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 28,35';
            _valueOutput = _valueInput * 28.35;
            break;

          /// Миллиграмм
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "масса" на 28350';
            _valueOutput = _valueInput * 28350;
            break;

          /// Микрограмм
          case 4:
            _formula = 'Умножьте значение "масса" на 2,835e+7';
            _valueOutput = _valueInput * 28350000;
            break;

          /// Английская тонна
          case 5:
            _formula = 'Разделите значение "масса" на 35840';
            _valueOutput = _valueInput / 35840;
            break;

          /// Американская тонна
          case 6:
            _formula = 'Разделите значение "масса" на 32000';
            _valueOutput = _valueInput / 32000;
            break;

          /// Стон
          case 7:
            _formula = 'Разделите значение "масса" на 224';
            _valueOutput = _valueInput / 224;
            break;

          /// Фунт
          case 8:
            _formula = 'Разделите значение "масса" на 16';
            _valueOutput = _valueInput / 16;
            break;
        }
        break;
    }
  }

  void _counterFrequency() {
    switch (_dropdownIndexInput) {

      /// Герц
      case 0:
        switch (_dropdownIndexOutput) {

          /// Килогерц
          case 1:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Мегагерц
          case 2:
            _formula = 'Разделите значение "$_category" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;

          /// Гигагерц
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 1e+9';
            _valueOutput = _valueInput / 1000000000;
            break;
        }
        break;

      /// Килогерц
      case 1:
        switch (_dropdownIndexOutput) {

          /// Герц
          case 0:
            _formula = 'Умножьте значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Мегагерц
          case 2:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput / 1000;
            break;

          /// Гигагерц
          case 3:
            _formula = 'Разделите значение "$_category" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;
        }
        break;

      /// Мегагерц
      case 2:
        switch (_dropdownIndexOutput) {

          /// Герц
          case 0:
            _formula = 'Умножьте значение "$_category" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Килогерц
          case 1:
            _formula = 'Умножьте значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Гигагерц
          case 3:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput / 1000;
            break;
        }
        break;

      /// Гигагерц
      case 3:
        switch (_dropdownIndexOutput) {

          /// Герц
          case 0:
            _formula = 'Умножьте значение "$_category" на 1e+9';
            _valueOutput = _valueInput * 1000000000;
            break;

          /// Килогерц
          case 1:
            _formula = 'Умножьте значение "$_category" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Мегагерц
          case 2:
            _formula = 'Умножьте значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;
        }
        break;
    }
  }

  void _counterArea() {
    switch (_dropdownIndexInput) {

      /// Квадратный километр
      case 0:
        switch (_dropdownIndexOutput) {

          /// Квадратный метр
          case 1:
            _formula = 'Умножьте значение "площадь" на 1e+6';
            _valueOutput = _valueInput * 1000000;
            break;

          /// Квадратная миля
          case 2:
            _formula = 'Разделите значение "площадь" на 2,59';
            _valueOutput = _valueInput / 2.59;
            break;

          /// Квадратный ярд
          case 3:
            _formula = 'Умножьте значение "площадь" на 1,196e+6';
            _valueOutput = _valueInput * 1196000;
            break;

          /// Квадратный фут
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 1,076e+7';
            _valueOutput = _valueInput * 10760000;
            break;

          /// Квадратный дюйм
          case 5:
            _formula = 'Умножьте значение "площадь" на 1,55e+9';
            _valueOutput = _valueInput * 1550000000;
            break;

          /// Гектар
          case 6:
            _formula = 'Умножьте значение "площадь" на 100';
            _valueOutput = _valueInput * 100;
            break;

          /// Акр
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 247';
            _valueOutput = _valueInput * 274;
            break;
        }
        break;

      /// Квадратный метр
      case 1:
        switch (_dropdownIndexOutput) {

          /// Квадратный километр
          case 0:
            _formula = 'Разделите значение "площадь" на 1e+6';
            _valueOutput = _valueInput / 1000000;
            break;

          /// Квадратная миля
          case 2:
            _formula = 'Разделите значение "площадь" на 2,59e+6';
            _valueOutput = _valueInput / 2590000;
            break;

          /// Квадратный ярд
          case 3:
            _formula = 'Умножьте значение "площадь" на 1,196';
            _valueOutput = _valueInput * 1.196;
            break;

          /// Квадратный фут
          case 4:
            _formula = 'Умножьте значение "площадь" на 10,764';
            _valueOutput = _valueInput * 10.764;
            break;

          /// Квадратный дюйм
          case 5:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 1550';
            _valueOutput = _valueInput * 1550;
            break;

          /// Гектар
          case 6:
            _formula = 'Разделите значение "площадь" на 10000';
            _valueOutput = _valueInput / 10000;
            break;

          /// Акр
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 4047';
            _valueOutput = _valueInput / 4047;
            break;
        }
        break;

      /// Квадратная миля
      case 2:
        switch (_dropdownIndexOutput) {

          /// Квадратный километр
          case 0:
            _formula = 'Умножьте значение "площадь" на 2,59';
            _valueOutput = _valueInput * 2.59;
            break;

          /// Квадратный метр
          case 1:
            _formula = 'Умножьте значение "площадь" на 2,59e+6';
            _valueOutput = _valueInput * 2590000;
            break;

          /// Квадратный ярд
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 3,098e+6';
            _valueOutput = _valueInput * 3098000;
            break;

          /// Квадратный фут
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 2,788e+7';
            _valueOutput = _valueInput * 27880000;
            break;

          /// Квадратный дюйм
          case 5:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 4,014e+9';
            _valueOutput = _valueInput * 4014000000;
            break;

          /// Гектар
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 259';
            _valueOutput = _valueInput * 259;
            break;

          /// Акр
          case 7:
            _formula = 'Умножьте значение "площадь" на 640';
            _valueOutput = _valueInput * 640;
            break;
        }
        break;

      /// Квадратный ярд
      case 3:
        switch (_dropdownIndexOutput) {

          /// Квадратный километр
          case 0:
            _formula = 'Разделите значение "площадь" на 1,196e+6';
            _valueOutput = _valueInput / 1196000;
            break;

          /// Квадратный метр
          case 1:
            _formula = 'Разделите значение "площадь" на 1,196';
            _valueOutput = _valueInput * 1.196;
            break;

          /// Квадратная миля
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 3,098e+6';
            _valueOutput = _valueInput / 3098000;
            break;

          /// Квадратный фут
          case 4:
            _formula = 'Умножьте значение "площадь" на 9';
            _valueOutput = _valueInput * 9;
            break;

          /// Квадратный дюйм
          case 5:
            _formula = 'Умножьте значение "площадь" на 1296';
            _valueOutput = _valueInput * 1296;
            break;

          /// Гектар
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 11960';
            _valueOutput = _valueInput / 11960;
            break;

          /// Акр
          case 7:
            _formula = 'Разделите значение "площадь" на 4840';
            _valueOutput = _valueInput / 4840;
            break;
        }
        break;

      /// Квадратный фут
      case 4:
        switch (_dropdownIndexOutput) {

          /// Квадратный километр
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 1,076e+7';
            _valueOutput = _valueInput / 10760000;
            break;

          /// Квадратный метр
          case 1:
            _formula = 'Разделите значение "площадь" на 10,764';
            _valueOutput = _valueInput / 10.764;
            break;

          /// Квадратная миля
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 2,788e+7';
            _valueOutput = _valueInput / 27880000;
            break;

          /// Квадратный ярд
          case 3:
            _formula = 'Разделите значение "площадь" на 9';
            _valueOutput = _valueInput / 9;
            break;

          /// Квадратный дюйм
          case 5:
            _formula = 'Умножьте значение "площадь" на 144';
            _valueOutput = _valueInput * 144;
            break;

          /// Гектар
          case 6:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 107639';
            _valueOutput = _valueInput / 107639;
            break;

          /// Акр
          case 7:
            _formula = 'Разделите значение "площадь" на 43560';
            _valueOutput = _valueInput / 43560;
            break;
        }
        break;

      /// Квадратный дюйм
      case 5:
        switch (_dropdownIndexOutput) {

          /// Квадратный километр
          case 0:
            _formula = 'Разделите значение "площадь" на 1,55e+9';
            _valueOutput = _valueInput / 1550000000;
            break;

          /// Квадратный метр
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 1550';
            _valueOutput = _valueInput / 1550;
            break;

          /// Квадратная миля
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 4,014e+9';
            _valueOutput = _valueInput / 4014000000;
            break;

          /// Квадратный ярд
          case 3:
            _formula = 'Разделите значение "площадь" на 1296';
            _valueOutput = _valueInput / 1296;
            break;

          /// Квадратный фут
          case 4:
            _formula = 'Разделите значение "площадь" на 144';
            _valueOutput = _valueInput / 144;
            break;

          /// Гектар
          case 6:
            _formula = 'Разделите значение "площадь" на 1,55e+7';
            _valueOutput = _valueInput / 15500000;
            break;

          /// Акр
          case 7:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 6,273e+6';
            _valueOutput = _valueInput / 6273000;
            break;
        }
        break;

      /// Гектар
      case 6:
        switch (_dropdownIndexOutput) {

          /// Квадратный километр
          case 0:
            _formula = 'Разделите значение "площадь" на 100';
            _valueOutput = _valueInput / 100;
            break;

          /// Квадратный метр
          case 1:
            _formula = 'Умножьте значение "площадь" на 10000';
            _valueOutput = _valueInput * 10000;
            break;

          /// Квадратная миля
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 259';
            _valueOutput = _valueInput / 259;
            break;

          /// Квадратный ярд
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 11960';
            _valueOutput = _valueInput * 11960;
            break;

          /// Квадратный фут
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 107639';
            _valueOutput = _valueInput * 107639;
            break;

          /// Квадратный дюйм
          case 5:
            _formula = 'Умножьте значение "площадь" на 1,55e+7';
            _valueOutput = _valueInput * 15500000;
            break;

          /// Акр
          case 7:
            _formula = 'Умножьте значение "площадь" на 2,471';
            _valueOutput = _valueInput * 2.471;
            break;
        }
        break;

      /// Акр
      case 7:
        switch (_dropdownIndexOutput) {

          /// Квадратный километр
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "площадь" на 247';
            _valueOutput = _valueInput / 247;
            break;

          /// Квадратный метр
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 4047';
            _valueOutput = _valueInput * 4047;
            break;

          /// Квадратная миля
          case 2:
            _formula = 'Разделите значение "площадь" на 640';
            _valueOutput = _valueInput / 640;
            break;

          /// Квадратный ярд
          case 3:
            _formula = 'Умножьте значение "площадь" на 4840';
            _valueOutput = _valueInput * 4840;
            break;

          /// Квадратный фут
          case 4:
            _formula = 'Умножьте значение "площадь" на 43560';
            _valueOutput = _valueInput * 43560;
            break;

          /// Квадратный дюйм
          case 5:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "площадь" на 6,273e+6';
            _valueOutput = _valueInput * 6273000;
            break;

          /// Гектар
          case 6:
            _formula = 'Разделите значение "площадь" на 2,471';
            _valueOutput = _valueInput / 2.471;
            break;
        }
        break;
    }
  }

  void _countCorner() {
    switch (_dropdownIndexInput) {

      /// Град
      case 0:
        switch (_dropdownIndexOutput) {

          /// Градус
          case 1:
            _valueOutput = _valueInput * 180 / 200;
            _formula = '$_valueInput град × 180/200 = $_valueOutput°';
            break;

          /// Минута дуги
          case 2:
            _formula = 'Умножьте значение "$_category" на 54';
            _valueOutput = _valueInput * 54;
            break;

          /// Радиан
          case 3:
            _valueOutput = _valueInput * math.pi / 200;
            _formula = '$_valueInput град × π/200 = $_valueOutput рад';
            break;

          /// Тысячная
          case 4:
            _valueOutput = _valueInput * 1000 * math.pi / 200;
            _formula = '$_valueInput град × 1000π/200 = 15,708 мрад';
            break;

          /// Угловая секунда
          case 5:
            _formula = 'Умножьте значение "$_category" на 3240';
            _valueOutput = _valueInput * 3240;
            break;
        }
        break;

      /// Градус
      case 1:
        switch (_dropdownIndexOutput) {

          /// Град
          case 0:
            _valueOutput = _valueInput * 200 / 180;
            _formula = '$_valueInput° × 200/180 = $_valueOutput град';
            break;

          /// Минута дуги
          case 2:
            _formula = 'Умножьте значение "$_category" на 60';
            _valueOutput = _valueInput * 60;
            break;

          /// Радиан
          case 3:
            _valueOutput = _valueInput * math.pi / 180;
            _formula = '$_valueInput° × π/180 = $_valueOutput рад';
            break;

          /// Тысячная
          case 4:
            _valueOutput = _valueInput * 1000 * math.pi / 180;
            _formula = '$_valueInput° × 1000π/180 = $_valueOutput мрад';
            break;

          /// Угловая секунда
          case 5:
            _formula = 'Умножьте значение "$_category" на 3600';
            _valueOutput = _valueInput * 3600;
            break;
        }
        break;

      /// Минута дуги
      case 2:
        switch (_dropdownIndexOutput) {

          /// Град
          case 0:
            _formula = 'Разделите значение "$_category" на 54';
            _valueOutput = _valueInput / 54;
            break;

          /// Градус
          case 1:
            _formula = 'Разделите значение "$_category" на 60';
            _valueOutput = _valueInput / 60;
            break;

          /// Радиан
          case 3:
            _valueOutput = _valueInput * math.pi / (60 * 180);
            _formula = '$_valueInput′ × π/(60 × 180) = $_valueOutput рад';
            break;

          /// Тысячная
          case 4:
            _valueOutput = _valueInput * 1000 * math.pi / (60 * 180);
            _formula = '$_valueInput′ × 1000π/(60 × 180) = $_valueOutput мрад';
            break;

          /// Угловая секунда
          case 5:
            _formula = 'Умножьте значение "$_category" на 60';
            _valueOutput = _valueInput * 60;
            break;
        }
        break;

      /// Радиан
      case 3:
        switch (_dropdownIndexOutput) {

          /// Град
          case 0:
            _valueOutput = _valueInput * 200 / math.pi;
            _formula = '$_valueInput рад × 200/π = $_valueOutput град';
            break;

          /// Градус
          case 1:
            _valueOutput = _valueInput * 180 / math.pi;
            _formula = '$_valueInput рад × 180/π = $_valueOutput°';
            break;

          /// Минута дуги
          case 2:
            _valueOutput = _valueInput * (60 * 180) / math.pi;
            _formula = '$_valueInput рад × (60 × 180)/π = $_valueOutput′';
            break;

          /// Тысячная
          case 4:
            _formula = 'Умножьте значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Угловая секунда
          case 5:
            _valueOutput = _valueInput * (3600 * 180) / math.pi;
            _formula = '$_valueInput рад × (3600 × 180)/π = $_valueOutput″';
            break;
        }
        break;

      /// Тысячная
      case 4:
        switch (_dropdownIndexOutput) {

          /// Град
          case 0:
            _valueOutput = _valueInput * 200 / 10000 * math.pi;
            _formula = '$_valueInput мрад × 200/10000π = $_valueOutput град';
            break;

          /// Градус
          case 1:
            _valueOutput = _valueInput * 180 / 1000 * math.pi;
            _formula = '$_valueInput мрад × 180/1000π = $_valueOutput°';
            break;

          /// Минута дуги
          case 2:
            _valueOutput = _valueInput * (60 * 180) / 1000 * math.pi;
            _formula = '$_valueInput мрад × (60 × 180)/1000π = $_valueOutput′';
            break;

          /// Радиан
          case 3:
            _formula = 'Разделите значение "$_category" на 1000';
            _valueOutput = _valueInput * 1000;
            break;

          /// Угловая секунда
          case 5:
            _valueOutput = _valueInput * (3600 * 180) / 1000 * math.pi;
            _formula =
                '$_valueInput мрад × (3600 × 180)/1000π = $_valueOutput″';
            break;
        }
        break;

      /// Угловая секунда
      case 5:
        switch (_dropdownIndexOutput) {

          /// Град
          case 0:
            _formula = 'Разделите значение "$_category" на 3240';
            _valueOutput = _valueInput / 3240;
            break;

          /// Градус
          case 1:
            _formula = 'Разделите значение "$_category" на 3600';
            _valueOutput = _valueInput / 3600;
            break;

          /// Минута дуги
          case 2:
            _formula = 'Разделите значение "$_category" на 60';
            _valueOutput = _valueInput / 60;
            break;

          /// Радиан
          case 3:
            _valueOutput = _valueInput * math.pi / (180 * 3600);
            _formula = '$_valueInput″ × π/(180 × 3600) = $_valueOutput рад';
            break;

          /// Тысячная
          case 4:
            _valueOutput = _valueInput * 1000 * math.pi / (180 * 3600);
            _formula =
                '$_valueInput″ × 1000π/(180 × 3600) = $_valueOutput мрад';
            break;
        }
        break;
    }
  }

  void _counterFuel() {
    switch (_dropdownIndexInput) {

      /// Миля на галлон США
      case 0:
        switch (_dropdownIndexOutput) {

          /// Miles per gallon (Imperial)
          case 1:
            _formula = 'Умножьте значение "$_category" на 1,201';
            _valueOutput = _valueInput * 1.201;
            break;

          /// Километр на литр
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 2,352';
            _valueOutput = _valueInput / 2.352;
            break;

          /// Литр на 100 километров
          case 3:
            _valueOutput = 235.215 / _valueInput;
            _formula =
                '235,215/($_valueInput мил/галлон США) = $_valueOutput л/100 км';
            break;
        }
        break;

      /// Miles per gallon (Imperial)
      case 1:
        switch (_dropdownIndexOutput) {

          /// Миля на галлон США
          case 0:
            _formula = 'Разделите значение "$_category" на 1,201';
            _valueOutput = _valueInput / 1.201;
            break;

          /// Километр на литр
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "$_category" на 2,825';
            _valueOutput = _valueInput / 2.825;
            break;

          /// Литр на 100 километров
          case 3:
            _valueOutput = 282.481 / _valueInput;
            _formula =
                '282,481/($_valueInput мил/галлон) = $_valueOutput л/100 км';
            break;
        }
        break;

      /// Километр на литр
      case 2:
        switch (_dropdownIndexOutput) {

          /// Миля на галлон США
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 2,352';
            _valueOutput = _valueInput * 2.352;
            break;

          /// Miles per gallon (Imperial)
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "$_category" на 2,825';
            _valueOutput = _valueInput * 2.825;
            break;

          /// Литр на 100 километров
          case 3:
            _valueOutput = 100 / _valueInput;
            _formula = '100/($_valueInput км/л) = $_valueOutput л/100 км';
            break;
        }
        break;

      /// Литр на 100 километров
      case 3:
        switch (_dropdownIndexOutput) {

          /// Миля на галлон США
          case 0:
            _valueOutput = 235.215 / _valueInput;
            _formula =
                '235,215/($_valueInput л/100 км) = $_valueOutput мил/галлон США';
            break;

          /// Miles per gallon (Imperial)
          case 1:
            _valueOutput = 282.481 / _valueInput;
            _formula =
                '282,481/($_valueInput л/100 км) = $_valueOutput мил/галлон';
            break;

          /// Километр на литр
          case 2:
            _valueOutput = 100 / _valueInput;
            _formula = '100/($_valueInput л/100 км) = $_valueOutput км/л';
            break;
        }
        break;
    }
  }

  void _counterSpeed() {
    switch (_dropdownIndexInput) {

      /// Миля в час
      case 0:
        switch (_dropdownIndexOutput) {

          /// Фут в секунду
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "скорость" на 1,467';
            _valueOutput = _valueInput * 1.467;
            break;

          /// Метр в секунду
          case 2:
            _formula = 'Разделите значение "скорость" на 2,237';
            _valueOutput = _valueInput / 2.237;
            break;

          /// Километр в час
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "скорость" на 1,609';
            _valueOutput = _valueInput * 1.609;
            break;

          /// Узел
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "скорость" на 1,151';
            _valueOutput = _valueInput / 1.151;
            break;
        }
        break;

      /// Фут в секунду
      case 1:
        switch (_dropdownIndexOutput) {

          /// Миля в час
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "скорость" на 1,467';
            _valueOutput = _valueInput / 1.467;
            break;

          /// Метр в секунду
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "скорость" на 3,281';
            _valueOutput = _valueInput / 3.281;
            break;

          /// Километр в час
          case 3:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "скорость" на 1,097';
            _valueOutput = _valueInput * 1.097;
            break;

          /// Узел
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "скорость" на 1,688';
            _valueOutput = _valueInput / 1.688;
            break;
        }
        break;

      /// Метр в секунду
      case 2:
        switch (_dropdownIndexOutput) {

          /// Миля в час
          case 0:
            _formula = 'Умножьте значение "скорость" на 2,237';
            _valueOutput = _valueInput * 2.237;
            break;

          /// Фут в секунду
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "скорость" на 3,281';
            _valueOutput = _valueInput * 3.281;
            break;

          /// Километр в час
          case 3:
            _formula = 'Умножьте значение "скорость" на 3,6';
            _valueOutput = _valueInput * 3.6;
            break;

          /// Узел
          case 4:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "скорость" на 1,944';
            _valueOutput = _valueInput * 1.944;
            break;
        }
        break;

      /// Километр в час
      case 3:
        switch (_dropdownIndexOutput) {

          /// Миля в час
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "скорость" на 1,609';
            _valueOutput = _valueInput / 1.609;
            break;

          /// Фут в секунду
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "скорость" на 1,097';
            _valueOutput = _valueInput / 1.097;
            break;

          /// Метр в секунду
          case 2:
            _formula = 'Разделите значение "скорость" на 3,6';
            _valueOutput = _valueInput / 3.6;
            break;

          /// Узел
          case 4:
            _formula = 'Разделите значение "скорость" на 1,852';
            _valueOutput = _valueInput / 1.852;
            break;
        }
        break;

      /// Узел
      case 4:
        switch (_dropdownIndexOutput) {

          /// Миля в час
          case 0:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "скорость" на 1,151';
            _valueOutput = _valueInput * 1.151;
            break;

          /// Фут в секунду
          case 1:
            _formula =
                'Чтобы получить приблизительный результат, умножьте значение "скорость" на 1,688';
            _valueOutput = _valueInput * 1.688;
            break;

          /// Метр в секунду
          case 2:
            _formula =
                'Чтобы получить приблизительный результат, разделите значение "скорость" на 1,944';
            _valueOutput = _valueInput / 1.944;
            break;

          /// Километр в час
          case 3:
            _formula = 'Умножьте значение "скорость" на 1,852';
            _valueOutput = _valueInput * 1.852;
            break;
        }
        break;
    }
  }

  void _counterTemperature() {
    switch (_dropdownIndexInput) {

      /// Градус Цельсия
      case 0:
        switch (_dropdownIndexOutput) {

          /// Градус Фаренгейта
          case 1:
            _valueOutput = (_valueInput * 9 / 5) + 32;
            _formula = '($_valueInput °C × 9/5) + 32 = $_valueOutput °F';
            break;

          /// Кельвин
          case 2:
            _valueOutput = _valueInput + 273.15;
            _formula = '$_valueInput °C + 273,15 = $_valueOutput K';
            break;
        }
        break;

      /// Градус Фаренгейта
      case 1:
        switch (_dropdownIndexOutput) {

          /// Градус Цельсия
          case 0:
            _valueOutput = (_valueInput - 32) * 5 / 9;
            _formula = '($_valueInput °F − 32) × 5/9 = $_valueOutput °C';
            break;

          /// Кельвин
          case 2:
            _valueOutput = (_valueInput - 32) * 5 / 9 + 273.15;
            _formula =
                '($_valueInput °F − 32) × 5/9 + 273,15 = $_valueOutput K';
            break;
        }
        break;

      /// Кельвин
      case 2:
        switch (_dropdownIndexOutput) {

          /// Градус Цельсия
          case 0:
            _valueOutput = _valueInput - 273.15;
            _formula = '$_valueInput K − 273,15 = $_valueOutput °C';
            break;

          /// Градус Фаренгейта
          case 1:
            _valueOutput = (_valueInput - 273.15) * 9 / 5 + 32;
            _formula =
                '($_valueInput K − 273,15) × 9/5 + 32 = $_valueOutput °F';
            break;
        }
        break;
    }
  }
}
