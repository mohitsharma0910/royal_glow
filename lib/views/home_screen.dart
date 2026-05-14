import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/service_provider.dart';
import '../models/service_model.dart';
import '../models/offer_model.dart';
import '../services/database_service.dart';
import 'booking_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

// ── Brand palette ────────────────────────────────────────────────────
const _bg = Color(0xFF160700);
const _card = Color(0xFF2A1406);
const _gold = Color(0xFFD4A843);

// ─────────────────────────────────────────────────────────────────────
// HomeScreen shell – manages bottom navigation
// ─────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  static const _appBarTitles = ['ROYAL GLOW', 'MY VISITS', 'PROFILE'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _tab,
        children: const [
          _ServicesTab(),
          HistoryScreen(embedded: true),
          ProfileScreen(embedded: true),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0E0300),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _gold, width: 1.5),
          ),
          child: Center(
            child: Text(
              'R',
              style: GoogleFonts.playfairDisplay(
                color: _gold,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        _appBarTitles[_tab],
        style: GoogleFonts.playfairDisplay(
          color: _gold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
        ),
      ),
      actions: [
        if (_tab == 0) const _LoyaltyBadge(),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E0300),
        border: Border(top: BorderSide(color: _gold.withOpacity(0.15))),
      ),
      child: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        backgroundColor: Colors.transparent,
        selectedItemColor: _gold,
        unselectedItemColor: Colors.white30,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.spa_outlined),
            activeIcon: Icon(Icons.spa),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'My Visits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Loyalty points badge in AppBar
// ─────────────────────────────────────────────────────────────────────
class _LoyaltyBadge extends StatelessWidget {
  const _LoyaltyBadge();

