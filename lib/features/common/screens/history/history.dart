import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/common/widgets/screen_template.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/history_service.dart';

class GalonPurchase {
  final List<Galon> gallons;

  GalonPurchase({
    required this.gallons,
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

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<GalonPurchase>> _futurePurchases;

  @override
  void initState() {
    super.initState();
    _futurePurchases = _fetchPurchases();
  }

  Future<List<GalonPurchase>> _fetchPurchases() async {
    final historyService = HistoryService();
    final historyData = await historyService.getHistory();

    List<GalonPurchase> purchases = [];

    for (var item in historyData) {
      Galon galon = Galon(
        brand: item['nama_barang'],
        jumlahGalon: item['jumlah_barang'],
        price: item['harga_barang'],
      );

      purchases.add(GalonPurchase(gallons: [galon]));
    }

    return purchases;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      title: "Riwayat",
      child: FutureBuilder<List<GalonPurchase>>(
        future: _futurePurchases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No purchase history available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final purchase = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    _showPurchaseDetailsDialog(context, purchase);
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (var gallon in purchase.gallons)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${gallon.brand} (${gallon.jumlahGalon}) ',
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
                          subtitle: Align(
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
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
