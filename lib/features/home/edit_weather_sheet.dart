import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;
import '../../database/app_database.dart';
import '../../providers/network_reachability_notifier.dart';
import '../../services/weather_service.dart';
import '../../util/log.dart';

class EditWeatherSheet extends StatefulWidget {
  final WeatherSnapshotData? currentWeather;

  const EditWeatherSheet({super.key, this.currentWeather});

  @override
  State<EditWeatherSheet> createState() => _EditWeatherSheetState();
}

class _EditWeatherSheetState extends State<EditWeatherSheet> {
  final _formKey = GlobalKey<FormState>();
  final _regionController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _conditionController = TextEditingController();
  final _zipCodeController = TextEditingController();
  bool _isLoading = false;
  bool _isFetching = false;
  String? _selectedCondition;

  final List<String> _conditionOptions = [
    'Clear',
    'Sunny',
    'Cloudy',
    'Partly Cloudy',
    'Rainy',
    'Stormy',
    'Snowy',
    'Foggy',
    'Windy',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.currentWeather != null) {
      _regionController.text = widget.currentWeather!.region;
      _temperatureController.text =
          widget.currentWeather!.temperature.toString();
      final condition = widget.currentWeather!.condition;
      _conditionController.text = condition;
      // Set dropdown value to closest match or first option
      _selectedCondition = _conditionOptions.contains(condition)
          ? condition
          : _conditionOptions.first;
    } else {
      _regionController.text = 'North Region';
      _temperatureController.text = '72';
      _conditionController.text = 'Clear';
      _selectedCondition = 'Clear';
    }
  }

  @override
  void dispose() {
    _regionController.dispose();
    _temperatureController.dispose();
    _conditionController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  /// Normalize condition text to match dropdown options
  String _normalizeCondition(String condition) {
    final normalized = condition.trim();

    // Direct match
    if (_conditionOptions.contains(normalized)) {
      return normalized;
    }

    // Case-insensitive match
    for (final option in _conditionOptions) {
      if (option.toLowerCase() == normalized.toLowerCase()) {
        return option;
      }
    }

    // Partial match (e.g., "Partly Cloudy" matches "Partly Cloudy")
    for (final option in _conditionOptions) {
      if (normalized.toLowerCase().contains(option.toLowerCase()) ||
          option.toLowerCase().contains(normalized.toLowerCase())) {
        return option;
      }
    }

    // Default fallback
    return _conditionOptions.first;
  }

  Future<void> _fetchWeatherFromApi() async {
    final zipCode = _zipCodeController.text.trim();
    if (zipCode.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter a zip code'),
              backgroundColor: Colors.red),
        );
      }
      return;
    }

    // Validate zip code format (5 digits)
    if (!RegExp(r'^\d{5}$').hasMatch(zipCode)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter a valid 5-digit zip code'),
              backgroundColor: Colors.red),
        );
      }
      return;
    }

    if (!mounted) return;

    if (!context.read<NetworkReachabilityNotifier>().isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You are offline. Connect to the internet to fetch live weather from the API.',
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() {
      _isFetching = true;
    });

    try {
      final weatherData = await WeatherService.fetchWeatherByZip(zipCode);

      if (!mounted) return;

      if (weatherData != null) {
        final normalizedCondition = _normalizeCondition(weatherData.condition);

        setState(() {
          _regionController.text = weatherData.region;
          _temperatureController.text = weatherData.temperature.toString();
          // Store the actual condition from API in controller
          _conditionController.text = weatherData.condition;
          // Set dropdown to normalized/matched condition
          _selectedCondition = normalizedCondition;
          _isFetching = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Weather fetched successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _isFetching = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Could not fetch weather. Please check your internet connection and try again.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching weather: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      // Log the full error for debugging
      Log.error('Weather fetch error: $e');
      Log.error('Stack trace: $stackTrace');
    }
  }

  Future<void> _saveWeather() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (!mounted) return;

      final db = context.read<AppDatabase>();

      // Validate and extract all fields
      final region = _regionController.text.trim();
      final conditionText = _conditionController.text.trim();
      final tempStr = _temperatureController.text.trim();

      // Validate region
      if (region.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Region cannot be empty'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Validate condition - prioritize dropdown value (user's selection)
      // Ensure _selectedCondition is never null by using fallback chain
      String condition;
      if (_selectedCondition != null && _selectedCondition!.isNotEmpty) {
        condition = _selectedCondition!;
      } else if (conditionText.isNotEmpty) {
        condition = conditionText;
      } else {
        // Final fallback - should never happen if form validation passed
        condition = _conditionOptions.first;
      }

      // Double-check condition is not empty (safety check)
      if (condition.isEmpty) {
        condition = _conditionOptions.first;
      }

      // Validate temperature
      final temp = int.tryParse(tempStr);
      if (temp == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid temperature'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // All validations passed - insert weather data
      await db.insertWeather(
        WeatherSnapshotCompanion.insert(
          region: region,
          temperature: temp,
          condition: condition,
          fetchedAt: DateTime.now(),
          source: 'manual',
          zipCode: Value(_zipCodeController.text.trim().isNotEmpty
              ? _zipCodeController.text.trim()
              : widget.currentWeather?.zipCode),
        ),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Weather updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating weather: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      // Log full error for debugging
      Log.error('Weather save error: $e');
      Log.error('Stack trace: $stackTrace');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.orange, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Update Weather',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(color: theme.dividerColor, height: 1),
              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Fetch from API Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  theme.colorScheme.primary.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.cloud_download,
                                    color: theme.colorScheme.primary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Fetch from API',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _zipCodeController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Zip Code',
                                      filled: true,
                                      fillColor: theme.colorScheme.surface,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: theme.dividerColor),
                                      ),
                                      hintText: '78245',
                                      hintStyle: TextStyle(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.7)),
                                    ),
                                    style: TextStyle(
                                        color: theme.colorScheme.onSurface),
                                    maxLength: 5,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed:
                                      _isFetching ? null : _fetchWeatherFromApi,
                                  icon: _isFetching
                                      ? SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                theme.colorScheme.onSurface),
                                          ),
                                        )
                                      : const Icon(Icons.search),
                                  label: Text(
                                      _isFetching ? 'Fetching...' : 'Fetch'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enter a 5-digit US zip code to fetch current weather',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Divider(color: theme.dividerColor),
                      const SizedBox(height: 24),
                      Text(
                        'Or Enter Manually',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Region
                      Text(
                        'Region',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _regionController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'North Region',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a region';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Temperature
                      Text(
                        'Temperature (°F)',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _temperatureController,
                        keyboardType:
                            const TextInputType.numberWithOptions(signed: true),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: '72',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter temperature';
                          }
                          final temp = int.tryParse(value);
                          if (temp == null) {
                            return 'Invalid temperature';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Condition
                      Text(
                        'Condition',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCondition,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                        ),
                        dropdownColor: theme.colorScheme.surface,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        items: _conditionOptions.map((condition) {
                          return DropdownMenuItem(
                            value: condition,
                            child: Text(condition),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCondition = value;
                              _conditionController.text = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a condition';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveWeather,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.onSurface),
                                  ),
                                )
                              : Text(
                                  'Update Weather',
                                  style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
