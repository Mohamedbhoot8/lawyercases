// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lawyer_cases_app/service.dart/db_helper.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lawyer_cases_app/screens/Homepage.dart';
import 'package:lawyer_cases_app/service.dart/notification_service.dart';
import 'package:lawyer_cases_app/widget.dart/customAppBar.dart';

class EditCaseScreen extends StatefulWidget {
  final Map<String, dynamic> caseData;

  const EditCaseScreen({required this.caseData, super.key});

  @override
  State<EditCaseScreen> createState() => _EditCaseScreenState();
}

class _EditCaseScreenState extends State<EditCaseScreen> {
  DBHelper dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController accusedController1;
  late TextEditingController accusedController2;
  late TextEditingController caseNumberController;
  late TextEditingController courtController;
  late TextEditingController phoneController;
  late TextEditingController notesController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    accusedController1 = TextEditingController(text: widget.caseData['name1']);
    accusedController2 = TextEditingController(text: widget.caseData['name2']);
    caseNumberController =
        TextEditingController(text: widget.caseData['case_number']);
    courtController =
        TextEditingController(text: widget.caseData['court_name']);
    phoneController =
        TextEditingController(text: widget.caseData['client_phone']);

    notesController = TextEditingController(text: widget.caseData['details']);
  }

  @override
  void dispose() {
    accusedController1.dispose();
    accusedController2.dispose();

    caseNumberController.dispose();
    courtController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> updateCase() async {
    String dateToSave = _selectedDate != null
        ? intl.DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : (widget.caseData['date'] ?? "");
    int response = await dbHelper.updateCase('''
                        UPDATE cases SET 
                        name1  =       '${accusedController1.text}' , 
                        name2 =        '${accusedController2.text}',
                        date =         '$dateToSave',
                        details =      '${notesController.text}' ,
                        case_number =  '${caseNumberController.text}' ,
                        court_name =   '${courtController.text}' ,
                        client_phone = '${phoneController.text}' 
                         
                        WHERE id  = ${widget.caseData['id']}
                                        ''');

    if (response > 0) {
      await NotificationService.cancelNotification(widget.caseData['id']);
      if (_selectedDate!.isAfter(DateTime.now())) {
        await NotificationService.scheduleNotification(
          id: widget.caseData['id'],
          title: 'تم تعديل الجلسة',
          body: 'القضية رقم ${caseNumberController.text} موعدها الجديد',
          scheduledDate: _selectedDate!.subtract(const Duration(days: 1)),
        );
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("ar", "EG"),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: Customappbar(
        title: 'تعديل القضية',
        textcolor: isDark ? Colors.black : Colors.white,
        backgcolor: isDark ? Colors.deepPurple[700] : Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: accusedController1,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_2_rounded),
                          labelText: "اسم الموكل"),
                      validator: (value) =>
                          value!.isEmpty ? "ادخل اسم الموكل" : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: accusedController2,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_2_rounded),
                          labelText: "الخصم"),
                      validator: (value) =>
                          value!.isEmpty ? "ادخل اسم الخصم" : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: caseNumberController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          labelText: "رقم القضية"),
                      validator: (value) =>
                          value!.isEmpty ? "ادخل رقم القضية" : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: courtController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.balance),
                          labelText: "اسم المحكمة"),
                      validator: (value) =>
                          value!.isEmpty ? "ادخل اسم المحكمة" : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: "رقم هاتف الموكل"),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? "ادخل رقم هاتف الموكل" : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? "اختر ميعاد الجلسة"
                              : "ميعاد الجلسة: ${intl.DateFormat('yyyy-MM-dd').format(_selectedDate!)}",
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _pickDate,
                        child: const Text("اختيار التاريخ"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.note_alt_rounded),
                          labelText: "ملاحظات"),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: updateCase,
                      child: const Text("حفظ التعديلات"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
