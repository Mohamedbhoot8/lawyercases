import 'package:flutter/material.dart';
import 'package:lawyer_cases_app/widget.dart/customAppBar.dart';

class CaseDetailsScreen extends StatefulWidget {
  final Map<dynamic, dynamic> caseData;

  const CaseDetailsScreen({super.key, required this.caseData});

  @override
  State<CaseDetailsScreen> createState() => _CaseDetailsScreenState();
}

class _CaseDetailsScreenState extends State<CaseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final caseData = widget.caseData;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: Customappbar(
        title: 'تفاصيل القضية',
        textcolor: isDark ? Colors.black : Colors.white,
        backgcolor: isDark ? Colors.deepPurple[700] : Colors.deepPurple,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Card(
                color: isDark ? Colors.grey[900] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 10,
                shadowColor: isDark
                    ? Colors.deepPurpleAccent
                    : Colors.deepPurple.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(Icons.gavel,
                            size: 48,
                            color: isDark
                                ? Colors.deepPurpleAccent
                                : Colors.deepPurple),
                      ),
                      const SizedBox(height: 16),
                      _buildRow("اسم الموكل :", caseData['name1']),
                      _buildRow("الخصم :", caseData['name2']),
                      _buildRow("رقم القضية :", caseData['case_number']),
                      _buildRow("محكمة :", caseData['court_name']),
                      _buildRow("التاريخ:", caseData['date']),
                      _buildRow("رقم هاتف الموكل :", caseData['client_phone']),
                      _buildRow("ملاحظات:", caseData['details']),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
