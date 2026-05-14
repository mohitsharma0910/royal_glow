import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/service_model.dart';
import '../providers/booking_provider.dart';

const _bg = Color(0xFF160700);
const _card = Color(0xFF2A1406);
const _gold = Color(0xFFD4A843);

class BookingScreen extends StatefulWidget {
  final Service service;
  const BookingScreen({super.key, required this.service});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  String? _selectedSlot;

  static const _slots = [
    '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM',
    '06:00 PM', '07:00 PM', '08:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(
          'BOOK SERVICE',
          style: GoogleFonts.playfairDisplay(
            color: _gold,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _gold, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceCard(),
            const SizedBox(height: 24),
            _sectionLabel('SELECT DATE'),
            const SizedBox(height: 10),
            _buildDatePicker(),
            const SizedBox(height: 24),
            _sectionLabel('SELECT TIME SLOT'),
            const SizedBox(height: 10),
            _buildTimeSlots(),
            const SizedBox(height: 28),
            _buildTotal(),
            const SizedBox(height: 20),
            _buildConfirmButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(width: 3, height: 14, color: _gold),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.lato(
            color: _gold,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _gold.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _gold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _gold.withOpacity(0.3)),
            ),
            child: const Icon(Icons.spa, color: _gold, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 13, color: _gold.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.service.durationMinutes ?? 60} min session',
                      style: TextStyle(
                        color: _gold.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '₹${widget.service.price.toInt()}',
            style: GoogleFonts.playfairDisplay(
              color: _gold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: _gold,
                surface: _card,
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedDate != null
                ? _gold.withOpacity(0.5)
                : _gold.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              color: _selectedDate != null ? _gold : Colors.white38,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _selectedDate == null
                  ? 'Choose a date'
                  : DateFormat('EEEE, MMMM d, y').format(_selectedDate!),
              style: TextStyle(
                color: _selectedDate != null ? Colors.white : Colors.white38,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: _selectedDate != null ? _gold : Colors.white24,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _slots.length,
      itemBuilder: (context, index) {
        final slot = _slots[index];
        final isSelected = _selectedSlot == slot;
        return InkWell(
          onTap: () => setState(() => _selectedSlot = slot),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected ? _gold : _card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? _gold : _gold.withOpacity(0.15),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              slot,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotal() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _gold.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _gold.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '+10 loyalty points',
                style: TextStyle(color: Colors.green.shade400, fontSize: 11),
              ),
            ],
          ),
          Text(
            '₹${widget.service.price.toInt()}',
            style: GoogleFonts.playfairDisplay(
              color: _gold,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    final isValid = _selectedDate != null && _selectedSlot != null;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isValid ? _handleBooking : null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: _gold.withOpacity(0.2),
          disabledForegroundColor: Colors.white38,
        ),
        child: const Text(
          'CONFIRM APPOINTMENT',
          style: TextStyle(fontSize: 13, letterSpacing: 2),
        ),
      ),
    );
  }

  void _handleBooking() async {
    // Parse "09:00 AM" / "12:00 PM" directly — locale-safe
    final parts = _selectedSlot!.split(' ');
    final hm = parts[0].split(':');
    int hour = int.parse(hm[0]);
    final minute = int.parse(hm[1]);
    if (parts[1] == 'PM' && hour != 12) hour += 12;
    if (parts[1] == 'AM' && hour == 12) hour = 0;

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      hour,
      minute,
    );

    await context.read<BookingProvider>().createBooking(
          service: widget.service,
          dateTime: dateTime,
        );

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.1),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: const Icon(Icons.check, color: Colors.green, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                'BOOKING CONFIRMED',
                style: GoogleFonts.playfairDisplay(
                  color: _gold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.service.name}\n${DateFormat('MMM d, y').format(_selectedDate!)} at $_selectedSlot',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  '+ 10 Loyalty Points Earned!',
                  style: TextStyle(
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // dialog
                    Navigator.pop(context); // booking screen
                  },
                  child: const Text('GREAT, THANKS!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}