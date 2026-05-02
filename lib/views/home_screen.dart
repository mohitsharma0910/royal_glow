import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import '../models/service_model.dart';
import '../models/offer_model.dart';
import '../services/database_service.dart';
import 'booking_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ROYAL GLOW'),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(Icons.star, color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.amber),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.amber),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(context),
            _buildOffersSection(context),
            _buildCategoryFilter(context),
            _buildServicesSection(context),
            _buildReviewsSection(context),
            _buildContactSection(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    final user = DatabaseService().getUser();
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.amber.shade400]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, ${user?.name ?? "Guest"}!', style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('Ready for a glow up?', style: TextStyle(color: Colors.black87, fontSize: 14)),
            ],
          ),
          Column(
            children: [
              const Text('Points', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
              Text('${user?.loyaltyPoints ?? 0}', style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final categories = ['All', 'Hair', 'Skin', 'Wellness'];
    return Consumer<ServiceProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = provider.selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => provider.setCategory(cat),
                  selectedColor: Colors.amber,
                  labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.amber),
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.amber),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOffersSection(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, provider, child) {
        if (provider.offers.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('HOT OFFERS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.amber)),
            ),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.offers.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) => _OfferCard(offer: provider.offers[index]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, provider, child) {
        final services = provider.filteredServices;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('PREMIUM SERVICES', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.amber)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: services.length,
              itemBuilder: (context, index) => _ServiceTile(service: services[index]),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.qr_code_scanner, size: 60, color: Colors.amber),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rate & Win', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                const Text('Scan to leave a review and earn 50 bonus points!', style: TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(visualDensity: VisualDensity.compact),
                  child: const Text('SCAN NOW'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.amber),
              SizedBox(width: 12),
              Text('Narmada Complex, Hosa Road', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => launchUrl(Uri.parse('tel:6360135720')),
            child: const Row(
              children: [
                Icon(Icons.phone, color: Colors.amber),
                SizedBox(width: 12),
                Text('6360135720', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Spacer(),
                Icon(Icons.call, size: 16, color: Colors.white54),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Offer offer;
  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                child: const Text('LIMITED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(offer.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(offer.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.white60)),
              const Spacer(),
              Row(
                children: [
                  Text('₹${offer.originalPrice.toInt()}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.white30)),
                  const SizedBox(width: 8),
                  Text('₹${offer.discountedPrice.toInt()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final Service service;
  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.spa, color: Colors.amber),
        ),
        title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.description, style: const TextStyle(fontSize: 12, color: Colors.white60)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${service.durationMinutes} mins', style: const TextStyle(fontSize: 12, color: Colors.amber)),
              ],
            )
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${service.price.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
          ],
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(service: service))),
      ),
    );
  }
}
