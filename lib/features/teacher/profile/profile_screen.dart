// File: lib/features/teacher/teacher_profile.dart

import 'package:flutter/material.dart';

// Mock class to simulate shared class data (in real app, this would be from Firebase/Firestore)
class ClassManager {
  static final List<ClassRoom> _classes = [
    ClassRoom(
      className: '9A Mathematics',
      teacherName: 'Ms. Sarah Johnson',
      subject: 'Mathematics',
      studentDeviceIds: ['DEV001', 'DEV002', 'DEV003'],
    ),
    ClassRoom(
      className: '10B Science',
      teacherName: 'Mr. David Wilson',
      subject: 'Science',
      studentDeviceIds: ['DEV004', 'DEV005'],
    ),
    ClassRoom(
      className: '8C English',
      teacherName: 'Mrs. Emily Brown',
      subject: 'English',
      studentDeviceIds: ['DEV006', 'DEV007', 'DEV008'],
    ),
    ClassRoom(
      className: '11A Physics',
      teacherName: 'Dr. Robert Smith',
      subject: 'Physics',
      studentDeviceIds: ['DEV009', 'DEV010'],
    ),
  ];

  static List<ClassRoom> get classes => _classes;

  static void addClass(ClassRoom newClass) {
    _classes.add(newClass);
  }

  static void removeClass(String className) {
    _classes.removeWhere((c) => c.className == className);
  }

  static List<ClassRoom> getClassesByTeacher(String teacherName) {
    return _classes.where((c) => c.teacherName == teacherName).toList();
  }

