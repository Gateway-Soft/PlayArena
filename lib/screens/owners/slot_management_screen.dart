import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/owners/slot_model.dart';
import '../../services/owners/slot_service.dart';

class SlotManagementScreen extends StatefulWidget {
  const SlotManagementScreen({Key? key, required String turfId}) : super(key: key);

  @override
  State<SlotManagementScreen> createState() => _SlotManagementScreenState();
}

class _SlotManagementScreenState extends State<SlotManagementScreen> {
  List<SlotModel> _slots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSlots();
  }

  Future<void> _fetchSlots() async {
    final service = SlotService();
    final fetchedSlots = await service.getAllBookedSlots();
    setState(() {
      _slots = fetchedSlots;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slot Management'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _slots.isEmpty
          ? const Center(child: Text('No booked slots available.'))
          : ListView.builder(
        itemCount: _slots.length,
        itemBuilder: (context, index) {
          final slot = _slots[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.event_available),
              title: Text(slot.turfName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time: ${slot.timeSlot}'),
                  Text('Date: ${DateFormat('dd MMM yyyy').format(slot.date)}'),
                  Text('Booked by: ${slot.userId}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
