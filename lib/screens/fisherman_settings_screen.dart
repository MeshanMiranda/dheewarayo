import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';
class FishermanSettingsScreen extends StatefulWidget {
  const FishermanSettingsScreen({super.key});

  @override
  State<FishermanSettingsScreen> createState() =>
      _FishermanSettingsScreenState();
}

class _FishermanSettingsScreenState extends State<FishermanSettingsScreen> {
  final List<String> _fullDaysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final Set<int> _selectedDayIndices = {};

  final TextEditingController _fishingAreaController = TextEditingController();

  TimeOfDay? _selectedTime;
  String? _selectedBoatType;
  String? _selectedFishingArea;
  List<String> _availablePlaces = [];

  final Map<String, List<String>> _districtCoastalCities = {
    'Gampaha': ['Negombo', 'Ja-Ela', 'Wattala'],
    'Colombo': ['Colombo', 'Dehiwala', 'Mount Lavinia', 'Moratuwa'],
    'Kalutara': ['Panadura', 'Kalutara', 'Beruwala', 'Aluthgama'],
    'Galle': ['Bentota', 'Ambalangoda', 'Hikkaduwa', 'Galle', 'Koggala'],
    'Matara': ['Weligama', 'Mirissa', 'Matara', 'Dondra', 'Dickwella'],
    'Hambantota': ['Tangalle', 'Hambantota', 'Ambalantota'],
    'Puttalam': ['Puttalam', 'Kalpitiya', 'Chilaw', 'Wennappuwa'],
    'Mannar': ['Mannar', 'Pesalai'],
    'Jaffna': ['Jaffna', 'Point Pedro', 'Kankesanthurai'],
    'Trincomalee': ['Trincomalee', 'Kinniya', 'Mutur'],
    'Batticaloa': ['Vakarai', 'Kalkudah', 'Batticaloa', 'Kattankudy'],
    'Ampara': ['Kalmunai', 'Akkaraipattu', 'Pottuvil', 'Arugam Bay'],
  };

