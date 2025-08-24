// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart';
import 'package:lawyer_cases_app/screens/adddontknow.dart';
import 'package:lawyer_cases_app/screens/case_ditals.dart';
import 'package:lawyer_cases_app/screens/edit_lawer.dart';
import 'package:lawyer_cases_app/service.dart/db_helper.dart';
import 'package:lawyer_cases_app/screens/add_case_paag.dart';
import 'package:lawyer_cases_app/service.dart/caseSearchDelegate.dart';
import 'package:lawyer_cases_app/screens/edit_cases.dart';

import '../service.dart/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final DateTime _baseDate = DateTime(2024);
Map<String, dynamic>? lawyerData;
bool isLoading = true;
DBHelper dbHelper = DBHelper();
List lawyer = [];
List casess = [];

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  // ignore: unused_field
  int _currentPage = 0;

  Future<void> getlawer() async {
    List<Map> response = await dbHelper.getlayer("SELECT * FROM lawyer");
    lawyer.clear();
    lawyer.addAll(response);
    if (lawyer.isNotEmpty) {
      lawyerData = lawyer.first;
    }
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getcases() async {
    List<Map<String, dynamic>> response =
        await dbHelper.getCases("SELECT * FROM cases");
    casess = response.map((e) => Map<String, dynamic>.from(e)).toList();

    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadCasesForDate(DateTime date) async {
    setState(() {
      isLoading = true;
    });
    final todayCases = await DBHelper().getTodayCases(date);
    setState(() {
      casess = todayCases;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    final int todayPage = DateTime.now().difference(_baseDate).inDays;
    _pageController = PageController(initialPage: todayPage);
    initializeDateFormatting('ar', null).then((_) {
      getlawer();

      _loadCasesForDate(_baseDate);
    });
  }

  String _formatDate(DateTime date) {
    return intl.DateFormat('EEEE، dd MMMM yyyy', 'ar').format(date);
  }

  void _onPageChanged(int page) {
    final newDate = _baseDate.add(Duration(days: page));
    setState(() {
      _currentPage = page;
    });
    _loadCasesForDate(newDate);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.deepPurple[700] : Colors.deepPurple,
        title: Row(
          children: [
            IconButton(
              iconSize: 28,
              icon: const Icon(Icons.add),
              color: isDark ? Colors.black : Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Adddontknow(),
                    ));
              },
            ),
            IconButton(
              iconSize: 28,
              icon: const Icon(Icons.search),
              color: isDark ? Colors.black : Colors.white,
              onPressed: () {
                showSearch(context: context, delegate: CaseSearchDelegate());
              },
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "الرئيسية",
                  style: TextStyle(
                    fontSize: 25,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                )),
          ),
        ],
      ),
      body: Column(
        children: [
          if (lawyerData != null) _buildLawyerCard(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final date = _baseDate.add(Duration(days: index));
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _formatDate(date),
                        style: TextStyle(
                          fontSize: 20,
                          color: isDark ? Colors.grey[300] : Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : casess.isEmpty
                              ? Center(
                                  child: Text(
                                    "لا توجد قضايا لهذا اليوم",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isDark
                                          ? Colors.grey[300]
                                          : Colors.grey[800],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: casess.length,
                                  itemBuilder: (context, index) {
                                    if (index < 0 || index >= casess.length) {
                                      return const SizedBox.shrink();
                                    }
                                    final caseData = casess[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CaseDetailsScreen(
                                                caseData: caseData,
                                              ),
                                            ));
                                      },
                                      onLongPress: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Text(
                                                  'اختر ما تريد',
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.grey[300]
                                                        : Colors.grey[800],
                                                  ),
                                                )),
                                            content: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Text(
                                                    style: TextStyle(
                                                      color: isDark
                                                          ? Colors.grey[300]
                                                          : Colors.grey[800],
                                                    ),
                                                    'ماذا تريد ان تفعل ؟ ')),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  final updatedCase =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditCaseScreen(
                                                              caseData: casess[
                                                                  index]),
                                                    ),
                                                  );

                                                  if (updatedCase != null) {
                                                    setState(() {
                                                      casess[index] =
                                                          updatedCase;
                                                    });
                                                  }
                                                },
                                                child: Text('تعديل القضية',
                                                    style: TextStyle(
                                                      color: isDark
                                                          ? Colors.grey[300]
                                                          : Colors.grey[800],
                                                    )),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  final id =
                                                      caseData['id'] as int;
                                                  final response =
                                                      await dbHelper
                                                          .deletecasee(
                                                              'cases', id);
                                                  if (response > 0 && mounted) {
                                                    await NotificationService
                                                        .cancelNotification(
                                                            caseData['id']);

                                                    setState(() {
                                                      casess = List<
                                                              Map<String,
                                                                  dynamic>>.from(
                                                          casess);
                                                      casess.removeWhere(
                                                          (element) =>
                                                              element['id'] ==
                                                              id);
                                                    });
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              style: TextStyle(
                                                                color: isDark
                                                                    ? Colors.grey[
                                                                        300]
                                                                    : Colors.grey[
                                                                        800],
                                                              ),
                                                              "تم حذف القضية بنجاح")),
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  'حذف القضية',
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.grey[300]
                                                        : Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Card(
                                          color: isDark
                                              ? Colors.grey[900]
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          elevation: 10,
                                          shadowColor: isDark
                                              ? Colors.deepPurpleAccent
                                              : Colors.deepPurple
                                                  .withOpacity(0.3),
                                          child: ListTile(
                                              title: Text(
                                                'اسم الموكل : ${caseData['name1'] ?? ''}',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: isDark
                                                      ? Colors.grey[300]
                                                      : Colors.grey[800],
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'الخصم : ${caseData['name2']}',
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      color: isDark
                                                          ? Colors.grey[300]
                                                          : Colors.grey[800],
                                                    ),
                                                  ),
                                                  Text(
                                                    'محكمة : ${caseData['court_name'] ?? ''}',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: isDark
                                                          ? Colors.grey[300]
                                                          : Colors.grey[800],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark ? Colors.deepPurple[700] : Colors.deepPurple,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const AddCasePage();
            },
          ));
        },
        child: Icon(
          Icons.add,
          color: isDark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildLawyerCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  'تاكيد التعديل ',
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                  ),
                )),
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  'هل أنت متأكد من تعديل معلوماتك ؟',
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                  ),
                )),
            actions: [
              TextButton(
                onPressed: () async {
                  final updatedlawyer = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditLawer(
                            name: lawyerData!['name'],
                            email: lawyerData!['email'],
                            phone: lawyerData!['phone'],
                            imagepath: lawyerData!['imagePath'],
                            id: lawyerData!['id']),
                      ));

                  if (updatedlawyer != null) {
                    setState(() {
                      lawyerData = updatedlawyer;
                    });
                  }
                },
                child: Text('تعديل',
                    style: TextStyle(
                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                    )),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Card(
        color: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 10,
        shadowColor: isDark
            ? Colors.deepPurpleAccent
            : Colors.deepPurple.withOpacity(0.3),
        margin: const EdgeInsets.all(8),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: lawyerData!['imagePath'] != null
                  ? FileImage(File(lawyerData!['imagePath']))
                  : null,
              child: lawyerData!['imagePath'] == null
                  ? const Icon(Icons.camera_alt, size: 40)
                  : null,
            ),
            title: Text(
              lawyerData!['name'] ?? '',
              style: TextStyle(
                fontSize: 25,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lawyerData!['email'] ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                  ),
                ),
                Text(
                  lawyerData!['phone'] ?? '',
                  style: TextStyle(
                    fontSize: 17,
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
