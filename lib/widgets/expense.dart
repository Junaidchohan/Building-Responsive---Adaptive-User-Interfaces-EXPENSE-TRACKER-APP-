import 'package:flutter/material.dart';
import 'package:responsive_and_adaptive_ui/model/expense.dart';
import 'package:responsive_and_adaptive_ui/widgets/expenses_list/chart/chart.dart';
import 'package:responsive_and_adaptive_ui/widgets/expenses_list/expenses_list.dart';
import 'package:responsive_and_adaptive_ui/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerExpense = [
    Expense(
        amount: 19.55,
        date: DateTime.now(),
        title: "Flutter course",
        category: Category.work),
    Expense(
        amount: 19.55,
        date: DateTime.now(),
        title: "Cenima",
        category: Category.leisure),
    Expense(
        amount: 19.55,
        date: DateTime.now(),
        title: "Resturant",
        category: Category.food),
    Expense(
        amount: 19.55,
        date: DateTime.now(),
        title: "SkyWays",
        category: Category.traval),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerExpense.indexOf(expense);
    setState(() {
      _registerExpense.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expenses deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registerExpense.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expense found. Start adding some!'),
    );

    if (_registerExpense.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registerExpense,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense App"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registerExpense),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registerExpense)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
