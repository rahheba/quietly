import 'package:flutter/material.dart';

class TeacherAttendanceModifier extends StatefulWidget {
  const TeacherAttendanceModifier({Key? key}) : super(key: key);

  @override
  State<TeacherAttendanceModifier> createState() =>
      _TeacherAttendanceModifierState();
}

class _TeacherAttendanceModifierState extends State<TeacherAttendanceModifier> {
  DateTime selectedDate = DateTime.now();
  String selectedClass = '';
  String selectedPeriod = '';
  String searchQuery = '';
  String filterStatus = 'all';
  Map<String, String> modifiedRecords = {};
  String saveStatus = '';

  // Updated periods with correct timings
  final List<Map<String, String>> periods = [
    {
      'id': '1',
      'name': 'Period 1',
      'time': '09:30 AM - 10:30 AM',
      'lateAfter': '10:00 AM',
    },
    {
      'id': '2',
      'name': 'Period 2',
      'time': '10:30 AM - 11:30 AM',
      'lateAfter': '11:00 AM',
    },
    {
      'id': '3',
      'name': 'Period 3',
      'time': '11:45 AM - 12:45 PM',
      'lateAfter': '12:15 PM',
    },
    {
      'id': '4',
      'name': 'Period 4',
      'time': '01:15 PM - 02:15 PM',
      'lateAfter': '01:45 PM',
    },
    {
      'id': '5',
      'name': 'Period 5',
      'time': '02:15 PM - 03:15 PM',
      'lateAfter': '02:45 PM',
    },
  ];

  final List<Map<String, String>> classes = [
    {'id': 'CS101', 'name': 'Computer Science 101', 'section': 'A'},
    {'id': 'CS102', 'name': 'Data Structures', 'section': 'B'},
    {'id': 'CS201', 'name': 'Algorithms', 'section': 'A'},
  ];

  List<Map<String, dynamic>> students = [
    {
      'id': 'S001',
      'name': 'Alice Johnson',
      'deviceId': 'DEV001',
      'status': 'present',
      'autoMarked': true,
      'entryTime': '09:35 AM',
    },
    {
      'id': 'S002',
      'name': 'Bob Smith',
      'deviceId': 'DEV002',
      'status': 'present',
      'autoMarked': true,
      'entryTime': '09:32 AM',
    },
    {
      'id': 'S003',
      'name': 'Charlie Brown',
      'deviceId': 'DEV003',
      'status': 'absent',
      'autoMarked': true,
      'entryTime': null,
    },
    {
      'id': 'S004',
      'name': 'Diana Prince',
      'deviceId': 'DEV004',
      'status': 'present',
      'autoMarked': true,
      'entryTime': '09:45 AM',
    },
    {
      'id': 'S005',
      'name': 'Ethan Hunt',
      'deviceId': 'DEV005',
      'status': 'late',
      'autoMarked': true,
      'entryTime': '10:05 AM',
    },
    {
      'id': 'S006',
      'name': 'Fiona Green',
      'deviceId': 'DEV006',
      'status': 'absent',
      'autoMarked': true,
      'entryTime': null,
    },
  ];

