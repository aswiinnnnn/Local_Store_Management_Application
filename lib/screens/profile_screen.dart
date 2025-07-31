import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivelocaldb/DB/functions/db_functions.dart';
import 'package:hivelocaldb/DB/model/data_model.dart';
import 'package:hivelocaldb/components/line_chart_widget.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    getAllIncome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile / Income",
          style: TextStyle(
            color: Color(0xFF0C3B2E),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF0C3B2E)),
      ),
      body: ValueListenableBuilder<List<IncomeModel>>(
        valueListenable: incomeListNotifier,
        builder: (context, incomeList, _) {
          if (incomeList.isEmpty) {
            return const Center(child: Text('No income records found.'));
          }

          // ✅ Charts use all incomes
          final allIncomes = incomeList;

          // ✅ List shows only latest 500
          final visibleIncomes = allIncomes.length > 500
              ? allIncomes.sublist(allIncomes.length - 500)
              : allIncomes;

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final weekStart = today.subtract(Duration(days: today.weekday - 1));
          final monthStart = DateTime(now.year, now.month, 1);

          double total = 0;
          double todayTotal = 0;
          double weekTotal = 0;
          double monthTotal = 0;

          Map<String, double> dailyMap = {};
          Map<String, double> weeklyMap = {};
          Map<String, double> monthlyMap = {};

          for (var income in allIncomes) {
            total += income.amount;
            if (isSameDay(income.date, today)) todayTotal += income.amount;
            if (income.date.isAfter(
              weekStart.subtract(const Duration(days: 1)),
            )) {
              weekTotal += income.amount;
            }
            if (income.date.isAfter(
              monthStart.subtract(const Duration(days: 1)),
            )) {
              monthTotal += income.amount;
            }

            final dayKey = DateFormat('yyyy-MM-dd').format(income.date);
            final weekKey = '${income.date.year}-W${weekNumber(income.date)}';
            final monthKey = DateFormat('yyyy-MM').format(income.date);

            dailyMap[dayKey] = (dailyMap[dayKey] ?? 0) + income.amount;
            weeklyMap[weekKey] = (weeklyMap[weekKey] ?? 0) + income.amount;
            monthlyMap[monthKey] = (monthlyMap[monthKey] ?? 0) + income.amount;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalCard(total, todayTotal, weekTotal, monthTotal),
                  const SizedBox(height: 18),

                  // ✅ Tab Charts
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          labelColor: Colors.green[900],
                          unselectedLabelColor: Colors.black54,
                          indicatorColor: Colors.green[900],
                          tabs: const [
                            Tab(text: 'Daily'),
                            Tab(text: 'Weekly'),
                            Tab(text: 'Monthly'),
                          ],
                        ),
                        SizedBox(
                          height: 250,
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              PaginatedIncomeBarChart(
                                dataMap: dailyMap,
                                labelType: 'day',
                              ),
                              PaginatedIncomeBarChart(
                                dataMap: weeklyMap,
                                labelType: 'week',
                              ),
                              PaginatedIncomeBarChart(
                                dataMap: monthlyMap,
                                labelType: 'month',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ✅ Income List (Latest 500)
                  const Text(
                    'Latest 500 Income Records',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visibleIncomes.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, idx) {
                      final income =
                          visibleIncomes[visibleIncomes.length - 1 - idx];
                      return ListTile(
                        leading: Icon(
                          Icons.attach_money,
                          color: Colors.green[800],
                        ),
                        title: Text('₹${income.amount.toStringAsFixed(2)}'),
                        subtitle: Text(
                          'Order ID: ${income.orderId} | ${DateFormat('yyyy-MM-dd').format(income.date)}',
                        ),
                        onTap: () async {
                          final box = await Hive.openBox<OrderModel>(
                            'orders_db',
                          );
                          final order = box.get(income.orderId);
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (_) => Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Order & Income Details',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('Customer: ${order?.name ?? "-"}'),
                                  Text('Product: ${order?.type ?? "-"}'),
                                  Text('Contact: ${order?.contact ?? "-"}'),
                                  Text('Address: ${order?.address ?? "-"}'),
                                  Text('Notes: ${order?.notes ?? "-"}'),
                                  const Divider(),
                                  Text(
                                    'Amount Charged: ₹${income.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Date: ${DateFormat('yyyy-MM-dd').format(income.date)}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalCard(
    double total,
    double todayTotal,
    double weekTotal,
    double monthTotal,
  ) {
    return Card(
      color: Colors.green[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Month',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${monthTotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _incomeStat('Today', todayTotal),
                _incomeStat('This Week', weekTotal),
                _incomeStat('Total Income', total),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _incomeStat(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 2),
        Text(
          '₹${value.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    return ((date.difference(firstMonday).inDays) / 7).ceil();
  }
}
