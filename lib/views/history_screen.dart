import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/booking_provider.dart';
import '../models/booking_model.dart';

const _bg = Color(0xFF160700);
const _card = Color(0xFF2A1406);
const _gold = Color(0xFFD4A843);

class HistoryScreen extends StatelessWidget {
  /// When [embedded] is true the widget renders only the body (no Scaffold/AppBar),
  /// so it can live inside HomeScreen's IndexedStack.
  final bool embedded;
  const HistoryScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final body = _buildBody(context);
    if (embedded) return body;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(
          'MY VISITS',
          style: GoogleFonts.playfairDisplay(
            color: _gold,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: body,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, _) {
        if (provider.bookings.isEmpty) {
          return _buildEmpty();
        }

        // Sort: upcoming first, then past
        final sorted = [...provider.bookings]
          ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          itemCount: sorted.length,
          itemBuilder: (context, index) =>
              _BookingCard(booking: sorted[index]),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 72,
            color: _gold.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No appointments yet',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white38,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book a service to get started',
            style: TextStyle(color: Colors.white24, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Individual booking card
// ─────────────────────────────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final Booking booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final isCancelled = booking.status == 'cancelled';
    final isUpcoming = booking.dateTime.isAfter(DateTime.now());
    final statusColor = isCancelled
        ? Colors.red.shade400
        : isUpcoming
            ? Colors.green.shade400
            : Colors.white38;
    final statusLabel = isCancelled
        ? 'CANCELLED'
        : isUpcoming
            ? 'UPCOMING'
            : 'COMPLETED';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCancelled
              ? Colors.red.withOpacity(0.2)
              : _gold.withOpacity(0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCancelled
                        ? Colors.red.withOpacity(0.1)
                        : _gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isCancelled ? Icons.cancel_outlined : Icons.spa_outlined,
                    color: isCancelled ? Colors.red.shade400 : _gold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    booking.serviceName,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCancelled ? Colors.white54 : Colors.white,
                    ),
                  ),
                ),
                Text(
                  '₹${booking.totalPrice.toInt()}',
                  style: GoogleFonts.playfairDisplay(
                    color: isCancelled ? Colors.white38 : _gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: isCancelled
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: _gold.withOpacity(0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  DateFormat('EEE, MMM d • hh:mm a').format(booking.dateTime),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                // Cancel button for upcoming, non-cancelled bookings
                if (isUpcoming && !isCancelled)
                  TextButton.icon(
                    onPressed: () => _confirmCancel(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade400,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.cancel_outlined, size: 14),
                    label: const Text(
                      'Cancel',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Cancel Appointment?',
          style: GoogleFonts.playfairDisplay(color: _gold),
        ),
        content: Text(
          'Are you sure you want to cancel "${booking.serviceName}"?',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('KEEP IT'),
          ),
          TextButton(
            onPressed: () {
              context.read<BookingProvider>().cancelBooking(booking.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }
}