  final List<String> _boatTypes = [
    'Traditional Canoe (Oruwa)',
    'FRP Boat (Fiber Reinforced Plastic)',
    'One-day Boat',
    'Multi-day Boat',
    'Trawler',
    'Other',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _fishingAreaController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocationCities() async {
    _availablePlaces = _districtCoastalCities.values.expand((x) => x).toList();
    _availablePlaces = _availablePlaces.toSet().toList(); // Ensure uniqueness
    _availablePlaces.sort();
  }

  Future<void> _loadExistingData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _fetchCurrentLocationCities();

      final docId = user.uid;
      final docSnap = await FirebaseFirestore.instance
          .collection('fisherman_data')
          .doc(docId)
          .get();

      if (docSnap.exists) {
        final data = docSnap.data()!;
        if (data['days'] != null) {
          final savedDays = List<String>.from(data['days']);
          for (var day in savedDays) {
            int idx = _fullDaysOfWeek.indexOf(day);
            if (idx != -1) {
              _selectedDayIndices.add(idx);
            }
          }
        }
        if (data['time_hour'] != null && data['time_minute'] != null) {
          _selectedTime = TimeOfDay(
            hour: (data['time_hour'] as num).toInt(),
            minute: (data['time_minute'] as num).toInt(),
          );
        } else if (data['time'] != null) {
          try {
            final timeStr = data['time'].toString();
            final timeParts = timeStr.split(':');
            if (timeParts.length >= 2) {
              final hourStr = timeParts[0].replaceAll(RegExp(r'[^0-9]'), '');
              final minStr = timeParts[1].replaceAll(RegExp(r'[^0-9]'), '');
              if (hourStr.isNotEmpty && minStr.isNotEmpty) {
                _selectedTime = TimeOfDay(
                  hour: int.parse(hourStr),
                  minute: int.parse(minStr),
                );
              }
            }
          } catch (e) {
            debugPrint("Failed to parse fallback time string: \$e");
          }
        }
        if (data['boat_type'] != null) {
          _selectedBoatType = data['boat_type'];
        }
        if (data['fishing_area'] != null) {
          final savedArea = data['fishing_area'];
          if (!_availablePlaces.contains(savedArea)) {
            _availablePlaces.add(savedArea);
          }
          _selectedFishingArea = savedArea;
          _fishingAreaController.text = savedArea;
        }
      }
    } catch (e) {
      debugPrint("Error loading existing fisherman data: \$e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Localizations.override(
            context: context,
            locale: const Locale('en', 'US'),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveData() async {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.pleaseLogInFirst ?? 'Please log in first.'),
        ),
      );
      return;
    }

    if (_selectedDayIndices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.pleaseSelectAtLeastOneDay ??
                'Please select at least one day.',
          ),
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.pleaseSelectATime ?? 'Please select a time.'),
        ),
      );
      return;
    }

    if (_selectedBoatType == null || _selectedBoatType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.pleaseSelectABoatType ?? 'Please select a boat type.',
          ),
        ),
      );
      return;
    }

    final String typedFishingArea = _fishingAreaController.text.trim();
    if (typedFishingArea.isNotEmpty && _availablePlaces.contains(typedFishingArea)) {
      _selectedFishingArea = typedFishingArea;
    } else {
      _selectedFishingArea = null;
    }

    if (_selectedFishingArea == null || _selectedFishingArea!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.pleaseSelectAFishingArea ?? 'Please select a fishing area.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final selectedDaysFull = _selectedDayIndices
          .map((i) => _fullDaysOfWeek[i])
          .toList();
      String timeString =
          "\${_selectedTime!.hour.toString().padLeft(2, '0')}:\${_selectedTime!.minute.toString().padLeft(2, '0')}";

      await FirebaseFirestore.instance
          .collection('fisherman_data')
          .doc(user.uid)
          .set({
            'user_id': user.uid,
            'days': selectedDaysFull,
            'time': timeString,
            'time_hour': _selectedTime!.hour,
            'time_minute': _selectedTime!.minute,
            'boat_type': _selectedBoatType,
            'fishing_area': _selectedFishingArea,
            'updated_at': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n?.fishermanSettingsSavedSuccessfully ??
                  'Fisherman settings saved successfully!',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save data: \$e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearData() {
    setState(() {
      _selectedDayIndices.clear();
      _selectedTime = null;
      _selectedBoatType = null;
      _selectedFishingArea = null;
      _fishingAreaController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final List<String> localizedDaysOfWeek = [
      l10n?.dayMo ?? 'M',
      l10n?.dayTu ?? 'T',
      l10n?.dayWe ?? 'W',
      l10n?.dayTh ?? 'T',
      l10n?.dayFr ?? 'F',
      l10n?.daySa ?? 'S',
      l10n?.daySu ?? 'S',
    ];

    String getLocalizedBoatType(String type) {
      if (l10n == null) return type;
      switch (type) {
        case 'Traditional Canoe (Oruwa)':
          return l10n.boatTypeTraditional;
        case 'FRP Boat (Fiber Reinforced Plastic)':
          return l10n.boatTypeFrp;
        case 'One-day Boat':
          return l10n.boatTypeOneDay;
        case 'Multi-day Boat':
          return l10n.boatTypeMultiDay;
        case 'Trawler':
          return l10n.boatTypeTrawler;
        case 'Other':
          return l10n.boatTypeOther;
        default:
          return type;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.fishermanSettings ?? 'Fisherman Settings'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.selectFishingDays ?? 'Select Fishing Days',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(localizedDaysOfWeek.length, (
                      index,
                    ) {
                      final isSelected = _selectedDayIndices.contains(index);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedDayIndices.remove(index);
                            } else {
                              _selectedDayIndices.add(index);
                            }
                          });
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          child: Text(
                            localizedDaysOfWeek[index],
                            style: TextStyle(
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n?.selectFishingTime ?? 'Select Fishing Time',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _selectTime(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedTime == null
                                ? (l10n?.tapToSelectTime ??
                                      'Tap to select time')
                                : '${_selectedTime!.hourOfPeriod == 0 ? 12 : _selectedTime!.hourOfPeriod}:${_selectedTime!.minute.toString().padLeft(2, '0')} ${_selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: _selectedTime == null
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n?.selectBoatType ?? 'Select Boat Type',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    hint: Text(
                      l10n?.chooseYourBoatType ?? 'Choose your boat type',
                    ),
                    value: _selectedBoatType,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: theme.colorScheme.primary,
                    ),
                    items: _boatTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(getLocalizedBoatType(type)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBoatType = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n?.selectFishingArea ?? 'Select Fishing Area',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownMenu<String>(
                    controller: _fishingAreaController,
                    initialSelection: _selectedFishingArea,
                    expandedInsets: EdgeInsets.zero,
                    menuHeight: 350, // Limits to roughly 7-8 items, ensuring it fits easily on most screens 
                    hintText: l10n?.chooseYourFishingArea ?? 'Choose your fishing area',
                    enableFilter: true,
                    enableSearch: true,
                    leadingIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.primary,
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    trailingIcon: Icon(
                      Icons.arrow_drop_down,
                      color: theme.colorScheme.primary,
                    ),
                    dropdownMenuEntries: _availablePlaces.map((String place) {
                      return DropdownMenuEntry<String>(
                        value: place,
                        label: place,
                      );
                    }).toList(),
                    onSelected: (String? newValue) {
                      setState(() {
                        _selectedFishingArea = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 48),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _clearData,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(l10n?.clearBtn ?? 'Clear'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveData,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          child: Text(l10n?.saveBtn ?? 'Save'),
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
