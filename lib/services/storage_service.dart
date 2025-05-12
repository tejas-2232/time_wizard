import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetrack/models/time_entry.dart';
import 'package:timetrack/models/user_profile.dart';

class StorageService extends ChangeNotifier {
  static const String _userProfileKey = 'user_profile';
  static const String _timeEntriesKey = 'time_entries';
  
  late SharedPreferences _prefs;
  UserProfile? _userProfile;
  List<TimeEntry> _timeEntries = [];
  
  UserProfile? get userProfile => _userProfile;
  List<TimeEntry> get timeEntries => _timeEntries;
  List<TimeEntry> get completedEntries => 
      _timeEntries.where((entry) => entry.isCompleted).toList();
  
  static Future<StorageService> initialize() async {
    final service = StorageService();
    await service._initialize();
    return service;
  }
  
  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadUserProfile();
    await _loadTimeEntries();
  }
  
  Future<void> _loadUserProfile() async {
    final json = _prefs.getString(_userProfileKey);
    if (json != null) {
      _userProfile = UserProfile.fromJson(jsonDecode(json));
      notifyListeners();
    }
  }
  
  Future<void> _loadTimeEntries() async {
    final json = _prefs.getString(_timeEntriesKey);
    if (json != null) {
      final List<dynamic> entriesJson = jsonDecode(json);
      _timeEntries = entriesJson
          .map((entryJson) => TimeEntry.fromJson(entryJson))
          .toList();
      notifyListeners();
    }
  }
  
  Future<void> saveUserProfile(UserProfile profile) async {
    _userProfile = profile;
    await _prefs.setString(_userProfileKey, jsonEncode(profile.toJson()));
    notifyListeners();
  }
  
  Future<void> saveTimeEntry(TimeEntry entry) async {
    // Check if entry already exists
    final index = _timeEntries.indexWhere((e) => e.id == entry.id);
    
    if (index >= 0) {
      _timeEntries[index] = entry;
    } else {
      _timeEntries.add(entry);
    }
    
    await _saveTimeEntriesToPrefs();
  }
  
  Future<void> deleteTimeEntry(String id) async {
    _timeEntries.removeWhere((entry) => entry.id == id);
    await _saveTimeEntriesToPrefs();
  }
  
  Future<void> _saveTimeEntriesToPrefs() async {
    final entriesJson = _timeEntries.map((entry) => entry.toJson()).toList();
    await _prefs.setString(_timeEntriesKey, jsonEncode(entriesJson));
    notifyListeners();
  }
  
  Future<void> clearAllData() async {
    await _prefs.clear();
    _userProfile = null;
    _timeEntries = [];
    notifyListeners();
  }
}