// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DiagnosisHistoryScreen extends StatelessWidget {
//   const DiagnosisHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('진단 기록',
//             style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(FirebaseAuth.instance.currentUser?.uid)
//             .collection('diagnoses')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('진단 기록이 없습니다.'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final doc = snapshot.data!.docs[index];
//               final data = doc.data() as Map<String, dynamic>;
//               final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
//               final imageUrl = data['imageUrl'] as String?;
//               final riskLevel = data['risk_level'] as String? ?? '정보 없음';
//               final probability = data['melanoma_probability'] as String? ?? '정보 없음';

//               return Card(
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: InkWell(
//                   onTap: () => _showDiagnosisDetail(context, data),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                       children: [
//                         if (imageUrl != null)
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               imageUrl,
//                               width: 80,
//                               height: 80,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Container(
//                                 width: 80,
//                                 height: 80,
//                                 color: Colors.grey[300],
//                                 child: const Icon(Icons.error),
//                               ),
//                             ),
//                           ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 timestamp?.toString() ?? '날짜 정보 없음',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text('위험도: $riskLevel'),
//                               Text('확률: $probability'),
//                             ],
//                           ),
//                         ),
//                         const Icon(Icons.chevron_right),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _showDiagnosisDetail(BuildContext context, Map<String, dynamic> data) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('상세 진단 결과'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (data['imageUrl'] != null)
//                 Image.network(
//                   data['imageUrl'],
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     height: 200,
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.error),
//                   ),
//                 ),
//               const SizedBox(height: 16),
//               Text('위험도: ${data['risk_level'] ?? '정보 없음'}',
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               Text('확률: ${data['melanoma_probability'] ?? '정보 없음'}'),
//               const SizedBox(height: 8),
//               Text('평가: ${data['assessment'] ?? '정보 없음'}'),
//               if (data['notice'] != null) ...[
//                 const SizedBox(height: 16),
//                 const Text('주의사항:', 
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 ...(data['notice'] as List<dynamic>).map((note) =>
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text('• $note'),
//                     ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('닫기'),
//           ),
//         ],
//       ),
//     );
//   }
// }