  void toggleAttendance(String studentId, String currentStatus) {
    final Map<String, String> statusCycle = {
      'present': 'absent',
      'absent': 'late',
      'late': 'present',
    };

    setState(() {
      modifiedRecords[studentId] = statusCycle[currentStatus]!;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green.shade100;
      case 'absent':
        return Colors.red.shade100;
      case 'late':
        return Colors.yellow.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green.shade800;
      case 'absent':
        return Colors.red.shade800;
      case 'late':
        return Colors.yellow.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'present':
        return Icons.check;
      case 'absent':
        return Icons.close;
      case 'late':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  List<Map<String, dynamic>> getFilteredStudents() {
    return students.where((student) {
      final matchesSearch =
          student['name'].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ||
          student['id'].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
      final currentStatus = modifiedRecords[student['id']] ?? student['status'];
      final matchesFilter =
          filterStatus == 'all' || currentStatus == filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Future<void> handleSave() async {
    setState(() {
      saveStatus = 'saving';
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      saveStatus = 'saved';
      for (var student in students) {
        if (modifiedRecords.containsKey(student['id'])) {
          student['status'] = modifiedRecords[student['id']];
          student['autoMarked'] = false;
        }
      }
      modifiedRecords.clear();
    });

    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      saveStatus = '';
    });
  }

  int getStatusCount(String status) {
    return students.where((s) {
      final currentStatus = modifiedRecords[s['id']] ?? s['status'];
      return currentStatus == status;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = getFilteredStudents();
    final modificationCount = modifiedRecords.length;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade600,
        title: const Text('Attendance Modifier'),
        actions: [
          if (modificationCount > 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: handleSave,
                icon: const Icon(Icons.save),
                label: Text('Save Changes ($modificationCount)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo.shade600,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Students entering after 30 minutes are automatically marked as LATE',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (saveStatus == 'saved')
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade800),
                    const SizedBox(width: 8),
                    Text(
                      'Changes saved successfully!',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      selectedDate = date;
                                      modifiedRecords.clear();
                                      saveStatus = '';
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Class',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: selectedClass.isEmpty
                                    ? null
                                    : selectedClass,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                                hint: const Text('Select class'),
                                isExpanded:
                                    true, // ADD THIS LINE - Critical fix!
                                items: classes.map((cls) {
                                  return DropdownMenuItem(
                                    value: cls['id'],
                                    child: Text(
                                      '${cls['name']} - Section ${cls['section']}',
                                      overflow: TextOverflow
                                          .ellipsis, // ADD THIS LINE
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedClass = value ?? '';
                                    modifiedRecords.clear();
                                    saveStatus = '';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Period',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: selectedPeriod.isEmpty
                                    ? null
                                    : selectedPeriod,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                                hint: const Text('Select period'),
                                isExpanded:
                                    true, // ADD THIS LINE - Critical fix!
                                items: periods.map((period) {
                                  return DropdownMenuItem(
                                    value: period['id'],
                                    child: Text(
                                      '${period['name']} (${period['time']})',
                                      overflow: TextOverflow
                                          .ellipsis, // ADD THIS LINE
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPeriod = value ?? '';
                                    modifiedRecords.clear();
                                    saveStatus = '';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Filter Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: filterStatus,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'all',
                                    child: Text('All Students'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'present',
                                    child: Text('Present'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'absent',
                                    child: Text('Absent'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'late',
                                    child: Text('Late'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    filterStatus = value ?? 'all';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Search Student',
                        hintText: 'Search by name or ID...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (selectedPeriod.isNotEmpty)
              Card(
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule, color: Colors.indigo.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Period Schedule',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${periods.firstWhere((p) => p['id'] == selectedPeriod)['name']}: ${periods.firstWhere((p) => p['id'] == selectedPeriod)['time']}',
                        style: TextStyle(color: Colors.indigo.shade700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Late after: ${periods.firstWhere((p) => p['id'] == selectedPeriod)['lateAfter']}',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade600,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Attendance Records',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Click on status badges to modify attendance',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  if (filteredStudents.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(48),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No students found matching your filters',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        final studentId = student['id'] as String;
                        final currentStatus =
                            modifiedRecords[studentId] ??
                            student['status'] as String;
                        final isModified = modifiedRecords.containsKey(
                          studentId,
                        );

                        return Container(
                          decoration: BoxDecoration(
                            color: isModified
                                ? Colors.blue.shade50
                                : Colors.white,
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: Text(
                                student['name'].toString()[0],
                                style: TextStyle(
                                  color: Colors.indigo.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              student['name'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${student['id']} • Entry: ${student['entryTime'] ?? '-'}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => toggleAttendance(
                                    studentId,
                                    currentStatus,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(currentStatus),
                                      border: Border.all(
                                        color: getStatusTextColor(
                                          currentStatus,
                                        ),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          getStatusIcon(currentStatus),
                                          size: 16,
                                          color: getStatusTextColor(
                                            currentStatus,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          currentStatus[0].toUpperCase() +
                                              currentStatus.substring(1),
                                          style: TextStyle(
                                            color: getStatusTextColor(
                                              currentStatus,
                                            ),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (isModified)
                                  Chip(
                                    label: const Text(
                                      'Modified',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    backgroundColor: Colors.blue.shade100,
                                    padding: EdgeInsets.zero,
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  )
                                else
                                  Text(
                                    'Auto',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attendance Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${students.length}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Present',
                                  style: TextStyle(
                                    color: Colors.green.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${getStatusCount('present')}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Absent',
                                  style: TextStyle(color: Colors.red.shade600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${getStatusCount('absent')}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Late',
                                  style: TextStyle(
                                    color: Colors.yellow.shade700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${getStatusCount('late')}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
