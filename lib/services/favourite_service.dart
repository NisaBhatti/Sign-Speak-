import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavouriteService {
  static final FavouriteService _instance = FavouriteService._internal();
  factory FavouriteService() => _instance;
  FavouriteService._internal();

  List<Map<String, dynamic>> _favourites = [];

  // Load favourites from SharedPreferences
  Future<void> loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favouritesJson = prefs.getString('favourites');
    if (favouritesJson != null) {
      final List<dynamic> decoded = json.decode(favouritesJson);
      _favourites = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    }
  }

  // Save favourites to SharedPreferences
  Future<void> _saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_favourites);
    await prefs.setString('favourites', encoded);
  }

  // Add to favourites
  Future<void> addFavourite(Map<String, dynamic> sign) async {
    final exists = _favourites.any((item) => item['name'] == sign['name']);
    if (!exists) {
      _favourites.add(sign);
      await _saveFavourites();
    }
  }

  // Remove from favourites
  Future<void> removeFavourite(String signName) async {
    _favourites.removeWhere((item) => item['name'] == signName);
    await _saveFavourites();
  }

  // Check if sign is favourite
  bool isFavourite(String signName) {
    return _favourites.any((item) => item['name'] == signName);
  }

  // Get all favourites
  List<Map<String, dynamic>> get favourites => _favourites;

  // Toggle favourite
  Future<void> toggleFavourite(Map<String, dynamic> sign) async {
    if (isFavourite(sign['name'])) {
      await removeFavourite(sign['name']);
    } else {
      await addFavourite(sign);
    }
  }

  // Clear all favourites
  Future<void> clearAllFavourites() async {
    _favourites.clear();
    await _saveFavourites();
  }
}