import '../models/transaction.dart';
import 'package:flutter/material.dart';
import '../widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  const TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No Transactions Added Yet!!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  // SizedBox is just like Container but it may not have any child
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover),
                  ),
                ],
              );
            },
          )
        : ListView(
            // ListView.builder() renders only those widgets which appear on the screen
            // (this is called "lazily rendering widgets")
            // this increases the efficiency of the app for long lists
            // whereas ListView(children: ...) renders all the widgets in the list at once
            // which decreases the efficiency of the app for long lists
            children: transactions
                .map(
                  (tx) => TransactionItem(
                    // we needed to set key to prevent flutter to pick a wrong element
                    // in the element tree on rebuild
                    // key: UniqueKey(), // not used because it is updated whenever build() is called
                    // for the parent class
                    key: ValueKey(tx.id),
                    transaction: tx,
                    deleteTx: deleteTx,
                  ),
                )
                .toList(),
          );
  }
}
