import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sih_1/providers/report_provider.dart';

class ReportIssueDialog extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  ReportIssueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportIssueProvider>(context);

    return AlertDialog(
      title: const Text('Report an Issue'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Describe the Issue:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the issue description',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Text(
              'Location:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await reportProvider.fetchCurrentLocation(context);
                    _locationController.text = reportProvider.location ?? '';
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: e.toString(),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Use Current Location'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Or enter location manually',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
            ),
            // const SizedBox(height: 16),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () async {
            String description = _descriptionController.text;
            String location = _locationController.text;

            if (description.isNotEmpty && location.isNotEmpty) {
              try {
                await reportProvider.saveIssue(description, location);
                Fluttertoast.showToast(
                  msg: "Thank you for reporting the issue.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
                _descriptionController.clear();
                _locationController.clear();
                Navigator.of(context).pop(); // Close the dialog on success
              } catch (e) {
                Fluttertoast.showToast(
                  msg: "Failed to report the issue, Try Again.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            } else {
              Fluttertoast.showToast(
                msg: "Please fill in all fields.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.orange,
                textColor: Colors.white,
              );
            }
          },
          
          child: const Text('Report',style: TextStyle(color: Colors.black),),
        ),
      ],
    );
  }
}
