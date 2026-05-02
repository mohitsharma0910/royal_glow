import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/service_model.dart';
import '../providers/booking_provider.dart';

class BookingScreen extends StatefulWidget {
  final Service service;
  const BookingScreen({super.key, required this.service});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  final List<String> _timeSlots = [
    '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM',
    '06:00 PM', '07:00 PM', '08:00 PM'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CONFIRM BOOKING')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildServiceDetails(),
              const SizedBox(height: 24),
              const Text('SELECT DATE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber, letterSpacing: 1)),
              const SizedBox(height: 12),
              _buildDatePicker(),
              const SizedBox(height: 24),
              const Text('SELECT TIME SLOT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber, letterSpacing: 1)),
              const SizedBox(height: 12),
              _buildTimeSlotsGrid(),
              const SizedBox(height: 32),
              _buildTotalSection(),
              const SizedBox(height: 24),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.spa, color: Colors.black, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.service.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${widget.service.durationMinutes} Minutes Session', style: const TextStyle(color: Colors.amber, fontSize: 12)),
              ],
            ),
          ),
          Text('₹${widget.service.price.toInt()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _selectedDate != null ? Colors.amber : Colors.white10),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month, color: _selectedDate != null ? Colors.amber : Colors.white54),
            const SizedBox(width: 12),
            Text(
              _selectedDate == null ? 'Choose a date' : DateFormat('EEEE, MMMM d').format(_selectedDate!),
              style: TextStyle(color: _selectedDate != null ? Colors.white : Colors.white54, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _timeSlots.length,
      itemBuilder: (context, index) {
        final slot = _timeSlots[index];
        final isSelected = _selectedTimeSlot == slot;
        return InkWell(
          onTap: () => setState(() => _selectedTimeSlot = slot),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? Colors.amber : Colors.white10),
            ),
            alignment: Alignment.center,
            child: Text(
              slot,
              style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text('₹${widget.service.price.toInt()}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    final isValid = _selectedDate != null && _selectedTimeSlot != null;
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isValid ? _handleBooking : null,
        child: const Text('CONFIRM APPOINTMENT', style: TextStyle(letterSpacing: 1.5)),
      ),
    );
  }

  void _handleBooking() async {
    // Parse time slot
    final timeFormat = DateFormat.jm();
    final time = timeFormat.parse(_selectedTimeSlot!);
    
    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      time.hour,
      time.minute,
    );

    await context.read<BookingProvider>().createBooking(
      service: widget.service,
      dateTime: dateTime,
    );

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('BOOKING SUCCESS!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.amber)),
              const SizedBox(height: 8),
              Text('Your glow up is scheduled for ${DateFormat('MMM d').format(_selectedDate!)} at $_selectedTimeSlot', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Text('+10 Loyalty Points Earned!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to Home
              },
              child: const Text('GREAT!', style: TextStyle(color: Colors.amber)),
            )
          ],
        ),
      );
    }
  }
}
