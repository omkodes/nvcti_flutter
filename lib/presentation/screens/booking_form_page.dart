import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nvcti/presentation/common/theme.dart';

import '../../bloc/bloc/booking_bloc.dart';
import '../../bloc/events/booking_event.dart';
import '../../bloc/states/booking_state.dart';
import '../common/loading_card.dart';

class ResourceBookingForm extends StatefulWidget {
  const ResourceBookingForm({super.key});

  @override
  State<ResourceBookingForm> createState() => _ResourceBookingFormState();
}

class _ResourceBookingFormState extends State<ResourceBookingForm> {
  // Form State Variables
  String _selectedResource = "Equipment";
  final List<String> _resourceOptions = [
    "Equipment",
    "Ideation Room 1",
    "Ideation Room 2",
    "Conference Room",
  ];

  // Controllers
  final TextEditingController _componentNameCtrl = TextEditingController();
  final TextEditingController _fromDateCtrl = TextEditingController();
  final TextEditingController _toDateCtrl = TextEditingController();
  final TextEditingController _fromTimeCtrl = TextEditingController();
  final TextEditingController _toTimeCtrl = TextEditingController();

  @override
  void dispose() {
    _componentNameCtrl.dispose();
    _fromDateCtrl.dispose();
    _toDateCtrl.dispose();
    _fromTimeCtrl.dispose();
    _toTimeCtrl.dispose();
    super.dispose();
  }

  // --- Pickers with Local Theme Overrides ---

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlue, // Header and selected day
              onPrimary: Colors.white,
              onSurface: AppTheme.textDark, // Body text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue, // Action buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlue, // Clock needle and AM/PM toggle
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textDark, // Numbers
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue, // Action buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final dt = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
        controller.text = DateFormat('hh:mm a').format(dt);
      });
    }
  }

  // --- Validation & Submit ---

  void _submitData() {
    final equipmentName = _componentNameCtrl.text.trim();
    final fromDate = _fromDateCtrl.text.trim();
    final toDate = _toDateCtrl.text.trim();
    final fromTime = _fromTimeCtrl.text.trim();
    final toTime = _toTimeCtrl.text.trim();

    if (_selectedResource == "Equipment" && equipmentName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please specify the equipment name")),
      );
      return;
    }
    if (fromDate.isEmpty ||
        toDate.isEmpty ||
        fromTime.isEmpty ||
        toTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    context.read<BookingBloc>().add(
      SubmitBookingEvent(
        resourceType: _selectedResource,
        equipmentName: equipmentName,
        fromDate: fromDate,
        toDate: toDate,
        fromTime: fromTime,
        toTime: toTime,
      ),
    );
  }

  // --- Build UI ---

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSubmitSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is BookingSubmitError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Resource Booking"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => context.canPop() ? context.pop() : context.go('/'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => context.push('/history'),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Resource",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  // 1. Themed Dropdown (Spinner)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkInputFill
                          : Colors.grey.shade50,
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.darkDivider
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedResource,
                        dropdownColor: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.darkInputFill
                            : Colors.white,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppTheme.primaryBlue, //
                        ),
                        items: _resourceOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedResource = newValue!;
                            if (_selectedResource != "Equipment") {
                              _componentNameCtrl.clear();
                            }
                          });
                        },
                      ),
                    ),
                  ),

                  if (_selectedResource == "Equipment") ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _componentNameCtrl,
                      decoration: _inputDecoration(
                        "Component Name",
                        Icons.build_outlined,
                      ),
                    ),
                  ],

                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      "Select Date",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // 3. Date Pickers
                  _buildPickerField(
                    controller: _fromDateCtrl,
                    hint: "Start Date",
                    icon: Icons.calendar_today_outlined,
                    onTap: () => _selectDate(context, _fromDateCtrl),
                  ),
                  const SizedBox(height: 12),
                  _buildPickerField(
                    controller: _toDateCtrl,
                    hint: "End Date",
                    icon: Icons.calendar_today_outlined,
                    onTap: () => _selectDate(context, _toDateCtrl),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      "Select Time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // 4. Time Pickers (Cards)
                  _buildTimeCard(
                    label: "From",
                    controller: _fromTimeCtrl,
                    onTap: () => _selectTime(context, _fromTimeCtrl),
                  ),
                  _buildTimeCard(
                    label: "To",
                    controller: _toTimeCtrl,
                    onTap: () => _selectTime(context, _toTimeCtrl),
                  ),

                  const SizedBox(height: 32),

                  // 5. Themed Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Book Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading Overlay
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return Container(
                    color: Colors.black26,
                    child: const Center(child: LoadingCard()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Helpers ---

  InputDecoration _inputDecoration(String hint, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? AppTheme.darkInputFill : Colors.grey.shade50;
    final borderColor = isDark ? AppTheme.darkDivider : Colors.grey.shade300;
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppTheme.primaryBlue, size: 20),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
      ),
    );
  }

  Widget _buildPickerField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: _inputDecoration(hint, icon),
        ),
      ),
    );
  }

  Widget _buildTimeCard({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool hasTime = controller.text.isNotEmpty;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      color: isDark ? AppTheme.darkInputFill : Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppTheme.darkDivider : Colors.grey.shade300,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(
                Icons.access_time,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              Text(
                hasTime ? controller.text : "--:--",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: hasTime ? FontWeight.bold : FontWeight.normal,
                  color: hasTime
                      ? (isDark ? Colors.white : AppTheme.textDark)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
