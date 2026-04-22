import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../l10n/app_localizations.dart';
import '../services/ai_service.dart';
import '../services/weather_api_service.dart';

class AddPostScreen extends StatefulWidget {
  final String? editPostId;
  final String? editCaption;
  final String? editImageUrl;

  const AddPostScreen({
    super.key,
    this.editPostId,
    this.editCaption,
    this.editImageUrl,
  });

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  String _selectedPostType = 'Others';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedWeatherType;

  final List<String> _postTypes = [
    'Weather & Sea Conditions',
    'Fish Information & Tips',
    'Community & Fisherman Stories',
    'Others',
  ];

  final List<String> _weatherTypes = [
    'Rain',
    'Storm',
    'Thunder',
    'High Wind',
    'Tsunami',
  ];

  String? _selectedPlace;
  List<String> _availablePlaces = [];
  bool _isLoadingPlaces = false;

  final Map<String, List<String>> _districtCoastalCities = {
    'Gampaha': ['Negombo', 'Ja-Ela', 'Wattala'],
    'Colombo': ['Colombo', 'Dehiwala', 'Mount Lavinia', 'Moratuwa', 'Angulana'],
    'Kalutara': ['Panadura', 'Kalutara', 'Beruwala', 'Aluthgama'],
    'Galle': ['Bentota', 'Ambalangoda', 'Hikkaduwa', 'Galle', 'Koggala'],
    'Matara': ['Weligama', 'Mirissa', 'Matara', 'Dondra', 'Dickwella'],
    'Hambantota': ['Tangalle', 'Hambantota', 'Ambalantota'],
    'Puttalam': ['Puttalam', 'Kalpitiya', 'Chilaw', 'Wennappuwa', 'Marawila'],
    'Mannar': ['Mannar', 'Pesalai'],
    'Jaffna': ['Jaffna', 'Point Pedro', 'Kankesanthurai'],
    'Trincomalee': ['Trincomalee', 'Kinniya', 'Mutur'],
    'Batticaloa': ['Vakarai', 'Kalkudah', 'Batticaloa', 'Kattankudy'],
    'Ampara': ['Kalmunai', 'Akkaraipattu', 'Pottuvil', 'Arugam Bay'],
  };

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.editCaption != null) {
      _captionController.text = widget.editCaption!;
    }
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _fetchCurrentLocationCities() async {
    setState(() {
      _isLoadingPlaces = true;
    });

    try {
      final weatherService = WeatherApiService();
      final weather = await weatherService.fetchWeatherForCurrentLocation();
      final city = weather.name;

      String? matchedDistrict;
      for (var entry in _districtCoastalCities.entries) {
        if (entry.value.any((c) => c.toLowerCase() == city.toLowerCase())) {
          matchedDistrict = entry.key;
          break;
        }
      }

      setState(() {
        if (matchedDistrict != null) {
          _availablePlaces = _districtCoastalCities[matchedDistrict]!;
        } else {
          _availablePlaces = _districtCoastalCities.values
              .expand((x) => x)
              .toList();
          _availablePlaces.sort();
        }
        _isLoadingPlaces = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _availablePlaces = _districtCoastalCities.values
              .expand((x) => x)
              .toList();
          _availablePlaces.sort();
          _isLoadingPlaces = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    final l10n = AppLocalizations.of(context)!;

    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseLogInFirst)));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = widget.editImageUrl;
      final postId = widget.editPostId ?? _uuid.v4();

      if (_imageFile != null) {
        final uploadTask = _storage
            .ref()
            .child('post_images')
            .child('$postId.jpg')
            .putFile(_imageFile!);
        final snapshot = await uploadTask.whenComplete(() {});

        int retries = 3;
        while (retries > 0) {
          try {
            imageUrl = await snapshot.ref.getDownloadURL();
            break;
          } catch (e) {
            retries--;
            if (retries == 0) {
              rethrow;
            }
            await Future.delayed(const Duration(seconds: 1));
          }
        }
      } else if (imageUrl == null && _captionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.imageOrCaptionRequired)));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (_selectedPostType == 'Weather & Sea Conditions') {
        if (_selectedDate == null ||
            _selectedTime == null ||
            _selectedPlace == null ||
            _selectedWeatherType == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.pleaseFillAllRequiredFields)),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        setState(() {
          _isLoading = true;
        });

        final aiMock = AIService();
        final verificationResult = await aiMock.verifyPostAccuracy(
          place: _selectedPlace!,
          date: _selectedDate!,
          time: _selectedTime!,
          weatherType: _selectedWeatherType!,
          caption: _captionController.text.trim(),
        );

        if (verificationResult['isAccurate'] == false) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Post Verification Failed'),
                content: Text(
                  verificationResult['reason'] ?? 'False information detected.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            setState(() {
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (widget.editPostId != null) {
        final updateData = <String, dynamic>{
          'caption': _captionController.text.trim(),
          'postType': _selectedPostType,
        };
        if (_imageFile != null) {
          updateData['imageUrl'] = imageUrl as String;
        }
        if (_selectedPostType == 'Weather & Sea Conditions') {
          updateData['date'] = _selectedDate?.toIso8601String();
          updateData['time'] = _selectedTime != null
              ? '${_selectedTime!.hour}:${_selectedTime!.minute}'
              : null;
          updateData['place'] = _selectedPlace;
          updateData['weatherType'] = _selectedWeatherType;
        }
        await _firestore.collection('posts').doc(postId).update(updateData);
      } else {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        String username = 'Unknown User';
        if (userDoc.exists && userDoc.data() != null) {
          username =
              userDoc.data()!['fullName'] ?? user.displayName ?? 'Unknown User';
        }
        final postData = <String, dynamic>{
          'postId': postId,
          'userId': user.uid,
          'username': username,
          'userProfilePic': user.photoURL,
          'imageUrl': imageUrl,
          'caption': _captionController.text.trim(),
          'postType': _selectedPostType,
          'timestamp': FieldValue.serverTimestamp(),
          'likes': [],
        };
        if (_selectedPostType == 'Weather & Sea Conditions') {
          postData['date'] = _selectedDate?.toIso8601String();
          postData['time'] = _selectedTime != null
              ? '${_selectedTime!.hour}:${_selectedTime!.minute}'
              : null;
          postData['place'] = _selectedPlace;
          postData['weatherType'] = _selectedWeatherType;
        }
        await _firestore.collection('posts').doc(postId).set(postData);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToPost(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  String _getLocalizedCity(String city, AppLocalizations? l10n) {
    if (l10n == null) return city;
    switch (city) {
      case 'Negombo':
        return l10n.cityNegombo;
      case 'Ja-Ela':
        return l10n.cityJaEla;
      case 'Wattala':
        return l10n.cityWattala;
      case 'Colombo':
        return l10n.cityColombo;
      case 'Dehiwala':
        return l10n.cityDehiwala;
      case 'Mount Lavinia':
        return l10n.cityMountLavinia;
      case 'Moratuwa':
        return l10n.cityMoratuwa;
      case 'Angulana':
        return l10n.cityAngulana;
      case 'Panadura':
        return l10n.cityPanadura;
      case 'Kalutara':
        return l10n.cityKalutara;
      case 'Beruwala':
        return l10n.cityBeruwala;
      case 'Aluthgama':
        return l10n.cityAluthgama;
      case 'Bentota':
        return l10n.cityBentota;
      case 'Ambalangoda':
        return l10n.cityAmbalangoda;
      case 'Hikkaduwa':
        return l10n.cityHikkaduwa;
      case 'Galle':
        return l10n.cityGalle;
      case 'Koggala':
        return l10n.cityKoggala;
      case 'Weligama':
        return l10n.cityWeligama;
      case 'Mirissa':
        return l10n.cityMirissa;
      case 'Matara':
        return l10n.cityMatara;
      case 'Dondra':
        return l10n.cityDondra;
      case 'Dickwella':
        return l10n.cityDickwella;
      case 'Tangalle':
        return l10n.cityTangalle;
      case 'Hambantota':
        return l10n.cityHambantota;
      case 'Ambalantota':
        return l10n.cityAmbalantota;
      case 'Puttalam':
        return l10n.cityPuttalam;
      case 'Kalpitiya':
        return l10n.cityKalpitiya;
      case 'Chilaw':
        return l10n.cityChilaw;
      case 'Wennappuwa':
        return l10n.cityWennappuwa;
      case 'Marawila':
        return l10n.cityMarawila;
      case 'Mannar':
        return l10n.cityMannar;
      case 'Pesalai':
        return l10n.cityPesalai;
      case 'Jaffna':
        return l10n.cityJaffna;
      case 'Point Pedro':
        return l10n.cityPointPedro;
      case 'Kankesanthurai':
        return l10n.cityKankesanthurai;
      case 'Trincomalee':
        return l10n.cityTrincomalee;
      case 'Kinniya':
        return l10n.cityKinniya;
      case 'Mutur':
        return l10n.cityMutur;
      case 'Vakarai':
        return l10n.cityVakarai;
      case 'Kalkudah':
        return l10n.cityKalkudah;
      case 'Batticaloa':
        return l10n.cityBatticaloa;
      case 'Kattankudy':
        return l10n.cityKattankudy;
      case 'Kalmunai':
        return l10n.cityKalmunai;
      case 'Akkaraipattu':
        return l10n.cityAkkaraipattu;
      case 'Pottuvil':
        return l10n.cityPottuvil;
      case 'Arugam Bay':
        return l10n.cityArugamBay;
      case 'Gampaha':
        return l10n.cityGampaha;
      case 'Ampara':
        return l10n.cityAmpara;
      default:
        return city;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editPostId != null ? l10n.editPost : l10n.addPost),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _uploadPost,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    widget.editPostId != null ? l10n.update : l10n.post,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_imageFile != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _imageFile!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _imageFile = null;
                      });
                    },
                  ),
                ],
              )
            else if (widget.editImageUrl != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.editImageUrl!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 30),
                    onPressed: _pickImage,
                  ),
                ],
              )
            else
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.selectImage,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedPostType,
              decoration: InputDecoration(
                labelText: l10n.postType,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _postTypes.map((type) {
                String display = type;
                if (type == 'Weather & Sea Conditions')
                  display = l10n.weatherAndSeaConditions;
                else if (type == 'Fish Information & Tips')
                  display = l10n.fishInformationAndTips;
                else if (type == 'Community & Fisherman Stories')
                  display = l10n.communityAndFishermanStories;
                else if (type == 'Others')
                  display = l10n.others;
                return DropdownMenuItem(value: type, child: Text(display));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPostType = value;
                    if (_selectedPostType == 'Weather & Sea Conditions' &&
                        _availablePlaces.isEmpty) {
                      _fetchCurrentLocationCities();
                    }
                  });
                }
              },
            ),
            if (_selectedPostType == 'Weather & Sea Conditions') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() => _selectedDate = date);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.date,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                              : l10n.selectDate,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(
                                context,
                              ).copyWith(alwaysUse24HourFormat: false),
                              child: Localizations.override(
                                context: context,
                                locale: const Locale('en', 'US'),
                                child: child!,
                              ),
                            );
                          },
                        );
                        if (time != null) {
                          setState(() => _selectedTime = time);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.time,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _selectedTime != null
                              ? '${_selectedTime!.hourOfPeriod == 0 ? 12 : _selectedTime!.hourOfPeriod}:${_selectedTime!.minute.toString().padLeft(2, '0')} ${_selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}'
                              : l10n.selectTime,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isLoadingPlaces)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  value: _selectedPlace,
                  decoration: InputDecoration(
                    labelText: l10n.place,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _availablePlaces.map((place) {
                    return DropdownMenuItem(
                      value: place,
                      child: Text(_getLocalizedCity(place, l10n)),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedPlace = value),
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedWeatherType,
                decoration: InputDecoration(
                  labelText: l10n.weatherType,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _weatherTypes.map((wType) {
                  String display = wType;
                  if (wType == 'Rain')
                    display = l10n.rain;
                  else if (wType == 'Storm')
                    display = l10n.storm;
                  else if (wType == 'Thunder')
                    display = l10n.thunder;
                  else if (wType == 'High Wind')
                    display = l10n.highWind;
                  else if (wType == 'Tsunami')
                    display = l10n.tsunami;
                  return DropdownMenuItem(value: wType, child: Text(display));
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedWeatherType = value),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _captionController,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                hintText: l10n.writeCaption,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _imageFile = null;
                              _captionController.clear();
                              _selectedPostType = 'Others';
                              _selectedDate = DateTime.now();
                              _selectedTime = TimeOfDay.now();
                              _selectedWeatherType = null;
                              _selectedPlace = null;
                            });
                          },
                    icon: const Icon(Icons.clear),
                    label: Text(l10n.clearBtn),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _uploadPost,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload),
                    label: Text(
                      widget.editPostId != null
                          ? l10n.updatePostBtn
                          : l10n.uploadPostBtn,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
