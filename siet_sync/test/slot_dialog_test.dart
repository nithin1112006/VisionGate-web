import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vision_gate/widgets/academic_schedule/timetable_slot_dialog.dart';

void main() {
  testWidgets('TimetableSlotDialog renders with initialSlot without error', (WidgetTester tester) async {
    final slot = {
      'id': 35,
      'day_of_week': 'Tuesday',
      'period_number': 2,
      'subject_code': '21CS620',
      'subject_name': 'Mobile computation application',
      'staff_reg_no': 'STAFF_0035',
      'staff_name': 'Faculty',
      'staff_role': 'staff',
      'staff_dept': 'CSE',
      'room_or_lab': 'LH14',
      'is_lab_block': false,
      'lab_batch': 'ALL',
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimetableSlotDialog(
            token: 'test_token',
            dept: 'CSE',
            batch: '2022-2026',
            semester: 6,
            section: 'A',
            dayOfWeek: 'Tuesday',
            periodNumber: 2,
            periodTimeRange: '09:15 AM - 10:00 AM',
            initialSlot: slot,
            facultyPool: const [
              {'reg_no': 'STAFF_0035', 'name': 'Prof Test', 'dept': 'CSE', 'is_hod': false}
            ],
            subjectAllocations: const [
              {
                'subject_code': '21CS620',
                'subject_name': 'Mobile computation application',
                'subject_type': 'Theory',
                'staff_reg_no': 'STAFF_0035',
                'staff_name': 'Prof Test',
                'staff_dept': 'CSE',
              }
            ],
            availableDepartments: const ['CSE', 'ECE'],
            onSaved: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Tuesday — Period 2'), findsOneWidget);
    expect(find.text('Clear Slot'), findsOneWidget);
    expect(find.text('Save Slot'), findsOneWidget);
  });

  testWidgets('TimetableSlotDialog renders with null initialSlot without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimetableSlotDialog(
            token: 'test_token',
            dept: 'CSE',
            batch: '2022-2026',
            semester: 6,
            section: 'A',
            dayOfWeek: 'Tuesday',
            periodNumber: 2,
            periodTimeRange: '09:15 AM - 10:00 AM',
            initialSlot: null,
            facultyPool: const [],
            subjectAllocations: const [],
            availableDepartments: const ['CSE'],
            onSaved: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Tuesday — Period 2'), findsOneWidget);
    expect(find.text('Save Slot'), findsOneWidget);
    expect(find.text('Clear Slot'), findsNothing);
  });

  testWidgets('TimetableSlotDialog handles chip selection, lab toggle, and text input without error', (WidgetTester tester) async {
    final allocations = [
      {
        'subject_code': '21CS621',
        'subject_name': 'Network Lab',
        'subject_type': 'Lab',
        'staff_reg_no': 'STAFF_0099',
        'staff_name': 'Prof Lab',
        'staff_dept': 'CSE',
      }
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimetableSlotDialog(
            token: 'test_token',
            dept: 'CSE',
            batch: '2022-2026',
            semester: 6,
            section: 'A',
            dayOfWeek: 'Wednesday',
            periodNumber: 3,
            periodTimeRange: '10:00 AM - 10:45 AM',
            initialSlot: null,
            facultyPool: const [
              {'reg_no': 'STAFF_0099', 'name': 'Prof Lab', 'dept': 'CSE', 'is_hod': true}
            ],
            subjectAllocations: allocations,
            availableDepartments: const ['CSE'],
            onSaved: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap on the ChoiceChip for Network Lab
    final chipFinder = find.byType(ChoiceChip);
    expect(chipFinder, findsOneWidget);
    await tester.tap(chipFinder);
    await tester.pumpAndSettle();

    // Check that Lab block controls appear
    expect(find.text('Lab Block Duration:'), findsOneWidget);

    // Enter room text
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'LH-101');
    await tester.pumpAndSettle();

    // Toggle lab checkbox
    final checkbox = find.byType(Checkbox);
    expect(checkbox, findsOneWidget);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
  });

  testWidgets('TimetableSlotDialog safely handles malformed data with nulls', (WidgetTester tester) async {
    final slotWithNulls = {
      'id': null,
      'day_of_week': null,
      'period_number': null,
      'subject_code': null,
      'subject_name': null,
      'staff_reg_no': null,
      'staff_name': null,
      'staff_role': null,
      'staff_dept': null,
      'room_or_lab': null,
      'is_lab_block': null,
      'lab_batch': null,
      'span_periods': null,
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimetableSlotDialog(
            token: 'test_token',
            dept: 'CSE',
            batch: '2022-2026',
            semester: 6,
            section: 'A',
            dayOfWeek: 'Friday',
            periodNumber: 1,
            periodTimeRange: '08:30 AM - 09:15 AM',
            initialSlot: slotWithNulls,
            facultyPool: const [
              {'reg_no': null, 'name': null, 'dept': null, 'is_hod': null}
            ],
            subjectAllocations: const [
              {
                'subject_code': null,
                'subject_name': null,
                'subject_type': null,
                'staff_reg_no': null,
                'staff_name': null,
                'staff_dept': null,
              }
            ],
            availableDepartments: const [],
            onSaved: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Friday — Period 1'), findsOneWidget);
  });
}
