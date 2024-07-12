import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technical_task/page2.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _paragraphController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDateTime;
  String? _selectedLocation;

  final List<String> _categories = [
    'অনুচ্ছেদ',
    'বাক্য',
    'শব্দ',
  ];
  final List<String> _locations = [
    'ঢাকা',
    'চট্টগ্রাম',
    'রাজশাহী',
    'খুলনা',
    'বরিশাল',
    'সিলেট',
    'রংপুর',
    'ময়মনসিংহ'
  ];

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle,
                    size: 48, color: const Color.fromARGB(255, 36, 161, 40)),
                SizedBox(height: 16),
                Text(
                  'নতুন অনুচ্ছেদ সংরক্ষণ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'আপনার সময়রেখাতে নতুন অনুচ্ছেদ সংরক্ষণ সম্পূর্ণ হয়েছে',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Page2()),
                    );
                  },
                  child: Text('আরও যোগ করুন',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 27, 150, 31),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('নতুন যোগ করুন', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('অনুচ্ছেদ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _paragraphController,
              decoration: InputDecoration(
                hintText: 'অনুচ্ছেদ লিখুন',
                border: OutlineInputBorder(),
                counterText: '৪৫ শব্দ',
              ),
              maxLength: 45,
            ),
            SizedBox(height: 16),
            Text('অনুচ্ছেদের বিভাগ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedCategory,
              hint: Text('অনুচ্ছেদের বিভাগ নির্বাচন করুন'),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
            SizedBox(height: 16),
            Text('তারিখ ও সময়',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 8),
                        Text(
                          _selectedDateTime != null
                              ? DateFormat.yMMMMd('bn')
                                  .format(_selectedDateTime!)
                              : 'নির্বাচন করুন',
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('স্থান',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedLocation,
              hint: Text('নির্বাচন করুন'),
              items: _locations.map((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLocation = newValue!;
                });
              },
            ),
            SizedBox(height: 16),
            Text('অনুচ্ছেদের বিবরণ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                hintText: 'কার্যক্রমের বিবরণ লিখুন',
                border: OutlineInputBorder(),
                counterText: '১২০ শব্দ',
              ),
              maxLength: 120,
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              child:
                  Text('সংরক্ষণ করুন', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
