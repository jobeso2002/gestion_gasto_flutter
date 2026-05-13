import 'package:flutter/material.dart';
import 'package:gestion_gastos/models/transaction.dart';
import 'package:gestion_gastos/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class TransactionFormScreen extends StatefulWidget {
  final Transaction? transaction;
  const TransactionFormScreen({super.key, this.transaction});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'Comida';
  TransactionType _selectedType = TransactionType.expense;

  final List<String> _categories = [
    'Comida',
    'Transporte',
    'Entretenimiento',
    'Otros',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Transaccion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un monto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: const Text('Gasto'),
                      value: TransactionType.expense,
                      groupValue: _selectedType,
                      onChanged: (TransactionType? value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text('Ingreso'),
                      value: TransactionType.income,
                      groupValue: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

                      if(widget.transaction == null){
                        transactionProvider.addTransaction(
                          Transaction(
                            id: DateTime.now().toString(),
                            category: _selectedCategory,
                            amount: double.parse(_amountController.text),
                            type: _selectedType,
                            date: DateTime.now(),
                          )
                        );
                      }else{
                        widget.transaction!.category = _selectedCategory;
                        widget.transaction!.amount = double.parse(_amountController.text);
                        widget.transaction!.type = _selectedType;
                        transactionProvider.notifyListeners();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text(
                          widget.transaction == null ? 
                          'Transacción registrada' : 'Transacción actualizada'
                        )
                        )

                      );
                      Navigator.pop(context);
                    }
                  
                  },
                  child: Text(
                    widget.transaction == null ? 'Guardar Transacción' : 'Actualizar Transacción',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
