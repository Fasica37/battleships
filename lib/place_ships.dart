import 'package:battleships/home_page.dart';
import 'package:flutter/material.dart';

class PlaceShips extends StatefulWidget {
  const PlaceShips({super.key});
  static const route = '/place-ships';

  @override
  State<PlaceShips> createState() => _PlaceShipsState();
}

class _PlaceShipsState extends State<PlaceShips> {
  List<List<bool>> isSelected =
      List.generate(5, (_) => List<bool>.filled(5, false));
  int selectedCount = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selectable Grid'),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.02),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      _buildRowIndicator('A', size),
                      _buildRowIndicator('B', size),
                      _buildRowIndicator('C', size),
                      _buildRowIndicator('D', size),
                      _buildRowIndicator('E', size),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildIndicator('1', size),
                            _buildIndicator('2', size),
                            _buildIndicator('3', size),
                            _buildIndicator('4', size),
                            _buildIndicator('5', size),
                          ],
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 0.0,
                            ),
                            itemBuilder: (context, index) {
                              int row = index % 5;
                              int col = index ~/ 5;

                              return GestureDetector(
                                onTap: () {
                                  _selectBox(row, col);
                                },
                                child: Container(
                                  color: isSelected[row][col]
                                      ? Colors.blue
                                      : Colors.white,
                                ),
                              );
                            },
                            itemCount: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (selectedCount < 5) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'You must place five ships',
                      ),
                    ));
                    return;
                  }
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomePage.route, (route) => false);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(String text, Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      alignment: Alignment.center,
      child: Text(text),
    );
  }

  Widget _buildRowIndicator(String text, Size size) {
    return Container(
      padding: EdgeInsets.only(
        left: size.width * 0.05,
        right: size.width * 0.06,
        top: size.height * 0.03,
        bottom: size.height * 0.03,
      ),
      alignment: Alignment.center,
      child: Text(text),
    );
  }

  void _selectBox(int row, int col) {
    setState(() {
      if (isSelected[row][col]) {
        isSelected[row][col] = false;
      } else {
        selectedCount = isSelected
            .expand((row) => row)
            .where((isSelected) => isSelected)
            .length;
        if (selectedCount < 5) {
          isSelected[row][col] = true;
        }
      }
    });
  }
}
