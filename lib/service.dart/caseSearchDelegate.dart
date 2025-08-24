import 'package:flutter/material.dart';
import 'package:lawyer_cases_app/screens/case_ditals.dart';
import 'package:lawyer_cases_app/service.dart/db_helper.dart';

class CaseSearchDelegate extends SearchDelegate {
  final DBHelper dbHelper = DBHelper();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map>>(
      future: dbHelper.searchCases(
        "SELECT * FROM cases WHERE "
        "name1 LIKE '%$query%' OR "
        "name2 LIKE '%$query%' OR "
        "case_number LIKE '%$query%' OR "
        "court_name LIKE '%$query%'",
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data!;
        if (results.isEmpty) {
          return const Center(child: Text("لا توجد نتائج"));
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final  caseData = results[index];
            return Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                title: Text("${caseData['name1']} vs ${caseData['name2']}"),
                subtitle: Text(
                    "رقم القضية: ${caseData['case_number']} \nالمحكمة: ${caseData['court_name']}"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CaseDetailsScreen(caseData: caseData),
                      ));
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
