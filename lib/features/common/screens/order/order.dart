import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/common/widgets/screen_template.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/auth_service.dart';
import 'package:flutter_tubes_galon/utils/constants/sizes.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/order_service.dart';

class Order {
  final String id;
  final String brandImage;
  final String brandName;
  final String shippingStatus;
  final String address;
  final String phoneNumber;
  final String name;

  Order({
    required this.id,
    required this.brandImage,
    required this.brandName,
    required this.shippingStatus,
    required this.address,
    required this.phoneNumber,
    required this.name,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      brandImage: map['brandImage'],
      brandName: map['nama_barang'],
      shippingStatus: map['status'],
      address: map['alamat'],
      phoneNumber: map['no_wa'],
      name: map['nama_lengkap'],
    );
  }
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> orders = [];
  List<Order> history = [];
  final OrderService orderService = OrderService();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final id = await AuthService().getUserId();
      if (id != null) {
        List<Map<String, dynamic>> orderMaps = await orderService.getOrders();
        setState(() {
          orders = orderMaps.map((orderMap) => Order.fromMap(orderMap)).toList();
        });
        print("Orders fetched: ${orders.length}"); 
      } else {
        print("User is not logged in or user ID is null");
      }
    } catch (e) {
      print('Failed to load orders: $e');
    }
  }

  Future<void> markAsCompleted(Order order) async {
    try {
      await orderService.updateOrderStatus(order.id);
      setState(() {
        orders.remove(order);
        history.add(order);
      });
    } catch (e) {
      print('Failed to update order status: $e');
    }
  }

  void showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(order.brandName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${order.address}'),
            Text('${order.phoneNumber}'),
            Text('${order.name}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await markAsCompleted(order);
              Navigator.of(context).pop();
            },
            child: Text('Selesai', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      title: 'Pesanan',
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: orders.isEmpty
            ? Center(
                child: Text('Belum ada pesanan'),
              )
            : Expanded(
                child: Container( 
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(order.brandImage),
                          ),
                          title: Text('${order.brandName} - ${order.address}'),
                          subtitle: Text(order.shippingStatus),
                          onTap: () => showOrderDetails(order),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
