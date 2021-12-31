// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'dart:io';

import 'package:flutter/cupertino.dart'; // for cupertino widgets
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // after adding the intl dependency in pubspec.yaml
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  // this line is used to ensure SystemChrome works
  // WidgetsFlutterBinding.ensureInitialized();
  // // running the device in potrait mode only
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      // theme is used for setting a global app-wide theme
      theme: ThemeData(
        // primary swatch is the base color whose different shades are used in the app
        primarySwatch: Colors.purple,
        // generally a contrasting color is accent color
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        errorColor: Colors.red,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// with keyword is used to add a mix in
// mix in is a class whose some properties can be used but is not completely inherited
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 18.53,
    //   date: DateTime.now(),
    // )
  ];

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    // where is used here as an alternative for for loop
    // it returns an iterable with selected items from the original list
    // it iterates over all the elements of the list and takes a bool function as an argument
    // which returns true to select the current list item
    // and false if we don't want it
    return _userTransactions.where((tx) {
      // true if date of tx is within the previous week
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
      // convert the selected elements into a list
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
          // tapping on the new transaction modal sheet doesn't work because onTap: () {}
          // so the tap then is taken as a tap on the bottom sheet
          // to prevent that the behaviour of the modal sheet is made opaque
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          // adaptive is used so that the switch looks different according to the OS
          // in iOS a Cupertino widget is used
          // in Android a MaterialDesign Widget is used
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            // val is the value chosen by the user
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              // MediaQuery gives you device information
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget,
    ];
  }

  List<Widget> _buildPotraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        // MediaQuery gives you device information
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    // saving the value of MediaQuery so that we can increase the performance of the app
    final mediaQuery = MediaQuery.of(context);

    // isLandscape is recalculated every time build method is run
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    Widget _buildCupertinoAppBar() {
      return CupertinoNavigationBar(
        middle: Text(
          'Personal Expenses',
          style: TextStyle(
            fontFamily: 'OpenSans',
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () => _startAddNewTransaction(context),
            ),
          ],
        ),
      );
    }

    Widget _buildMaterialAppBar() {
      return AppBar(
        title: Text(
          'Personal Expenses',
          style: TextStyle(
            fontFamily: 'OpenSans',
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add),
          ),
        ],
      );
    }

    // PreferredSizeWidget is used to explicily tell dart that appBar has a preferredSize property
    final PreferredSizeWidget appBar =
        Platform.isIOS ? _buildCupertinoAppBar() : _buildMaterialAppBar();

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              // padding is there for the status bar at top and other things
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // we cannot use {} for if statements inside a List
            if (isLandscape)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
            if (!isLandscape)
              ..._buildPotraitContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