  static List<ClassRoom> searchClasses(String query) {
    if (query.isEmpty) return _classes;
    return _classes
        .where(
          (c) =>
              c.className.toLowerCase().contains(query.toLowerCase()) ||
              c.subject.toLowerCase().contains(query.toLowerCase()) ||
              c.teacherName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}

class ClassRoom {
  final String className;
  final String teacherName;
  final String subject;
  final List<String> studentDeviceIds;

  ClassRoom({
    required this.className,
    required this.teacherName,
    required this.subject,
    required this.studentDeviceIds,
  });
}

class TeacherProfile extends StatelessWidget {
  final String currentTeacherName = 'Ms. Sarah Johnson';
  final String currentTeacherId = 'TEACH2024001';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32),

            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            SizedBox(height: 16),

            // Teacher Info
            Text(
              currentTeacherName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              currentTeacherId,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            SizedBox(height: 32),

            // Profile Info Cards
            _buildInfoCard(
              icon: Icons.subject,
              title: 'Subject',
              value: 'Mathematics',
            ),
            _buildInfoCard(
              icon: Icons.school,
              title: 'Department',
              value: 'Science & Mathematics',
            ),
            _buildInfoCard(
              icon: Icons.work,
              title: 'Experience',
              value: '8 Years',
            ),
            _buildInfoCard(
              icon: Icons.people,
              title: 'My Classes',
              value:
                  '${ClassManager.getClassesByTeacher(currentTeacherName).length} Classes',
            ),
            _buildInfoCard(
              icon: Icons.email,
              title: 'Email',
              value: 'sarah.johnson@school.edu',
            ),
            _buildInfoCard(
              icon: Icons.phone,
              title: 'Phone',
              value: '+1 234 567 8900',
            ),
            SizedBox(height: 16),

            // Manage Classes Button
            _buildButton(
              context,
              label: 'Manage Classes',
              icon: Icons.class_,
              color: Colors.blue,
              onPressed: () => _showManageClassesDialog(context),
            ),
            SizedBox(height: 12),

            // Send Notification Button
            _buildButton(
              context,
              label: 'Send Notification',
              icon: Icons.notifications_active_outlined,
              color: Colors.orange,
              onPressed: () => _showNotificationDialog(context),
            ),
            SizedBox(height: 12),

            // Edit Profile Button
            _buildButton(
              context,
              label: 'Edit Profile',
              color: Colors.purple,
              onPressed: () {},
            ),
            SizedBox(height: 12),

            // Logout Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => _showLogoutDialog(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red, width: 2),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Common button builder
  Widget _buildButton(
    BuildContext context, {
    required String label,
    IconData? icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon != null ? Icon(icon) : SizedBox(),
          label: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.purple, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🆕 Manage Classes Dialog - Create, View, Edit, Delete Classes
  void _showManageClassesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.class_, color: Colors.blue),
              SizedBox(width: 12),
              Text('Manage My Classes'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Create New Class Button
                ElevatedButton.icon(
                  onPressed: () => _showCreateClassDialog(context, setState),
                  icon: Icon(Icons.add),
                  label: Text('Create New Class'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // My Classes List
                Text(
                  'My Classes (${ClassManager.getClassesByTeacher(currentTeacherName).length})',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: ClassManager.getClassesByTeacher(
                      currentTeacherName,
                    ).length,
                    itemBuilder: (context, index) {
                      final classRoom = ClassManager.getClassesByTeacher(
                        currentTeacherName,
                      )[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(Icons.class_, color: Colors.blue),
                          title: Text(classRoom.className),
                          subtitle: Text(
                            '${classRoom.studentDeviceIds.length} students',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _showEditClassDialog(
                                  context,
                                  setState,
                                  classRoom,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    ClassManager.removeClass(
                                      classRoom.className,
                                    );
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Class ${classRoom.className} deleted',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  // Create Class Dialog
  void _showCreateClassDialog(BuildContext context, StateSetter setState) {
    final _classNameController = TextEditingController();
    final _subjectController = TextEditingController();
    final _deviceIdController = TextEditingController();
    List<String> students = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, dialogSetState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.add_circle, color: Colors.blue),
              SizedBox(width: 12),
              Text('Create New Class'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _classNameController,
                  decoration: InputDecoration(
                    labelText: 'Class Name',
                    hintText: 'e.g., 9A Mathematics',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    hintText: 'e.g., Mathematics, Science',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Add Student Section
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _deviceIdController,
                        decoration: InputDecoration(
                          labelText: 'Student Device ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final id = _deviceIdController.text.trim();
                        if (id.isNotEmpty && !students.contains(id)) {
                          dialogSetState(() {
                            students.add(id);
                            _deviceIdController.clear();
                          });
                        }
                      },
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Students List
                Text('Students (${students.length})'),
                Container(
                  height: 120,
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: Icon(Icons.person, color: Colors.green),
                      title: Text(students[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          dialogSetState(() => students.removeAt(index));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_classNameController.text.isNotEmpty &&
                    _subjectController.text.isNotEmpty) {
                  final newClass = ClassRoom(
                    className: _classNameController.text,
                    teacherName: currentTeacherName,
                    subject: _subjectController.text,
                    studentDeviceIds: students,
                  );

                  ClassManager.addClass(newClass);
                  setState(() {}); // Refresh parent dialog
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Class ${_classNameController.text} created successfully!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text('Create Class'),
            ),
          ],
        ),
      ),
    );
  }

  // Edit Class Dialog
  void _showEditClassDialog(
    BuildContext context,
    StateSetter setState,
    ClassRoom classRoom,
  ) {
    final _deviceIdController = TextEditingController();
    List<String> students = List.from(classRoom.studentDeviceIds);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, dialogSetState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.edit, color: Colors.orange),
              SizedBox(width: 12),
              Text('Edit ${classRoom.className}'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.purple),
                  title: Text('Teacher'),
                  subtitle: Text(classRoom.teacherName),
                ),
                ListTile(
                  leading: Icon(Icons.subject, color: Colors.purple),
                  title: Text('Subject'),
                  subtitle: Text(classRoom.subject),
                ),
                SizedBox(height: 16),

                // Add Student Section
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _deviceIdController,
                        decoration: InputDecoration(
                          labelText: 'Add Student Device ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final id = _deviceIdController.text.trim();
                        if (id.isNotEmpty && !students.contains(id)) {
                          dialogSetState(() {
                            students.add(id);
                            _deviceIdController.clear();
                          });
                        }
                      },
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Students List
                Text('Students (${students.length})'),
                Container(
                  height: 150,
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: Icon(Icons.person, color: Colors.green),
                      title: Text(students[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          dialogSetState(() => students.removeAt(index));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update class with new student list
                final updatedClass = ClassRoom(
                  className: classRoom.className,
                  teacherName: classRoom.teacherName,
                  subject: classRoom.subject,
                  studentDeviceIds: students,
                );

                ClassManager.removeClass(classRoom.className);
                ClassManager.addClass(updatedClass);
                setState(() {}); // Refresh parent dialog
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Class ${classRoom.className} updated!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Notification Dialog with Integrated Search in Dropdown
  void _showNotificationDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _messageController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    ClassRoom? selectedClass;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.notifications, color: Colors.orange),
              SizedBox(width: 12),
              Text('Send Notification'),
            ],
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Class Selection Dropdown with Search
                DropdownButtonFormField<ClassRoom>(
                  decoration: InputDecoration(
                    labelText: 'Select Class',
                    prefixIcon: Icon(Icons.search, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: selectedClass != null
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                selectedClass = null;
                              });
                            },
                          )
                        : null,
                  ),
                  value: selectedClass,
                  isExpanded: true,
                  items: [
                    // Search hint item
                    DropdownMenuItem(
                      value: null,
                      enabled: false,
                      child: Text(
                        'Type to search classes...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ...ClassManager.classes.map(
                      (classRoom) => DropdownMenuItem(
                        value: classRoom,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classRoom.className,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${classRoom.teacherName} • ${classRoom.subject} • ${classRoom.studentDeviceIds.length} students',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() {
                    selectedClass = value;
                  }),
                  validator: (value) =>
                      value == null ? 'Please select a class' : null,

                  // Custom searchable dropdown behavior
                  onTap: () {
                    // Show search dialog when dropdown is tapped
                    _showClassSearchDialog(context, setState, (
                      ClassRoom? newSelectedClass,
                    ) {
                      setState(() {
                        selectedClass = newSelectedClass;
                      });
                    }, selectedClass);
                  },
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.title, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Enter a title' : null,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    prefixIcon: Icon(Icons.message, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Enter a message' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Notification sent to ${selectedClass!.className} (${selectedClass!.studentDeviceIds.length} students) successfully!',
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );

                  print('Class: ${selectedClass!.className}');
                  print('Teacher: ${selectedClass!.teacherName}');
                  print('Students: ${selectedClass!.studentDeviceIds}');
                  print('Title: ${_titleController.text}');
                  print('Message: ${_messageController.text}');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }

  // Class Search Dialog for the dropdown - FIXED VERSION
  void _showClassSearchDialog(
    BuildContext context,
    StateSetter setState,
    Function(ClassRoom?) onClassSelected,
    ClassRoom? currentlySelected,
  ) {
    final _searchController = TextEditingController();
    List<ClassRoom> _filteredClasses = ClassManager.classes;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, dialogSetState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.search, color: Colors.orange),
              SizedBox(width: 12),
              Text('Search Class'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by class, subject, or teacher',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              dialogSetState(() {
                                _searchController.clear();
                                _filteredClasses = ClassManager.classes;
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    dialogSetState(() {
                      _filteredClasses = ClassManager.searchClasses(value);
                    });
                  },
                ),
                SizedBox(height: 16),

                // Classes List
                Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: _filteredClasses.length,
                    itemBuilder: (context, index) {
                      final classRoom = _filteredClasses[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        color:
                            currentlySelected?.className == classRoom.className
                            ? Colors.orange.withOpacity(0.1)
                            : null,
                        child: ListTile(
                          leading: Icon(Icons.class_, color: Colors.blue),
                          title: Text(
                            classRoom.className,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${classRoom.teacherName} • ${classRoom.subject} • ${classRoom.studentDeviceIds.length} students',
                          ),
                          trailing:
                              currentlySelected?.className ==
                                  classRoom.className
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            onClassSelected(classRoom);
                            Navigator.pop(context); // Close search dialog
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 12),
            Text('Logout'),
          ],
        ),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
