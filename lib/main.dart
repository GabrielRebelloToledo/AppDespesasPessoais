import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'dart:math';
import 'dart:io';

import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'components/chart.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ] */
    ); */

    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Opensans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'Opensans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }
  Widget _getIconButton(IconData icon, Function fn){
    return Platform.isIOS ? 
    GestureDetector(onTap: fn, child: Icon(icon),):
    IconButton(
            icon: Icon(icon),
            onPressed: fn,
          );
  }
  @override
  Widget build(BuildContext context) {

  final mediaQuery = MediaQuery.of(context);

  bool isLandscape = mediaQuery.orientation == Orientation.landscape;
  final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
  final iconchart = Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

  final actions = <Widget>[

         if(isLandscape) _getIconButton(
            _showChart ? iconList : iconchart,
             () {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
          _getIconButton(
         Platform.isIOS ? CupertinoIcons.add : Icons.add,
            () => _openTransactionFormModal(context),
          ),
          
        ];

    final PreferredSizeWidget appBar = Platform.isIOS ? 
    CupertinoNavigationBar(
      middle: Text('Depesas Pessoais'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,),
    )
    : AppBar(
        title: Text('Depesas Pessoais',
        style: TextStyle(fontSize: 20 * mediaQuery.textScaleFactor),
        ),
        actions: actions,
      );

    final availableHeigh = mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top;
    final bodypage =  SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /* if (isLandscape )
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Exibir Gráfico'),
                Switch(
                  value: _showChart, 
                  onChanged: (value){
                  setState(() {
                    _showChart = value;
                  });
                },
                ),
              ],
            ), */
            if (_showChart || !isLandscape)      
            Container(
              height: availableHeigh * (isLandscape ? 0.8 : 0.3),
              child: Chart(_recentTransactions)),
              if(!_showChart || !isLandscape)
            Container( 
            height: availableHeigh * (isLandscape ? 1 : 0.7),
            child: TransactionList(_transactions, _removeTransaction)),
          ],
        ),
      )
    );

    return Platform.isIOS
    ? CupertinoPageScaffold(
      navigationBar: appBar,
      child: bodypage
      )

    
    :Scaffold(
      appBar : appBar,
      body: bodypage,
      floatingActionButton: Platform.isIOS        
      ? Container()  
      : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
