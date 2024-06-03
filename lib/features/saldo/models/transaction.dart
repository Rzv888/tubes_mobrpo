class Transaction{
  final int id;
  final String to;
  final int amount;
  final String date;
  final String description;

  Transaction(
    this.id,
    this.to,
    this.amount,
    this.date,
    this.description
  );
}

final List<Transaction> transactions = [
  Transaction(
    1,
    'Paket 1',
    5000,
    'Disc',
    '1.000'
  ),
  Transaction(
    2,
    'Paket 2',
    10000,
    'Disc',
    '1.000'
  ),
  Transaction(
    3,
    'Paket 3',
    15000,
    'Disc',
    '1.000'
  ),
  Transaction(
    4,
    'Paket 4',
    30000,
    'Disc',
    '1.000'
  ),
  Transaction(
    5,
    'Paket 5',
    50000,
    'Disc',
    '1.000'
  ),
  Transaction(
    6,
    'Paket 6',
    100000,
    'Disc',
    '1.000'
  ),

    
];

