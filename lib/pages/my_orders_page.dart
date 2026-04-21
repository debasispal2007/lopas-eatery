import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../models/order_model.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders", style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.orders.isEmpty) {
            return const Center(child: Text("You haven't placed any orders yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appState.orders.length,
            itemBuilder: (context, index) {
              final order = appState.orders[index];
              final isApproved = order.status == OrderStatus.approved;
              final hasPaid = order.paymentMethod != null;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order #${order.id.substring(order.id.length - 4)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _getStatusBadge(order.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text("Delivery: ${DateFormat('EEEE, MMM d').format(order.deliveryDate)}"),
                      Text("Address: ${order.address}"),
                      const Divider(height: 24),
                      ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text("• ${item.name}"),
                      )),
                      const Divider(height: 24),
                      Text(
                        "Total: €${order.total.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      if (isApproved && !hasPaid) ...[
                        const SizedBox(height: 20),
                        const Text(
                          "Your order is approved! Please select payment:",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        const SizedBox(height: 12),
                        ...["Tikkie", "iDEAL", "Cash"].map((method) => RadioListTile(
                          title: Text(method),
                          value: method,
                          groupValue: _selectedPaymentMethod,
                          onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        )),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _selectedPaymentMethod == null ? null : () {
                              appState.setPaymentMethod(order.id, _selectedPaymentMethod!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Payment successful! See you next week.")),
                              );
                            },
                            child: const Text("COMPLETE PAYMENT"),
                          ),
                        ),
                      ] else if (hasPaid) ...[
                        const SizedBox(height: 12),
                        Text(
                          "Paid via ${order.paymentMethod}",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getStatusBadge(OrderStatus status) {
    Color color;
    String label;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        label = "PENDING APPROVAL";
        break;
      case OrderStatus.approved:
        color = Colors.green;
        label = "APPROVED";
        break;
      case OrderStatus.rejected:
        color = Colors.red;
        label = "REJECTED";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
