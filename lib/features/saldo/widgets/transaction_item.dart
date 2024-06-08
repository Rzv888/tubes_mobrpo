import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:flutter_tubes_galon/utils/constants/colors.dart';
import 'package:flutter_tubes_galon/utils/constants/sizes.dart';
import 'package:flutter_tubes_galon/utils/helpers/helper_functions.dart';
import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  final Transaction transaction;

  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  int _saldo = 0;

  Future<void> refreshDataUser(context) async {
    final user = await UserService().getCurrentUser();
    print(("cek" + user.toString()));
    setState(() {
      _saldo = user['saldo'].toInt();
    });
    print("Saldo saat ini" + _saldo.toString());
  }

  @override
  void initState() {
    super.initState();
    refreshDataUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext ctx) {
            return Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${widget.transaction.to}  (${widget.transaction.amount})",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await UserService()
                            .updateSaldo(widget.transaction.amount);
                        await refreshDataUser(context);
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Top Up Berhasil"),
                              content: Text("Saldo berhasil di top up."),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Top Up"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.light : const Color(0xFF3D538F),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 132, 187, 232),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: 35,
                height: 35,
                child: Center(
                  child: Text(
                    widget.transaction.to
                        .split('')
                        .map((e) => e.substring(0, 1))
                        .toList()
                        .join(),
                    style: TextStyle(
                      color: isDark ? AppColors.light : const Color(0xFF3D538F),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      widget.transaction.to,
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            isDark ? AppColors.light : const Color(0xFF3D538F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Rp. ${widget.transaction.amount}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFA6D6D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
