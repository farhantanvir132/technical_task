import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:technical_task/page2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
      'bn_BD', null); // Initialize the Bangla locale data
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double percent = 0.0;
  int remainingYears = 0;
  int remainingMonths = 0;
  int remainingDays = 0;
  int passedMonths = 0;
  int passedDays = 0;
  @override
  void initState() {
    super.initState();
    _calculateTime();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        percent = (passedMonths * 30 + passedDays) /
            ((remainingYears * 12 + remainingMonths + passedMonths) * 30 +
                remainingDays +
                passedDays); // Set the final percent value
      });
    });
  }

  void _calculateTime() {
    DateTime contractStartDate = DateTime(2024, 1, 1);
    DateTime contractEndDate = DateTime(2030, 1, 31);
    DateTime currentDate = DateTime.now();

    Duration passedDuration = currentDate.difference(contractStartDate);
    Duration remainingDuration = contractEndDate.difference(currentDate);

    setState(() {
      remainingYears = remainingDuration.inDays ~/ 365;
      remainingMonths = (remainingDuration.inDays % 365) ~/ 30;
      remainingDays = (remainingDuration.inDays % 365) % 30;

      passedMonths = passedDuration.inDays ~/ 30;
      passedDays = passedDuration.inDays % 30;
    });
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

  final List<IconData> icons = [
    Icons.account_box_outlined,
    Icons.account_balance_outlined,
    Icons.accessible_rounded,
    Icons.apartment_rounded,
    Icons.insert_drive_file_outlined,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 30, // Set the width of the avatar
              height: 30, // Set the height of the avatar
              decoration: BoxDecoration(
                shape: BoxShape.rectangle, // Use rectangle shape
                image: DecorationImage(
                  image: AssetImage(
                      'images/demo.jpg'), // Replace with your avatar image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
                width: 10), // Adjust the space between the avatar and the text
            Text('Flutter Task', style: TextStyle(color: Colors.black)),
          ],
        ),
        backgroundColor: Colors.white,
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Adjust the radius as needed
              ),
              child: Container(
                height: 110, // Adjust the height as needed
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0), // Add top padding
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('images/profile.png'),
                      backgroundColor: Colors.grey[200],
                      radius: 40,
                    ),
                    title: Text('ফারহান তানভীর',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text('সফটবিডি লিমিটেড\nঢাকা',
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 55.0,
                      lineWidth: 10.0,
                      percent: percent,
                      center: Text(
                          '${_convertToBangla(passedMonths.toString())} মাস ${_convertToBangla(passedDays.toString())} দিন',
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                      progressColor: Color.fromARGB(255, 24, 133, 28),
                      animation: true, // Enable animation
                      animationDuration: 2000, // Duration in milliseconds
                    ),
                    SizedBox(height: 10),
                    Text('সময় অতিবাহিত',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('মেয়াদকাল',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.black),
                        SizedBox(width: 4),
                        Text('১ই জানুয়ারি ২০২৪ - ৩১ই জানুয়ারি ২০৩০',
                            style:
                                TextStyle(fontSize: 10, color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('আরও বাকি',
                        style: TextStyle(color: Colors.red, fontSize: 16)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildTimeCard(remainingYears ~/ 10),
                        buildTimeCard(remainingYears % 10),
                        SizedBox(width: 7),
                        buildTimeCard(remainingMonths ~/ 10),
                        buildTimeCard(remainingMonths % 10),
                        SizedBox(width: 7),
                        buildTimeCard(remainingDays ~/ 10),
                        buildTimeCard(remainingDays % 10),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 15),
                        Text('বছর',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                        SizedBox(width: 40), // Spacer between labels
                        Text('মাস',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                        SizedBox(width: 40), // Spacer between labels
                        Text('দিন',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 40, color: Colors.grey),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(6, (index) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icons[index],
                            size: 50,
                            color: const Color.fromARGB(255, 49, 165, 53)),
                        Text('মেনু নং 0000${index + 1}'),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: Offset(-13, 6), // Move the icon 10 pixels down
              child: IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.black,
                  size: 32,
                ),
                onPressed: () {
                  // Handle home icon press
                  setState(() {
                    // Your logic here
                  });
                },
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: Offset(-21, 0), // Move the icon 10 pixels down
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
              offset: Offset(-12, -40), // Adjust the offset value as needed
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
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
              onPressed: () {
                // Handle list icon press
                setState(() {
                  // Your logic here
                });
              },
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () {
                // Handle person icon press
                setState(() {
                  // Your logic here
                });
              },
            ),
            label: '',
          ),
        ],
        //iconSize: 30,
      ),
    );
  }

  Widget buildTimeCard(int time) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            _convertToBangla(time.toString()),
            style: TextStyle(
              fontSize: 18,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
