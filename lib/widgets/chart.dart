import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  // list of transactions in the last week only
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions) {
    print('Constructor Chart');
  }

  List<Map<String, Object>> get groupedTransactionValue {
    // List.generate() generates a list with number of elements and a function as arguments
    // here that function returns a map for every index
    return List.generate(7, (index) {
      // substract() substracts the duration(in the argument) from the DateTime chosen
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        // E() gives first 3 letters of the day of the week as a string for weekDay
        // substring(0, 1) converts the string to first letter of the day
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    // fold() changes the list into a certain type which we want
    // fold(startingValue, Function)
    return groupedTransactionValue.fold(0.0, (sum, item) {
      return sum += item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() Chart');
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      // Padding is like container except that it is used only for padding
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValue.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
