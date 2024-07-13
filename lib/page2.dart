import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:technical_task/main.dart';
import 'package:technical_task/page3.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  DateTime selectedDate = DateTime.now();
  List<dynamic> activities = [];

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    final response =
        await http.get(Uri.parse('https://api.npoint.io/bc69ae1f6991da81ab9a'));
    if (response.statusCode == 200) {
      setState(() {
        activities = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load activities');
    }
  }

  String _getTimeOfDayLabel(DateTime date) {
    final hour = date.hour;
    if (hour >= 6 && hour < 12) {
      return 'সকাল';
    } else if (hour >= 12 && hour < 15) {
      return 'দুপুর';
    } else if (hour >= 15 && hour < 18) {
      return 'বিকেল';
    } else if (hour >= 18 && hour < 20) {
      return 'সন্ধ্যা';
    } else {
      return 'রাত';
    }
  }

  String _formatTimeWithLeadingZero(DateTime date) {
    final timeFormatter = DateFormat('hh:mm a', 'bn_BD');
    String formattedTime = timeFormatter.format(date);
    formattedTime =
        formattedTime.replaceAll('AM', 'মি.').replaceAll('PM', 'মি.');
    if (formattedTime.startsWith('০')) {
      formattedTime = '০' + formattedTime.substring(1);
    } else if (formattedTime[1] == ':') {
      formattedTime = '০' + formattedTime;
    }
    return formattedTime;
  }

  List<DateTime> generateDates() {
    List<DateTime> dates = [];
    for (int i = -7; i <= 7; i++) {
      dates.add(selectedDate.add(Duration(days: i)));
    }
    return dates;
  }

  String _convertToBangla(String number) {
    const englishToBangla = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };

    String banglaNumber = '';
    for (int i = 0; i < number.length; i++) {
      banglaNumber += englishToBangla[number[i]] ?? number[i];
    }
    return banglaNumber;
  }

  String _getBanglaDayName(DateTime date) {
    final banglaWeekdays = [
      'রবি',
      'সোম',
      'মঙ্গল',
      'বুধ',
      'বৃহঃ',
      'শুক্র',
      'শনি'
    ];
    return banglaWeekdays[date.weekday % 7];
  }

  String _getBanglaDate(DateTime date) {
    return '${_convertToBangla(date.day.toString())}';
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = generateDates();

    return Scaffold(
      appBar: AppBar(
        title: Text('সময়রেখা', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'আজ, ${DateFormat.yMMMMd('bn_BD').format(selectedDate)}',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewPostPage()),
                    );
                  },
                  child: Text('নতুন যোগ করুন'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 33, 148, 37),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  DateTime date = dates[index];
                  bool isSelected = date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Container(
                      width: 50,
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(255, 50, 172, 54)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: isSelected ? Colors.green : Colors.grey),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getBanglaDayName(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            _getBanglaDate(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 35),
            Expanded(
              child: activities.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        var activity = activities[index];
                        var date = DateTime.fromMillisecondsSinceEpoch(
                            int.parse(activity['date']) * 1000);

                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getTimeOfDayLabel(date),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _formatTimeWithLeadingZero(date),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Card(
                                  color: const Color.fromARGB(255, 42, 161, 46),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatTimeWithLeadingZero(date),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          activity['name'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on,
                                                color: Colors.white),
                                            SizedBox(width: 4),
                                            Text(
                                              activity['location'],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: Offset(-13, 6),
              child: IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.black,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: Offset(-21, 0),
              child: IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page2()),
                  );
                },
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: Offset(-12, -40),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 17, 114, 20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.list, color: Colors.black),
              onPressed: () {},
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () {},
            ),
            label: '',
          ),
        ],
        //iconSize: 30,
      ),
    );
  }
}
