import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../models/order_model.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard", style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.orders.isEmpty) {
            return const Center(child: Text("No order requests yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appState.orders.length,
            itemBuilder: (context, index) {
              final order = appState.orders[index];
              final isPending = order.status == OrderStatus.pending;

              return Card(
                margin: const EdgeInsets.only(bottom: 24),
                color: Theme.of(context).colorScheme.surfaceContainer,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ORDER REQUEST #${order.id.substring(order.id.length - 4)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
                          ),
                          _getStatusBadge(order.status),
                        ],
                      ),
                      const Divider(height: 32),
                      _buildInfoRow("Customer", order.customerName),
                      _buildInfoRow("Email", order.email),
                      _buildInfoRow("Phone", order.phone),
                      _buildInfoRow("Address", order.address),
                      _buildInfoRow("Delivery", DateFormat('EEEE, MMM d').format(order.deliveryDate)),
                      const Divider(height: 32),
                      Text(
                        "ITEMS",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text("• ${item.name}", style: const TextStyle(fontSize: 13)),
                      )),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total: €${order.total.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (order.paymentMethod != null)
                            Text("Paid via ${order.paymentMethod}", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (isPending) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => appState.updateOrderStatus(order.id, OrderStatus.rejected),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                                child: const Text("REJECT"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  appState.updateOrderStatus(order.id, OrderStatus.approved);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Order approved! User notified.")),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                                child: const Text("APPROVE"),
                              ),
                            ),
                          ],
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text("$label:", style: const TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _getStatusBadge(OrderStatus status) {
    Color color;
    String label;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        label = "PENDING";
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
