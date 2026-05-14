import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../models/offer_model.dart';
import '../services/database_service.dart';

class ServiceProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<Service> _services = [];
  List<Service> get services => _services;

  List<Offer> _offers = [];
  List<Offer> get offers => _offers;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Service> get filteredServices {
    if (_selectedCategory == 'All') return _services;
    return _services.where((s) => s.category == _selectedCategory).toList();
  }

  Future<void> loadData() async {
    // Always use fresh catalog data so category changes take effect
    _services = _getMockServices();
    await _db.saveServices(_services);
    _offers = _getMockOffers();
    notifyListeners();
  }

  List<Service> _getMockServices() {
    return [
      // ── Standard Spa ──────────────────────────────────────────────
      Service(
        id: 'std1',
        name: 'Swedish Therapy',
        description:
            'Classic therapeutic massage using flowing, rhythmic strokes to ease muscle tension and promote complete relaxation. Perfect for stress relief, this treatment improves circulation, reduces toxins, and leaves you feeling refreshed and rejuvenated.',
        price: 2500,
        iconPath: 'standard',
        category: 'Standard',
        durationMinutes: 60,
      ),
      Service(
        id: 'std2',
        name: 'Thai Therapy',
        description:
            'Traditional Thai healing combining acupressure and assisted yoga postures to release deep muscle tension. This ancient practice works along energy lines to restore natural flow, increase flexibility, and promote holistic wellness.',
        price: 2000,
        iconPath: 'standard',
        category: 'Standard',
        durationMinutes: 60,
      ),
      // ── Cozy Spa ──────────────────────────────────────────────────
      Service(
        id: 'cozy1',
        name: 'Aroma Therapy',
        description:
            'Experience the healing power of aromatherapy with carefully selected essential oils. This therapeutic treatment promotes deep relaxation, relieves stress, and restores balance to mind and body while nourishing your skin and awakening your senses.',
        price: 2500,
        iconPath: 'cozy',
        category: 'Cozy',
        durationMinutes: 60,
      ),
      Service(
        id: 'cozy2',
        name: 'Candle Massage',
        description:
            'A luxurious warm wax massage with aromatic candles that melt stress away. The warm oil deeply nourishes the skin while the gentle heat relaxes every muscle.',
        price: 2800,
        iconPath: 'cozy',
        category: 'Cozy',
        durationMinutes: 75,
      ),
      // ── Premium Spa ───────────────────────────────────────────────
      Service(
        id: 'pre1',
        name: 'Hot Stone Massage',
        description:
            'Deeply therapeutic massage using heated volcanic stones to release tension, improve circulation, and calm the nervous system. The warmth penetrates muscle layers for profound relief.',
        price: 3500,
        iconPath: 'premium',
        category: 'Premium',
        durationMinutes: 75,
      ),
      Service(
        id: 'pre2',
        name: 'Royal Couple Spa',
        description:
            'An exclusive romantic spa journey designed for two. Share a blissful experience of synchronised massages, aromatic baths, and personalised wellness rituals in our private couple\'s suite.',
        price: 6000,
        iconPath: 'premium',
        category: 'Premium',
        durationMinutes: 120,
      ),
      Service(
        id: 'pre3',
        name: 'Deep Tissue Massage',
        description:
            'Targeted therapeutic massage that works deep into muscle layers to break up chronic tension, improve posture, and relieve persistent pain. Ideal for athletes and desk workers.',
        price: 3000,
        iconPath: 'premium',
        category: 'Premium',
        durationMinutes: 60,
      ),
      // ── Hair ──────────────────────────────────────────────────────
      Service(
        id: 'hair1',
        name: 'Premium Haircut',
        description: 'Precision cut with style consultation & wash included',
        price: 500,
        iconPath: 'hair',
        category: 'Hair',
        durationMinutes: 45,
      ),
      Service(
        id: 'hair2',
        name: 'Beard Grooming',
        description: 'Hot towel treatment with precision trim & shaping',
        price: 300,
        iconPath: 'hair',
        category: 'Hair',
        durationMinutes: 30,
      ),
      Service(
        id: 'hair3',
        name: 'Hair Spa Treatment',
        description: 'Deep conditioning treatment with scalp massage & steam',
        price: 800,
        iconPath: 'hair',
        category: 'Hair',
        durationMinutes: 60,
      ),
      // ── Skin ──────────────────────────────────────────────────────
      Service(
        id: 'skin1',
        name: 'Hydra Facial',
        description: 'Advanced skin glow treatment with deep hydration boost',
        price: 1500,
        iconPath: 'skin',
        category: 'Skin',
        durationMinutes: 45,
      ),
      Service(
        id: 'skin2',
        name: 'Gold Facial',
        description: 'Luxurious 24K gold leaf facial for radiant, youthful skin',
        price: 2000,
        iconPath: 'skin',
        category: 'Skin',
        durationMinutes: 60,
      ),
    ];
  }

  List<Offer> _getMockOffers() {
    return [
      Offer(
        id: 'o1',
        title: 'Massage Special',
        description: 'Deep tissue massage at discounted rate — limited time',
        originalPrice: 3000,
        discountedPrice: 1999,
      ),
      Offer(
        id: 'o2',
        title: 'Combo Pack',
        description: 'FREE haircut + beard with any Spa service booked',
        originalPrice: 2800,
        discountedPrice: 2000,
      ),
    ];
  }
}