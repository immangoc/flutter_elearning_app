import 'package:e_learning/core/theme/app_color.dart';
import 'package:e_learning/models/course.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CertificateWidget extends StatelessWidget {
  final Course course;
  final String studentName;
  final String instructorName;
  final GlobalKey certificateKey;

  const CertificateWidget({
    super.key,
    required this.course,
    required this.studentName,
    required this.instructorName,
    required this.certificateKey,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final certificateWidth = screenSize.width * 0.9;
    final certificateHeight = certificateWidth * 0.85;
    final scale = certificateWidth / 800;
    return RepaintBoundary(
      key: certificateKey,
      child: Container(
        width: certificateWidth,
        height: certificateHeight,
        padding: EdgeInsets.all(20 * scale),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primary, width: 8 * scale),
          borderRadius: BorderRadius.circular(28 * scale),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CERTIFICATE',
              style: TextStyle(
                fontSize: 48 * scale,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 8 * scale,
              ),
            ),
            Text(
              'OF COMPLETION',
              style: TextStyle(
                fontSize: 28 * scale,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
                letterSpacing: 4 * scale,
              ),
            ),
            SizedBox(height: 40 * scale),
            Text(
              'This is to certify that',
              style: TextStyle(fontSize: 24 * scale, color: Colors.grey[600]),
            ),
            SizedBox(height: 20 * scale),
            Text(
              studentName,
              style: TextStyle(
                fontSize: 36 * scale,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20 * scale),
            Text(
              'has successfully completed the course',
              style: TextStyle(fontSize: 20 * scale, color: Colors.grey[600]),
            ),
            SizedBox(height: 20 * scale),
            Text(
              course.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32 * scale,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 30 * scale),
            Text(
              'Completed on ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
              style: TextStyle(fontSize: 18 * scale, color: Colors.grey[600]),
            ),
            SizedBox(height: 40 * scale),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      width: 150 * scale,
                      height: 2 * scale,
                      color: Colors.black,
                    ),
                    SizedBox(height: 8 * scale),
                    Text(
                      instructorName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16 * scale,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Course Instructor',
                      style: TextStyle(
                        fontSize: 14 * scale,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/certificate_seal.png',
                  width: 100 * scale,
                  height: 100 * scale,
                ),
                Column(
                  children: [
                    Container(
                      width: 150 * scale,
                      height: 2 * scale,
                      color: Colors.black,
                    ),
                    SizedBox(height: 8 * scale),
                    Text(
                      'MNGOK EDU',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16 * scale,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Platform Director',
                      style: TextStyle(
                        fontSize: 14 * scale,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
