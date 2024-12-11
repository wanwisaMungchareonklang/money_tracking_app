// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, must_be_immutable, prefer_const_literals_to_create_immutables, prefer_final_fields, avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monney_tracking_project/models/money.dart';
import 'package:monney_tracking_project/models/user.dart';
import 'package:monney_tracking_project/services/call_api.dart';
import 'package:monney_tracking_project/views/supviews/add_expense_ui.dart';
import 'package:monney_tracking_project/views/supviews/add_income_ui.dart';
import 'package:monney_tracking_project/views/supviews/record_ui.dart';

class HomeUi extends StatefulWidget {
  User? user;
  HomeUi({
    this.user,
    super.key,
  });

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  int _currentIndex = 1;
  Uint8List? _imageBytes;
  double _totalBalance = 0.0;
  double _totalExpense = 0.0;
  double _totalIncome = 0.0;
  late List<Widget> _currentSo;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.user?.userImage != null && widget.user!.userImage!.isNotEmpty) {
      _imageBytes = base64Decode(widget.user!.userImage!);
    }
    fetchMoneyList();
    _currentSo = [
      AddIncomeUi(
        user: widget.user,
      ),
      RecordUi(
        user: widget.user,
      ),
      AddExpenseUi(
        user: widget.user,
      ),
    ];
  }

  Future<void> fetchMoneyList() async {
    try {
      List<Money> moneyList = await CallApi.getMoneyAPI(widget.user!.userId);
      setState(() {
        _totalBalance = moneyList.fold(0.0, (sum, item) {
          double amount = item.moneyInOut ?? 0.0;
          return item.moneyType == 1 ? sum + amount : sum - amount;
        });

        _totalExpense = moneyList.fold(0.0, (sum, item) {
          double amount = item.moneyInOut ?? 0.0;
          return item.moneyType == 2 ? sum + amount : sum;
        });

        _totalIncome = moneyList.fold(0.0, (sum, item) {
          double amount = item.moneyInOut ?? 0.0;
          return item.moneyType == 1 ? sum + amount : sum;
        });

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching money list: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CustomPaint(
                painter: CurvedPainter(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              widget.user?.userFullname ?? "Unknown User",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.height * 0.05,
                              backgroundColor:
                                  const Color.fromARGB(255, 8, 3, 74),
                              child: _imageBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.memory(
                                        _imageBytes!,
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                      ),
                                    )
                                  : Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 8, 3, 74),
                                          width: 3,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.person_outline,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _currentSo[_currentIndex],
              ),
            ],
          ),
          Align(
            alignment:
                AlignmentDirectional.topCenter + AlignmentDirectional(0, 0.45),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.5,
                padding: EdgeInsets.all(20),
                color: const Color.fromARGB(255, 10, 0, 36),
                child: Center(
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Column(
                          children: [
                            Stack(
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "ยอดเงินคงเหลือ",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.015,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        _totalBalance.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        fetchMoneyList();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.rotate_left_rounded,
                                      color: Colors.white,
                                    ),
                                    iconSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "ยอดเงินเข้ารวม",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.015,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        _totalIncome.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 2, 178, 35),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "ยอดเงินออกรวม",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.015,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        _totalExpense.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 203, 5, 28),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(
            icon: FontAwesomeIcons.moneyCheckDollar,
            title: 'เงินเข้า',
          ),
          TabItem(
            icon: FontAwesomeIcons.houseChimney,
            title: 'Home',
          ),
          TabItem(
            icon: FontAwesomeIcons.moneyBillWave,
            title: 'เงินออก',
          ), //handHoldingHand
        ],
        backgroundColor: const Color.fromARGB(255, 8, 3, 74),
        curveSize: MediaQuery.of(context).size.width * 0.88,
        // top: -30,
        cornerRadius: 16,
        style: TabStyle.fixed,
        initialActiveIndex: _currentIndex,
        onTap: (value) async {
          setState(() {
            _currentIndex = value;
            fetchMoneyList();
          });
        },
      ),
    );
  }
}

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 8, 3, 74)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
