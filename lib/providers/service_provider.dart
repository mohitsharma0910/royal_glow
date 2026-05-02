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
    _services = _db.getServices();
    if (_services.isEmpty) {
      _services = _getMockServices();
      await _db.saveServices(_services);
    }
    _offers = _getMockOffers();
    notifyListeners();
  }

  List<Service> _getMockServices() {
    return [
      Service(id: '1', name: 'Premium Haircut', description: 'Style & Wash included', price: 500, iconPath: 'assets/icons/haircut.png', category: 'Hair', durationMinutes: 45),
      Service(id: '2', name: 'Beard Grooming', description: 'Hot towel treatment', price: 300, iconPath: 'assets/icons/beard.png', category: 'Hair', durationMinutes: 30),
      Service(id: '3', name: 'Swedish Massage', description: 'Full body relaxation', price: 2000, iconPath: 'assets/icons/massage.png', category: 'Wellness', durationMinutes: 60),
      Service(id: '4', name: 'Deep Tissue', description: 'Pain relief massage', price: 2500, iconPath: 'assets/icons/massage.png', category: 'Wellness', durationMinutes: 90),
      Service(id: '5', name: 'Hydra Facial', description: 'Skin glow treatment', price: 1500, iconPath: 'assets/icons/facial.png', category: 'Skin', durationMinutes: 45),
      Service(id: '6', name: 'Detox Spa', description: 'Mud wrap & bath', price: 3500, iconPath: 'assets/icons/spa.png', category: 'Wellness', durationMinutes: 120),
    ];
  }

  List<Offer> _getMockOffers() {
    return [
      Offer(
        id: 'o1',
        title: 'Massage Special',
        description: 'Deep tissue massage at discounted rate',
        originalPrice: 2500,
        discountedPrice: 1600,
      ),
      Offer(
        id: 'o2',
        title: 'Combo Pack',
        description: 'FREE haircut + beard with any Spa service',
        originalPrice: 2000,
        discountedPrice: 1500,
      ),
    ];
  }
}
