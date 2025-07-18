import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Slot {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Slot({
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}

class SlotManagementScreen extends StatefulWidget {
  const SlotManagementScreen({super.key});

  @override
  State<SlotManagementScreen> createState() => _SlotManagementScreenState();
}

class _SlotManagementScreenState extends State<SlotManagementScreen> {
  final List<Slot> _slots = [];

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormatter = DateFormat('hh:mm a');

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _addSlot() {
    if (_selectedDate != null && _startTime != null && _endTime != null) {
      final slot = Slot(
        date: _selectedDate!,
        startTime: _startTime!,
        endTime: _endTime!,
      );
      setState(() {
        _slots.add(slot);
        _selectedDate = null;
        _startTime = null;
        _endTime = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all slot fields')),
      );
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return _timeFormatter.format(dt);
  }

  void _removeSlot(int index) {
    setState(() {
      _slots.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slot Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add Slot Fields
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickDate,
                    child: Text(
                      _selectedDate == null
                          ? 'Pick Date'
                          : _dateFormatter.format(_selectedDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickTime(isStart: true),
                    child: Text(
                      _startTime == null
                          ? 'Start Time'
                          : _formatTimeOfDay(_startTime!),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickTime(isStart: false),
                    child: Text(
                      _endTime == null
                          ? 'End Time'
                          : _formatTimeOfDay(_endTime!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addSlot,
              icon: const Icon(Icons.add),
              label: const Text('Add Slot'),
            ),
            const SizedBox(height: 20),

            // Slots List
            Expanded(
              child: _slots.isEmpty
                  ? const Center(child: Text('No slots added yet'))
                  : ListView.builder(
                itemCount: _slots.length,
                itemBuilder: (context, index) {
                  final slot = _slots[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(
                          '${_dateFormatter.format(slot.date)} | ${_formatTimeOfDay(slot.startTime)} - ${_formatTimeOfDay(slot.endTime)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeSlot(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}