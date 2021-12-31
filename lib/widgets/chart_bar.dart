import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  // constructor can be made const only when all its arguments are of final type
  // const constructor means that every instance of this class is immutable
  // Since flutter does not change the properties of a widget during a rebuild but
  // replace it with a new instance
  // it is suggested that we create const constructors for every STATELESS widget
  const ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    print('build() ChartBar');
    // LayoutBuilder gives constraints that apply to a widget
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            // FittedBox shrinks the contents inside it if tends to exceed the size limits
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text('\$ ${spendingAmount.toStringAsFixed(0)}'),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              // Stack allows the elements to be placed on top of each other in space
              // not as in column but like floating button on top of the screen
              child: Stack(
                children: <Widget>[
                  // bottom most element of the stack
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      // grey color
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                      heightFactor: spendingPctOfTotal,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label),
              ),
            ),
          ],
        );
      },
    );
  }
}
