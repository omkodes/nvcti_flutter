import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
    "Conference Room"
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

  // --- Pickers ---

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Prevent past bookings
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        // Matches Kotlin format: "$selectedDay/${selectedMonth + 1}/$selectedYear"
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        // Matches Kotlin 12-hour AM/PM format
        final now = DateTime.now();
        final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
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

    // Validations mirroring Kotlin
    if (_selectedResource == "Equipment" && equipmentName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please specify the equipment name")),
      );
      return;
    }
    if (fromDate.isEmpty || toDate.isEmpty || fromTime.isEmpty || toTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Trigger BLoC Event
    context.read<BookingBloc>().add(SubmitBookingEvent(
      resourceType: _selectedResource,
      equipmentName: equipmentName,
      fromDate: fromDate,
      toDate: toDate,
      fromTime: fromTime,
      toTime: toTime,
    ));
  }

  // --- Build UI ---

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSubmitSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          // Optional: Clear form or pop navigation here
        } else if (state is BookingSubmitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Resource", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),

                  // 1. Spinner (Dropdown)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedResource,
                        items: _resourceOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedResource = newValue!;
                            // Logic: Clear component name if not Equipment
                            if (_selectedResource != "Equipment") {
                              _componentNameCtrl.clear();
                            }
                          });
                        },
                      ),
                    ),
                  ),

                  // 2. Equipment Name Input (Conditional Visibility)
                  if (_selectedResource == "Equipment") ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _componentNameCtrl,
                      decoration: InputDecoration(
                        hintText: "Component Name",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                    ),
                  ],

                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text("Select Date", style: TextStyle(fontSize: 16)),
                  ),

                  // 3. Date Pickers
                  _buildPickerField(
                    controller: _fromDateCtrl,
                    hint: "Select a date",
                    icon: Icons.calendar_today,
                    onTap: () => _selectDate(context, _fromDateCtrl),
                  ),
                  const SizedBox(height: 10),
                  _buildPickerField(
                    controller: _toDateCtrl,
                    hint: "Select a date",
                    icon: Icons.calendar_today,
                    onTap: () => _selectDate(context, _toDateCtrl),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text("Select Time", style: TextStyle(fontSize: 16)),
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

                  const SizedBox(height: 24),

                  // 5. Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // @color/primary
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 16)),
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
                    color: Colors.black12,
                    child: Center(child: LoadingCard()),
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

  Widget _buildPickerField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              filled: true,
              fillColor: Colors.grey.shade50, // @drawable/input_background simulation
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.transparent, // ?attr/selectableItemBackground
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.grey.shade700, size: 30),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCard({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
            Text(
              controller.text.isEmpty ? "--:--" : controller.text,
              style: TextStyle(
                fontSize: 16,
                color: controller.text.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(width: 60),
            InkWell(
              onTap: onTap,
              child: const Icon(Icons.access_time, color: Colors.grey, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}