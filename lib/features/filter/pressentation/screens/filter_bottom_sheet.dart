import 'package:event_hub/features/filter/pressentation/screens/widgets/filter_time_chip.dart';
import 'package:event_hub/features/search/presentation/screens/widgets/filter_category_button.dart';
import 'package:event_hub/model/entities/category_model.dart';
import 'package:event_hub/model/network/ticketmaster_service.dart';
import 'package:flutter/material.dart';


class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int _selectedCategory = -1; 
  int _selectedTime = 1;     
  RangeValues _priceRange = const RangeValues(20, 120);

  static const _timeLabels = ['Today', 'Tomorrow', 'This week'];

  List<CategoryModel> _categories = [];
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await TicketmasterService.instance.getCategories();
      if (mounted) {
        setState(() {
          _categories = cats;
          _loadingCategories = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadingCategories = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
          
              const SizedBox(height: 20),
          
              const Text(
                "Filter",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
          
              const SizedBox(height: 20),
              if (_loadingCategories)
                const SizedBox(
                  height: 80,
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF5669FF)),
                  ),
                )
              else if (_categories.isNotEmpty)
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (_, i) => FilterCategoryButton(
                      category: _categories[i],
                      isSelected: _selectedCategory == i,
                      onTap: () => setState(() => _selectedCategory = i),
                    ),
                  ),
                ),
          
              const SizedBox(height: 24),
              const Text(
                "Time & Date",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
          
              const SizedBox(height: 12),
          
              Row(
                children: List.generate(
                  _timeLabels.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FilterTimeChip(
                      label: _timeLabels[i],
                      isSelected: _selectedTime == i,
                      onTap: () => setState(() => _selectedTime = i),
                    ),
                  ),
                ),
              ),
          
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.calendar_today_outlined,
                        size: 18, color: Color(0xFF5669FF)),
                    SizedBox(width: 10),
                    Text(
                      "Choose from calendar",
                      style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    ),
                    Spacer(),
                    Icon(Icons.chevron_right, color: Color(0xFF888888)),
                  ],
                ),
              ),
          
              const SizedBox(height: 24),
              const Text(
                "Location",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
          
              const SizedBox(height: 12),
          
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.location_on_outlined,
                        size: 18, color: Color(0xFF5669FF)),
                    SizedBox(width: 10),
                    Text(
                      "New York, USA",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.chevron_right, color: Color(0xFF888888)),
                  ],
                ),
              ),
          
              const SizedBox(height: 24),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select price range",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  Text(
                    "\$${_priceRange.start.toInt()}-\$${_priceRange.end.toInt()}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5669FF),
                    ),
                  ),
                ],
              ),
          
              const SizedBox(height: 8),
          
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 10000,
                activeColor: const Color(0xFF5669FF),
                inactiveColor: const Color(0xFFEEEEEE),
                onChanged: (v) => setState(() => _priceRange = v),
              ),
          
              const SizedBox(height: 24),
          
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = -1;
                          _selectedTime = 0;
                          _priceRange = const RangeValues(20, 120);
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFDDDDDD)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "RESET",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF555555),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        String? selectedClassificationId;
                        if (_selectedCategory >= 0 && _selectedCategory < _categories.length) {
                          selectedClassificationId = _categories[_selectedCategory].id;
                        }
                        Navigator.pop(context, selectedClassificationId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5669FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: const Text(
                        "APPLY",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}