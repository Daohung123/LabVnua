import 'package:aqedu/features/tuition/controllers/controller_tuition_student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TuitionView extends StatelessWidget {
  const TuitionView({super.key});

  String formatMoney(double value) {
    return NumberFormat('#,###,###.00').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final tuitionList = getFakeTuition();

    double totalRequired = 0;
    double totalPaid = 0;

    for (var item in tuitionList) {
      totalRequired += double.tryParse(item.phaiThu) ?? 0.0;
      totalPaid += double.tryParse(item.daThu) ?? 0.0;
    }

    final totalDebt = totalRequired - totalPaid;

    return Scaffold(
      backgroundColor: const Color(0xfff4f7fa),
      appBar: AppBar(
        backgroundColor: const Color(0xff1f4aa8),
        elevation: 0,
        title: const Text(
          "Tuition fees",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Tổng quan học phí
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff1e1f1c),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tuition fees",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${formatMoney(totalRequired)}vnd",
                    style: const TextStyle(
                      color: Color(0xff86bc4a),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          "Paid",
                          "${formatMoney(totalPaid)}vnd",
                          const Color(0xff86bc4a),
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          "Outstanding",
                          "${formatMoney(totalDebt)}vnd",
                          const Color(0xffd8426e),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff161717),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xff86bc4a),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Bạn đã hoàn tất học phí kỳ này. Hẹn gặp lại kỳ sau!",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Payment history",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xff1a1c3d),
              ),
            ),

            const SizedBox(height: 12),

            ListView.builder(
              itemCount: tuitionList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = tuitionList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.tenHocKy,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1a1c3d),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: const TextStyle(fontSize: 14),
                                children: [
                                  const TextSpan(
                                    text: "Requirement: ",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  TextSpan(
                                    text: formatMoney(double.tryParse(item.phaiThu) ?? 0.0),
                                    style: const TextStyle(
                                      color: Color(0xff86bc4a),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: const TextStyle(fontSize: 14),
                                children: [
                                  const TextSpan(
                                    text: "Collected: ",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  TextSpan(
                                    text: formatMoney(double.tryParse(item.daThu) ?? 0.0),
                                    style: const TextStyle(
                                      color: Color(0xffcc7a50),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 4),

                          const Icon(
                            Icons.play_arrow,
                            size: 16,
                            color: Color(0xff1f4aa8),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
