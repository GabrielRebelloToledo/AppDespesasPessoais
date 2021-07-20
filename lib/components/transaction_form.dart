import 'package:flutter/material.dart';
import 'adaptative_date_picker.dart';
import 'adaptative_textfield.dart';
import 'adaptative_button.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate);
  }

  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom:10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: <Widget>[
              AdaptativeTextfield(
                controller: _titleController,
                onSubmitted: (_) => _submitForm(),
                label: 'Título',
                ),    
              AdaptativeTextfield(
                label:'Valor R\$',
                controller: _valueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitForm(),
              ),
              AdaptativeDatePicker(
                selectedDate: _selectedDate,
                onDateChanged: (newDate){
                  setState(() {
                    _selectedDate = newDate;
                  });
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AdaptativeButton(
                    label: 'Nova Transação',
                    onPressed: _submitForm,
                  ),
                  /* RaisedButton(
                    child: Text('Nova Transação'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                    onPressed: _submitForm,
                  ), */
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
