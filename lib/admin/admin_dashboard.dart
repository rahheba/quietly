import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final Color primaryColor = const Color(0xFF6B4423);
  final Color secondaryColor = const Color(0xFF8B5A3C);
  final Color backgroundColor = const Color(0xFFE8DCC8);

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      AdminOverviewPage(),
      StudentManagementPage(),
      ParentManagementPage(),
      TeacherManagementPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.admin_panel_settings, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Quietly Admin',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),

      // Mobile bottom nav
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey,
              onTap: (index) => setState(() => _selectedIndex = index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Overview'),
                BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Students'),
                BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Parents'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Teachers'),
              ],
            )
          : null,

      // Body: mobile -> full page, desktop -> navigation rail + page
      body: isMobile
          ? _pages[_selectedIndex]
          : Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  backgroundColor: Colors.white,
                  selectedIconTheme: IconThemeData(color: primaryColor),
                  unselectedIconTheme: const IconThemeData(color: Colors.grey),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text('Overview'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: Text('Students'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people),
                      label: Text('Parents'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Teachers'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: _pages[_selectedIndex]),
              ],
            ),
    );
  }
}

/// ------------------------------
/// OVERVIEW PAGE
/// ------------------------------
class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overview', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              }

              final users = snapshot.data!.docs;
              final int studentCount = users.where((u) => (u.data()['role'] ?? '') == 'student').length;
              final int teacherCount = users.where((u) => (u.data()['role'] ?? '') == 'teacher').length;
              final int parentCount = users.where((u) => (u.data()['role'] ?? '') == 'parent').length;

              return GridView.count(
                crossAxisCount: isMobile ? 1 : 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isMobile ? 2.8 : 1.5,
                children: [
                  _buildStatCard('Total Students', studentCount.toString(), Icons.school, Colors.blue),
                  _buildStatCard('Total Teachers', teacherCount.toString(), Icons.person, Colors.green),
                  _buildStatCard('Total Parents', parentCount.toString(), Icons.people, const Color.fromARGB(255, 126, 83, 18)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------
/// STUDENT MANAGEMENT PAGE
/// ------------------------------
class StudentManagementPage extends StatefulWidget {
  const StudentManagementPage({super.key});

  @override
  State<StudentManagementPage> createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends State<StudentManagementPage> {
  final Color primaryColor = const Color(0xFF6B4423);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Student Management', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _showAddStudentDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Student'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('Users').where('role', isEqualTo: 'student').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No students found', style: TextStyle(fontSize: 18)));
              }

              final docs = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final student = docs[index];
                  return _buildUserCard(context, student, Icons.school, Colors.blue);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final List<String> classes = ['BCA', 'BCom', 'BA', 'BSc', 'BBA'];
    String? selectedClass;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Add New Student'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedClass,
                    decoration: InputDecoration(labelText: 'Class', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setStateDialog(() => selectedClass = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () {
                nameController.dispose();
                emailController.dispose();
                passwordController.dispose();
                Navigator.pop(context);
              }, child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();
                  final password = passwordController.text;

                  if (name.isEmpty || email.isEmpty || password.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid name, email and password (>=6 chars)')));
                    return;
                  }

                  try {
                    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                    final uid = userCredential.user?.uid;
                    if (uid != null) {
                      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
                        'uid': uid,
                        'name': name,
                        'email': email,
                        'role': 'student',
                        'class': selectedClass ?? '',
                        'createdAt': FieldValue.serverTimestamp(),
                      });

                      nameController.dispose();
                      emailController.dispose();
                      passwordController.dispose();

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student added successfully')));
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: const Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildUserCard(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> user, IconData icon, Color color) {
    final data = user.data();
    final String name = (data['name'] ?? 'N/A').toString();
    final String email = (data['email'] ?? 'N/A').toString();
    final String studentClass = (data['class'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(email, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              if (studentClass.isNotEmpty) const SizedBox(height: 4),
              if (studentClass.isNotEmpty) Text('Class: $studentClass', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ]),
          ),
          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showEditDialog(context, user)),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteUser(context, user.id)),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> user) {
    final data = user.data();
    final nameController = TextEditingController(text: (data['name'] ?? '').toString());
    final emailController = TextEditingController(text: (data['email'] ?? '').toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 12),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
          ],
        ),
        actions: [
          TextButton(onPressed: () { nameController.dispose(); emailController.dispose(); Navigator.pop(context); }, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              final newEmail = emailController.text.trim();
              if (newName.isEmpty || newEmail.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name and email cannot be empty')));
                return;
              }
              await FirebaseFirestore.instance.collection('Users').doc(user.id).update({'name': newName, 'email': newEmail});
              nameController.dispose();
              emailController.dispose();
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('Users').doc(userId).delete();
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// --------------------------------
/// PARENT MANAGEMENT PAGE
/// --------------------------------
class ParentManagementPage extends StatelessWidget {
  const ParentManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Parent Management', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Parent'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B4423), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('Users').where('role', isEqualTo: 'parent').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No parents found'));

              final docs = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final parent = docs[index];
                  final data = parent.data();
                  final name = (data['name'] ?? 'N/A').toString();
                  final email = (data['email'] ?? 'N/A').toString();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.orange.withOpacity(0.1), child: const Icon(Icons.people, color: Colors.orange)),
                      title: Text(name),
                      subtitle: Text(email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// --------------------------------
/// TEACHER MANAGEMENT PAGE
/// --------------------------------
class TeacherManagementPage extends StatelessWidget {
  const TeacherManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Teacher Management', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Teacher'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B4423), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('Users').where('role', isEqualTo: 'teacher').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No teachers found'));

              final docs = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final teacher = docs[index];
                  final data = teacher.data();
                  final name = (data['name'] ?? 'N/A').toString();
                  final email = (data['email'] ?? 'N/A').toString();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.green.withOpacity(0.1), child: const Icon(Icons.person, color: Colors.green)),
                      title: Text(name),
                      subtitle: Text(email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

