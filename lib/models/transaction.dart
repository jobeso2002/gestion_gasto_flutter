enum TransactionType { income, expense }

class Transaction {
  String id;
  String category;
  double amount;
  TransactionType type;
  DateTime date;

  // ✅ CORRECCIÓN: Se agrega description que estaba en el formulario pero no en el modelo
  String? description;

  Transaction({
    required this.id,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
    this.description, // opcional para no romper código existente
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'date': date.toIso8601String(),
      // ✅ CORRECCIÓN: description incluida en el mapa para SQLite
      'description': description,
    };
  }
}