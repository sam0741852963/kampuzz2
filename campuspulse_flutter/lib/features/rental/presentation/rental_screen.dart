import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Section 5.8: Campus Rental Marketplace
class RentalScreen extends StatefulWidget {
  const RentalScreen({Key? key}) : super(key: key);

  @override
  State<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  final List<Map<String, dynamic>> _items = [
    {
      'id': 1,
      'title': 'Casio fx-991EX Scientific Calculator',
      'owner': 'Rohan Verma',
      'pricePerDay': '₹20/day',
      'deposit': '₹300',
      'condition': 'Excellent (Like New)',
      'pickup': 'Nilgiri Hostel, Room 214',
      'isAvailable': true,
      'imageUrl': 'https://images.unsplash.com/photo-1587145820266-a5951ee6f620?w=400',
    },
    {
      'id': 2,
      'title': 'Arduino Starter Kit + Sensors & Breadboard',
      'owner': 'Sahab Raza',
      'pricePerDay': '₹40/day',
      'deposit': '₹500',
      'condition': 'Good (All components working)',
      'pickup': 'LHC Central Foyer',
      'isAvailable': true,
      'imageUrl': 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400',
    },
    {
      'id': 3,
      'title': 'Kurose & Ross: Computer Networking (7th Ed)',
      'owner': 'Priya Nair',
      'pricePerDay': '₹15/day',
      'deposit': '₹200',
      'condition': 'Highlighted clean textbook',
      'pickup': 'Central Library Gate 2',
      'isAvailable': true,
      'imageUrl': 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400',
    },
  ];

  void _showRentDialog(Map<String, dynamic> item) {
    bool agreedToConsent = false;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Rent ${item['title']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Rental Rate: ${item['pricePerDay']}'),
              Text('• Refundable Security Deposit: ${item['deposit']}'),
              Text('• Condition: ${item['condition']}'),
              Text('• Pickup Location: ${item['pickup']}'),
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 8),
              // Mandatory Consent Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: agreedToConsent,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setDialogState(() => agreedToConsent = val ?? false);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'I agree to be fully responsible for any damage or loss of the item during the rental period.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                '📸 You will be prompted for handover photos when picking up.',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: !agreedToConsent
                  ? null
                  : () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Rental request submitted to ${item['owner']}! Notification reminder set.'),
                          backgroundColor: AppColors.attendanceSafe,
                        ),
                      );
                    },
              child: const Text('Confirm & Request'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Rental', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'List an item for rent',
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = _items[index];
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    item['imageUrl'],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'],
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                          ),
                          Text(
                            item['pricePerDay'],
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Owner: ${item['owner']} • Deposit: ${item['deposit']}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text(item['pickup'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showRentDialog(item),
                          child: const Text('Request to Rent'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
