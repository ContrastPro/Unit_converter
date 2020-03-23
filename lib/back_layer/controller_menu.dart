import 'package:flutter/material.dart';

class Category {
  String image;
  String title;

  Category({this.image, this.title});
}

class ListItem extends StatelessWidget {
  final int selectedItem;
  final String selectedCategory;
  final ValueChanged<int> onTileIndex;
  final ValueChanged<String> onTileCategory;
  final List<Category> category = [
    Category(image: 'time.png', title: 'Время'),
    Category(image: 'pressure.png', title: 'Давление'),
    Category(image: 'length.png', title: 'Длина'),
    Category(image: 'mass.png', title: 'Масса'),
    Category(image: 'volume.png', title: 'Объём'),
    Category(image: 'digital_storage.png', title: 'Объём информации'),
    Category(image: 'corner.png', title: 'Плоский угол'),
    Category(image: 'area.png', title: 'Площадь'),
    Category(image: 'fuel.png', title: 'Расход топлива'),
    Category(image: 'speed.png', title: 'Скорость'),
    Category(image: 'speed_internet.png', title: 'Скорость Передачи Данных'),
    Category(image: 'temperature.png', title: 'Температура'),
    Category(image: 'frequency.png', title: 'Частота'),
    Category(image: 'energy.png', title: 'Энергия'),
  ];

  ListItem(
      {this.selectedItem,
      this.selectedCategory,
      this.onTileIndex,
      this.onTileCategory});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(bottom: 50),
        itemCount: category.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              onTileIndex(index);
              onTileCategory(category[index].title);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 16.0, 24.0, 16.0),
              child: Row(
                children: <Widget>[
                  Image(
                    height: 40.0,
                    width: 40.0,
                    image: AssetImage('assets/${category[index].image}'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        category[index].title,
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
