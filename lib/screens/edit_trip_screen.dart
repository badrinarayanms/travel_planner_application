import 'dart:math';
import 'package:flutter/material.dart';
import '../models/trip.dart';

class EditTripScreen extends StatefulWidget {
  final Trip? trip; // Add this line to accept a Trip object

  EditTripScreen({this.trip}); 
  @override
  _EditTripScreenState createState() => _EditTripScreenState();
}

class _EditTripScreenState extends State<EditTripScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1));
  final List<String> _imageUrls = [
    'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y2l0eXxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y2l0eXxlbnwwfHwwfHx8MA%3D%3D',
    'https://thumbs.dreamstime.com/b/city-chicago-20896212.jpg',
    'https://media.istockphoto.com/id/1215791152/photo/moonrise-over-south-central-mumbai-the-financial-capital-of-india-showing-a-glittering.jpg?s=612x612&w=0&k=20&c=vJB6RQMWZ4D9pZ2Kva7QLLBbcAf8SGrRZ-ehCeR76zw=',
    'https://i0.wp.com/travelforawhile.com/wp-content/uploads/2022/01/Verona-Romeo-and-Juliet.jpg?resize=1200%2C800&ssl=1',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi7CHydME7Ji3cLyDeNARaJYXWEvEpToPFDtNIkr1Iu2NGZLlbcBzPgdC8lHvQhvngTUc&usqp=CAU',
    'https://st.depositphotos.com/1035350/2277/i/450/depositphotos_22772802-stock-photo-tokyo-cityscape.jpg'
  ];
  String _getRandomImage() {
    final random = Random();
    return _imageUrls[random.nextInt(_imageUrls.length)];
  }
   @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      // Pre-fill the form fields if a trip is passed
      _name = widget.trip!.name;
      _startDate = widget.trip!.startDate;
      _endDate = widget.trip!.endDate;
       
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: isStartDate ? _startDate : _startDate, 
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final randomImageUrl = widget.trip?.imageUrl;
      final updatedtrip = Trip(
        name: _name,
        startDate: _startDate,
        endDate: _endDate,
        imageUrl: widget.trip!.imageUrl,
      );
      Navigator.pop(context, updatedtrip);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Trip'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Trip Name'),
              initialValue: _name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a trip name';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                      'Start Date: ${_startDate.toLocal().toString().split(' ')[0]}'),
                ),
                TextButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text('Select'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                      'End Date: ${_endDate.toLocal().toString().split(' ')[0]}'),
                ),
                TextButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text('Select'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Update Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
