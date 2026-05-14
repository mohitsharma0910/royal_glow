import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../providers/booking_provider.dart';

const _bg = Color(0xFF160700);
const _card = Color(0xFF2A1406);
const _gold = Color(0xFFD4A843);

class ProfileScreen extends StatefulWidget {
  /// When [embedded] is true the widget renders only the body (no Scaffold/AppBar).
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _db = DatabaseService();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final user = _db.getUser();
    if (user != null) {
      _nameCtrl.text = user.name;
      _phoneCtrl.text = user.phone;
      _emailCtrl.text = user.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = _buildBody(context);
    if (widget.embedded) return body;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(
          'PROFILE',
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
    final user = _db.getUser();
    final pts = user?.loyaltyPoints ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          // Avatar + loyalty section
          _buildAvatarCard(pts),
          const SizedBox(height: 16),
          // Stats row
          _buildStatsRow(context),
          const SizedBox(height: 16),
          // Form
          _buildForm(),
          const SizedBox(height: 24),
          // Save button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _saveProfile,
              child: Text(
                _saved ? 'SAVED ✓' : 'SAVE PROFILE',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // About salon card
          _buildAboutCard(),
        ],
      ),
    );
  }

  Widget _buildAvatarCard(int pts) {
    final name = _nameCtrl.text.isNotEmpty ? _nameCtrl.text : 'Guest';
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').map((w) => w[0].toUpperCase()).take(2).join()
        : 'G';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _gold.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_gold.withOpacity(0.6), _gold.withOpacity(0.2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: _gold, width: 2),
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Royal Glow Member',
                  style: TextStyle(
                    color: _gold.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '$pts',
                style: GoogleFonts.playfairDisplay(
                  color: _gold,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: _gold, size: 12),
                  const SizedBox(width: 3),
                  Text(
                    'POINTS',
                    style: TextStyle(
                      color: _gold.withOpacity(0.65),
                      fontSize: 9,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final bookings = context.watch<BookingProvider>().bookings;
    final total = bookings.length;
    final upcoming = bookings
        .where((b) =>
            b.dateTime.isAfter(DateTime.now()) && b.status != 'cancelled')
        .length;
    final spent = bookings
        .where((b) => b.status != 'cancelled')
        .fold<double>(0, (sum, b) => sum + b.totalPrice);

    return Row(
      children: [
        Expanded(child: _StatBox(label: 'TOTAL\nVISITS', value: '$total')),
        const SizedBox(width: 8),
        Expanded(child: _StatBox(label: 'UPCOMING', value: '$upcoming')),
        const SizedBox(width: 8),
        Expanded(
            child: _StatBox(label: 'TOTAL\nSPENT', value: '₹${spent.toInt()}')),
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _gold.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PERSONAL DETAILS',
            style: GoogleFonts.lato(
              color: _gold,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: _nameCtrl,
            label: 'Full Name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _buildField(
            controller: _phoneCtrl,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          _buildField(
            controller: _emailCtrl,
            label: 'Email Address (optional)',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _gold, size: 18),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _gold.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ROYAL GLOW SALON & SPA',
            style: GoogleFonts.playfairDisplay(
              color: _gold,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Style • Relax • Repeat',
            style: GoogleFonts.dancingScript(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: _gold.withOpacity(0.1)),
          const SizedBox(height: 6),
          _infoRow(Icons.location_on_outlined,
              '1st Floor, Narmada Complex, Hosa Road, BLR-560100'),
          const SizedBox(height: 6),
          _infoRow(Icons.phone_outlined, '63601 35720'),
          const SizedBox(height: 6),
          _infoRow(Icons.language_outlined, 'royalglowsalonspa.in'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: _gold, size: 14),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
          ),
        ),
      ],
    );
  }

  void _saveProfile() async {
    final existing = _db.getUser();
    final user = UserProfile(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      loyaltyPoints: existing?.loyaltyPoints ?? 0,
    );
    await _db.saveUser(user);
    if (mounted) {
      setState(() => _saved = true);
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (mounted) setState(() => _saved = false);
        },
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────
// Small stat box
// ─────────────────────────────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _gold.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.playfairDisplay(
              color: _gold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 9,
              letterSpacing: 1,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}