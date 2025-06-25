import 'package:flutter/material.dart';

class CustomValidators {
  // 🔸 Date Validator (e.g., Booking date must be today or in future)
  static String? validateBookingDate(DateTime? selectedDate) {
    if (selectedDate == null) return 'Please select a booking date';

    final now = DateTime.now();
    if (selectedDate.isBefore(DateTime(now.year, now.month, now.day))) {
      return 'Booking date cannot be in the past';
    }
    return null;
  }

  // 🔸 Time Validator (e.g., Time must be selected)
  static String? validateBookingTime(TimeOfDay? selectedTime) {
    if (selectedTime == null) return 'Please select a booking time';
    return null;
  }

  // 🔸 Dropdown Validator (e.g., Turf selection or category)
  static String? validateDropdown(String? value, {String fieldName = 'Selection'}) {
    if (value == null || value.trim().isEmpty || value == 'Select') {
      return '$fieldName is required';
    }
    return null;
  }

  // 🔸 Checkbox Validator (e.g., Accept Terms & Conditions)
  static String? validateCheckbox(bool? value, {String message = 'You must agree to continue'}) {
    if (value == null || !value) {
      return message;
    }
    return null;
  }

  // 🔸 Turf Name Validation
  static String? validateTurfName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Turf name is required';
    }
    if (value.trim().length < 3) {
      return 'Turf name must be at least 3 characters';
    }
    return null;
  }

  // 🔸 Turf Price Validation
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Enter a valid price';
    }
    return null;
  }
}