  @override
  Widget build(BuildContext context) {
    final user = DatabaseService().getUser();
    final pts = user?.loyaltyPoints ?? 0;
    if (pts == 0) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(right: 4, top: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _gold.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: _gold, size: 13),
          const SizedBox(width: 4),
          Text(
            '$pts pts',
            style: const TextStyle(
              color: _gold,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Corner decoration – golden L-shaped bracket
// ─────────────────────────────────────────────────────────────────────
class _Corner extends StatelessWidget {
  final bool flipH;
  final bool flipV;
  const _Corner({this.flipH = false, this.flipV = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: Stack(
        children: [
          Positioned(
            top: flipV ? null : 0,
            bottom: flipV ? 0 : null,
            left: flipH ? null : 0,
            right: flipH ? 0 : null,
            child: Container(height: 2, width: 18, color: _gold),
          ),
          Positioned(
            top: flipV ? null : 0,
            bottom: flipV ? 0 : null,
            left: flipH ? null : 0,
            right: flipH ? 0 : null,
            child: Container(height: 18, width: 2, color: _gold),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Spa image placeholder – warm gradient with icon
// ─────────────────────────────────────────────────────────────────────
class _SpaImage extends StatelessWidget {
  final IconData icon;
  final double height;
  final List<Color> gradient;

  const _SpaImage({
    required this.icon,
    required this.height,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -15,
              left: -15,
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
            Center(
              child: Icon(icon, color: Colors.white.withOpacity(0.35), size: 32),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Main services scrollable content
// ─────────────────────────────────────────────────────────────────────
class _ServicesTab extends StatelessWidget {
  const _ServicesTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, provider, _) {
        final standard =
            provider.services.where((s) => s.category == 'Standard').toList();
        final cozy =
            provider.services.where((s) => s.category == 'Cozy').toList();
        final premium =
            provider.services.where((s) => s.category == 'Premium').toList();
        final hairSkin = provider.services
            .where((s) => s.category == 'Hair' || s.category == 'Skin')
            .toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeroBanner(),
              _buildUserGreeting(),
              _buildOffersBar(context, provider.offers),
              if (standard.isNotEmpty)
                _buildSpaSection(
                  context: context,
                  topLabel: 'STANDARD',
                  scriptLabel: 'Spa Service',
                  services: standard,
                  gradient: [const Color(0xFF8B4513), const Color(0xFF4A2008)],
                  imageIcon: Icons.self_improvement,
                  imageLeft: false,
                ),
              if (cozy.isNotEmpty)
                _buildSpaSection(
                  context: context,
                  topLabel: 'OUR COZY',
                  scriptLabel: 'Spa Service',
                  services: cozy,
                  gradient: [const Color(0xFF7A3C10), const Color(0xFF3E1A05)],
                  imageIcon: Icons.local_fire_department_outlined,
                  imageLeft: true,
                ),
              if (premium.isNotEmpty)
                _buildSpaSection(
                  context: context,
                  topLabel: 'PREMIUM',
                  scriptLabel: 'Spa Service',
                  services: premium,
                  gradient: [const Color(0xFF6B3A1F), const Color(0xFF301505)],
                  imageIcon: Icons.diamond_outlined,
                  imageLeft: false,
                ),
              if (hairSkin.isNotEmpty) _buildHairSkinSection(context, hairSkin),
              _buildRateSection(),
              _buildContactSection(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // ── Hero banner ───────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _gold.withOpacity(0.35)),
      ),
      child: Column(
        children: [
          // Logo + brand text
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _gold, width: 2),
                    color: _gold.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      'R',
                      style: GoogleFonts.playfairDisplay(
                        color: _gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ROYAL GLOW',
                        style: GoogleFonts.playfairDisplay(
                          color: _gold,
                          fontSize: 11,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'SALON & SPA',
                        style: GoogleFonts.playfairDisplay(
                          color: _gold,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Massage',
                            style: GoogleFonts.dancingScript(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'STYLE • RELAX • REPEAT',
                            style: TextStyle(
                              color: _gold.withOpacity(0.55),
                              fontSize: 7,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Contact chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _gold.withOpacity(0.05),
              border: Border.symmetric(
                horizontal: BorderSide(color: _gold.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                _contactChip(Icons.phone_outlined, '63601 35720'),
                const SizedBox(width: 10),
                Expanded(
                  child: _contactChip(
                    Icons.location_on_outlined,
                    '1st Flr, Narmada Complex, Hosa Rd, BLR',
                  ),
                ),
              ],
            ),
          ),
          // Spa image preview row
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: _SpaImage(
                    icon: Icons.self_improvement,
                    height: 85,
                    gradient: [
                      const Color(0xFF7A4020),
                      const Color(0xFF3E1A08),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _SpaImage(
                    icon: Icons.spa,
                    height: 85,
                    gradient: [
                      const Color(0xFF6A3520),
                      const Color(0xFF301408),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _SpaImage(
                    icon: Icons.water_drop_outlined,
                    height: 85,
                    gradient: [
                      const Color(0xFF5C2D18),
                      const Color(0xFF280E05),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _gold, size: 11),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 9,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ── User greeting ─────────────────────────────────────────────────
  Widget _buildUserGreeting() {
    final user = DatabaseService().getUser();
    if (user == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_gold.withOpacity(0.14), _gold.withOpacity(0.04)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _gold.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.waving_hand_rounded, color: _gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Welcome back, ${user.name}!',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                '${user.loyaltyPoints ?? 0}',
                style: GoogleFonts.playfairDisplay(
                  color: _gold,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'POINTS',
                style: TextStyle(
                  color: _gold.withOpacity(0.65),
                  fontSize: 8,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Offers bar ────────────────────────────────────────────────────
  Widget _buildOffersBar(BuildContext context, List<Offer> offers) {
    if (offers.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
          child: Row(
            children: [
              Container(width: 3, height: 16, color: _gold),
              const SizedBox(width: 8),
              Text(
                'HOT OFFERS',
                style: GoogleFonts.lato(
                  color: _gold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 138,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: offers.length,
            itemBuilder: (_, i) => _OfferCard(offer: offers[i]),
          ),
        ),
      ],
    );
  }

  // ── Spa section (Standard / Cozy / Premium) ───────────────────────
  Widget _buildSpaSection({
    required BuildContext context,
    required String topLabel,
    required String scriptLabel,
    required List<Service> services,
    required List<Color> gradient,
    required IconData imageIcon,
    required bool imageLeft,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _gold.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          // Section header (title + image side by side)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: imageLeft
                  ? [
                      Expanded(
                        flex: 2,
                        child: _SpaImage(
                          icon: imageIcon,
                          height: 120,
                          gradient: gradient,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: _SectionTitle(
                          topLabel: topLabel,
                          scriptLabel: scriptLabel,
                        ),
                      ),
                    ]
                  : [
                      Expanded(
                        flex: 3,
                        child: _SectionTitle(
                          topLabel: topLabel,
                          scriptLabel: scriptLabel,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _SpaImage(
                          icon: imageIcon,
                          height: 120,
                          gradient: gradient,
                        ),
                      ),
                    ],
            ),
          ),
          // Thin gold divider
          Divider(height: 1, color: _gold.withOpacity(0.15)),
          // Service cards
          ...services
              .map((s) => _SpaServiceCard(service: s))
              .toList(),
        ],
      ),
    );
  }

  // ── Hair & Skin section ───────────────────────────────────────────
  Widget _buildHairSkinSection(BuildContext context, List<Service> services) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3, height: 16, color: _gold),
              const SizedBox(width: 8),
              Text(
                'HAIR & BEAUTY',
                style: GoogleFonts.lato(
                  color: _gold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...services.map((s) => _QuickTile(service: s)).toList(),
        ],
      ),
    );
  }

  // ── Rate & review section ─────────────────────────────────────────
  Widget _buildRateSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _gold.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _gold.withOpacity(0.25)),
            ),
            child: const Icon(Icons.qr_code_2_rounded, color: _gold, size: 44),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate & Win!',
                  style: GoogleFonts.playfairDisplay(
                    color: _gold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Scan to leave a review and\nearn 50 bonus loyalty points',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    child: const Text('SCAN NOW'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Contact section ───────────────────────────────────────────────
  Widget _buildContactSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _gold.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          _ContactRow(
            icon: Icons.location_on_outlined,
            text: '1st Floor, Narmada Complex, Hosa Road, BLR-560100',
          ),
          const SizedBox(height: 12),
          _ContactRow(
            icon: Icons.phone_outlined,
            text: '63601 35720',
            onTap: () => launchUrl(Uri.parse('tel:6360135720')),
          ),
          const SizedBox(height: 12),
          _ContactRow(
            icon: Icons.language_outlined,
            text: 'royalglowsalonspa.in',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Section title with corner decorations
// ─────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String topLabel;
  final String scriptLabel;

  const _SectionTitle({
    required this.topLabel,
    required this.scriptLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          const Positioned(top: 0, left: 0, child: _Corner()),
          const Positioned(bottom: 0, right: 0, child: _Corner(flipH: true, flipV: true)),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  topLabel,
                  style: GoogleFonts.playfairDisplay(
                    color: _gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    height: 1.1,
                  ),
                ),
                Text(
                  'SPA',
                  style: GoogleFonts.playfairDisplay(
                    color: _gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                Text(
                  scriptLabel,
                  style: GoogleFonts.dancingScript(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Offer card
// ─────────────────────────────────────────────────────────────────────
class _OfferCard extends StatelessWidget {
  final Offer offer;
  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _gold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.red.shade900,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'LIMITED',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            offer.title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            offer.description,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.5),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${offer.originalPrice.toInt()}',
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '₹${offer.discountedPrice.toInt()}',
                style: GoogleFonts.playfairDisplay(
                  color: _gold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Spa service card (Standard / Cozy / Premium)
// ─────────────────────────────────────────────────────────────────────
class _SpaServiceCard extends StatelessWidget {
  final Service service;
  const _SpaServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final price2 = (service.durationMinutes ?? 0) >= 60
        ? (service.price * 1.4).round()
        : null;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookingScreen(service: service)),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: _gold.withOpacity(0.1))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.name,
              style: GoogleFonts.dancingScript(
                color: _gold,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              service.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11,
                height: 1.55,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _gold.withOpacity(0.08),
                    border: Border.all(color: _gold.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.spa, color: _gold, size: 13),
                ),
                const SizedBox(width: 8),
                Text(
                  '${service.durationMinutes} min',
                  style: TextStyle(
                    color: _gold.withOpacity(0.65),
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                if (price2 != null)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '₹${service.price.toInt()}',
                          style: GoogleFonts.playfairDisplay(
                            color: _gold,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' / ',
                          style: TextStyle(
                            color: _gold.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text: '₹$price2,-',
                          style: GoogleFonts.playfairDisplay(
                            color: _gold,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    '₹${service.price.toInt()}',
                    style: GoogleFonts.playfairDisplay(
                      color: _gold,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

// ─────────────────────────────────────────────────────────────────────
// Quick service tile (Hair / Skin)
// ─────────────────────────────────────────────────────────────────────
class _QuickTile extends StatelessWidget {
  final Service service;
  const _QuickTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _gold.withOpacity(0.14)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _gold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            service.category == 'Hair'
                ? Icons.content_cut
                : Icons.face_retouching_natural,
            color: _gold,
            size: 20,
          ),
        ),
        title: Text(
          service.name,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.timer_outlined, size: 12, color: _gold.withOpacity(0.65)),
            const SizedBox(width: 4),
            Text(
              '${service.durationMinutes} min',
              style: TextStyle(
                fontSize: 11,
                color: _gold.withOpacity(0.65),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${service.price.toInt()}',
              style: GoogleFonts.playfairDisplay(
                color: _gold,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.2), size: 16),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookingScreen(service: service)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Contact row
// ─────────────────────────────────────────────────────────────────────
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ContactRow({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Row(
        children: [
          Icon(icon, color: _gold, size: 15),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
          if (onTap != null)
            const Icon(Icons.call_outlined, size: 15, color: Colors.white24),
        ],
      ),
    );
  }
}