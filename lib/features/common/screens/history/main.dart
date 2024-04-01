import 'package:flutter/material.dart';

class GalonPurchase {
  final String storeLocation;
  final List<Galon> gallons;
  final DateTime purchaseDate;

  GalonPurchase({
    required this.storeLocation,
    required this.gallons,
    required this.purchaseDate,
  });
}

class Galon {
  final String brand;
  final int jumlahGalon;
  final double price;

  Galon({
    required this.brand,
    required this.jumlahGalon,
    required this.price,
  });
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Galon Purchase History',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: GalonPurchaseHistoryPage(),
//     );
//   }
// }

class GalonPurchaseHistoryPage extends StatefulWidget {
  @override
  _GalonPurchaseHistoryPageState createState() =>
      _GalonPurchaseHistoryPageState();
}

class _GalonPurchaseHistoryPageState extends State<GalonPurchaseHistoryPage> {
  List<GalonPurchase> _purchases = [
    GalonPurchase(
      storeLocation: 'Kurnia Air',
      gallons: [
        Galon(brand: 'Aqua 20 Liter', jumlahGalon: 2, price: 22.000),
        Galon(brand: 'Le Minerale 15 Liter', jumlahGalon: 1, price: 17.000),
      ],
      purchaseDate: DateTime(2024, 3, 28, 10, 30),
    ),
    GalonPurchase(
      storeLocation: 'Air Mulia',
      gallons: [
        Galon(brand: 'Aqua 20 Liter', jumlahGalon: 1, price: 22.000),
        Galon(brand: 'Le Minerale 15 Liter', jumlahGalon: 2, price: 17.000),
      ],
      purchaseDate: DateTime(2024, 3, 26, 9, 15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    _purchases.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pembelian'),
      ),
      body: ListView.builder(
        itemCount: _purchases.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showPurchaseDetailsDialog(context, _purchases[index]);
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_purchases[index].storeLocation}'),
                        Text(
                          'Rp${_calculateTotalPrice(_purchases[index]).toStringAsFixed(3)}',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${_purchases[index].purchaseDate.day.toString().padLeft(2, '0')}-${_purchases[index].purchaseDate.month.toString().padLeft(2, '0')}-${_purchases[index].purchaseDate.year}',
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${_purchases[index].purchaseDate.hour.toString().padLeft(2, '0')}:${_purchases[index].purchaseDate.minute.toString().padLeft(2, '0')}',
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Beli Lagi',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPurchaseDetailsDialog(
      BuildContext context, GalonPurchase purchase) {
    if (purchase.gallons.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Detail Pembelian'),
            content: Text(
                'Total Price: Rp${_calculateTotalPrice(purchase).toStringAsFixed(3)}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Detail Pembelian'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var gallon in purchase.gallons)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${gallon.brand} (${gallon.jumlahGalon}) ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text:
                                'Rp${(gallon.jumlahGalon * gallon.price).toStringAsFixed(3)}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  double _calculateTotalPrice(GalonPurchase purchase) {
    double totalPrice = 0;
    for (var gallon in purchase.gallons) {
      totalPrice += gallon.price * gallon.jumlahGalon;
    }
    return totalPrice;
  }
}
