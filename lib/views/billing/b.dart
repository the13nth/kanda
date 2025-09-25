// billing_module_screen.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// --- Main App Entry Point ---
void main() {
  runApp(const InsuranceApp());
}

class InsuranceApp extends StatelessWidget {
  const InsuranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance App UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      // The home page now directly leads to our single, all-in-one module screen
      home: BillingModuleScreen(),
    );
  }
}

// --- Data Models (Defined outside the class for clarity) ---
enum PaymentStatus { paid, pending, overdue }

class BillingInfo {
  final String id;
  final String policyHolderName;
  final String policyHolderImageUrl;
  final String policyType;
  final String invoiceNumber;
  final DateTime paymentDate;
  final double amount;
  final PaymentStatus status;
  final String paymentMethod;
  final String receiptUrl;

  BillingInfo({
    required this.id,
    required this.policyHolderName,
    required this.policyHolderImageUrl,
    required this.policyType,
    required this.invoiceNumber,
    required this.paymentDate,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.receiptUrl,
  });
}

// --- Enum to manage which view is visible ---
enum BillingView { list, detail }

// --- The All-in-One Screen Class ---
class BillingModuleScreen extends StatefulWidget {
  const BillingModuleScreen({super.key});

  @override
  State<BillingModuleScreen> createState() => BillingModuleScreenState();
}

class BillingModuleScreenState extends State<BillingModuleScreen> {
  // --- STATE MANAGEMENT ---
  // Controls which view is shown: the list or the detail page.
  BillingView _currentView = BillingView.list;
  // Holds the data for the detail page when an item is selected.
  BillingInfo? _selectedBillingInfo;

  // --- DUMMY DATA ---
  final List<BillingInfo> billingHistory = [
    BillingInfo(
        id: '1',
        policyHolderName: 'Johnathan Doe',
        policyHolderImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        policyType: 'Comprehensive Car Insurance',
        invoiceNumber: 'INV-2023-001',
        paymentDate: DateTime(2023, 10, 25),
        amount: 350.75,
        status: PaymentStatus.paid,
        paymentMethod: 'Credit Card (**** 4242)',
        receiptUrl: 'https://example.com/receipt/1'),
    BillingInfo(
        id: '2',
        policyHolderName: 'Jane Smith',
        policyHolderImageUrl: 'https://randomuser.me/api/portraits/women/22.jpg',
        policyType: 'Family Health Plan',
        invoiceNumber: 'INV-2023-002',
        paymentDate: DateTime(2023, 11, 15),
        amount: 720.50,
        status: PaymentStatus.pending,
        paymentMethod: 'Bank Transfer',
        receiptUrl: 'https://example.com/receipt/2'),
    BillingInfo(
        id: '3',
        policyHolderName: 'Michael Johnson',
        policyHolderImageUrl: 'https://randomuser.me/api/portraits/men/33.jpg',
        policyType: 'Home & Content Insurance',
        invoiceNumber: 'INV-2023-003',
        paymentDate: DateTime(2023, 9, 1),
        amount: 450.00,
        status: PaymentStatus.overdue,
        paymentMethod: 'Credit Card (**** 5890)',
        receiptUrl: 'https://example.com/receipt/3'),
    BillingInfo(
        id: '4',
        policyHolderName: 'Emily Davis',
        policyHolderImageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        policyType: 'Travel Insurance - Europe',
        invoiceNumber: 'INV-2023-004',
        paymentDate: DateTime(2023, 8, 20),
        amount: 120.00,
        status: PaymentStatus.paid,
        paymentMethod: 'PayPal',
        receiptUrl: 'https://example.com/receipt/4'), BillingInfo(
        id: '1',
        policyHolderName: 'Johnathan Doe',
        policyHolderImageUrl: 'https://randomuser.me/api/portraits/men/11.jpg',
        policyType: 'Comprehensive Car Insurance',
        invoiceNumber: 'INV-2023-001',
        paymentDate: DateTime(2023, 10, 25),
        amount: 350.75,
        status: PaymentStatus.paid,
        paymentMethod: 'Credit Card (**** 4242)',
        receiptUrl: 'https://example.com/receipt/1'),
    BillingInfo(
        id: '2',
        policyHolderName: 'Jane Smith',
        policyHolderImageUrl: 'https://randomuser.me/api/portraits/women/22.jpg',
        policyType: 'Family Health Plan',
        invoiceNumber: 'INV-2023-002',
        paymentDate: DateTime(2023, 11, 15),
        amount: 720.50,
        status: PaymentStatus.pending,
        paymentMethod: 'Bank Transfer',
        receiptUrl: 'https://example.com/receipt/2'),
    BillingInfo(
        id: '3',
        policyHolderName: 'Michael Johnson',
        policyHolderImageUrl: 'https://randomuser.me/api/portraits/men/33.jpg',
        policyType: 'Home & Content Insurance',
        invoiceNumber: 'INV-2023-003',
        paymentDate: DateTime(2023, 9, 1),
        amount: 450.00,
        status: PaymentStatus.overdue,
        paymentMethod: 'Credit Card (**** 5890)',
        receiptUrl: 'https://example.com/receipt/3'),
    BillingInfo(
        id: '4',
        policyHolderName: 'Emily Davis',
        policyHolderImageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        policyType: 'Travel Insurance - Europe',
        invoiceNumber: 'INV-2023-004',
        paymentDate: DateTime(2023, 8, 20),
        amount: 120.00,
        status: PaymentStatus.paid,
        paymentMethod: 'PayPal',
        receiptUrl: 'https://example.com/receipt/4'),
  ];

  // --- HELPER FUNCTIONS (as requested) ---
  int _alphaFromOpacity(double opacity) => (opacity * 255).round();

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return Colors.green.shade700;
      case PaymentStatus.pending:
        return Colors.orange.shade800;
      case PaymentStatus.overdue:
        return Colors.red.shade800;
    }
  }

  IconData _getStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return FontAwesomeIcons.solidCircleCheck;
      case PaymentStatus.pending:
        return FontAwesomeIcons.solidClock;
      case PaymentStatus.overdue:
        return FontAwesomeIcons.solidCircleCheck;
    }
  }

  // --- NAVIGATION LOGIC ---
  void _showListView() {
    setState(() {
      _currentView = BillingView.list;
      _selectedBillingInfo = null;
    });
  }

  void _showDetailView(BillingInfo info) {
    setState(() {
      _currentView = BillingView.detail;
      _selectedBillingInfo = info;
    });
  }

  // --- MAIN BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    // WillPopScope handles the Android back button.
    // When on detail view, it goes back to the list instead of exiting the app.
    return PopScope(
      canPop: _currentView != BillingView.detail,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentView == BillingView.detail) {
          _showListView();
        }
      },
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _currentView == BillingView.list
              ? _buildListView()
              : _buildDetailView(),
        ),
      ),
    );
  }

  // --- UI BUILDER: LIST VIEW ---
  Widget _buildListView() {
    return Scaffold(
      key: const ValueKey('ListView'),
      appBar: AppBar(
        title: const Text('Invoice & Billing History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: billingHistory.length,
        itemBuilder: (context, index) {
          final item = billingHistory[index];
          return _buildBillingItemCard(item);
        },
      ),
    );
  }

  Widget _buildBillingItemCard(BillingInfo item) {
    final statusColor = _getStatusColor(item.status);

    return Card(
      elevation: 4.0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 9.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      shadowColor: Colors.black.withAlpha(_alphaFromOpacity(0.1)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () => _showDetailView(item), // State change instead of Navigator.push
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(item.policyHolderImageUrl),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.policyHolderName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4.0),
                    Text(item.policyType,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(_alphaFromOpacity(0.15)),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getStatusIcon(item.status), color: statusColor, size: 12),
                          const SizedBox(width: 6),
                          Text(item.status.name,
                              style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${item.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF0D47A1))),
                  const SizedBox(height: 4.0),
                  Text(DateFormat.yMMMd().format(item.paymentDate),
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- UI BUILDER: DETAIL VIEW ---
  Widget _buildDetailView() {
    // Ensure that selectedBillingInfo is not null before building
    if (_selectedBillingInfo == null) {
      return const Center(child: Text("Error: No item selected."));
    }
    final item = _selectedBillingInfo!;

    return Scaffold(
      key: const ValueKey('DetailView'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _showListView, // Go back to list view
        ),
        title: const Text('Invoice Details'),
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderCard(item),
            const SizedBox(height: 24),
            _buildSummaryCard(item),
            const SizedBox(height: 24),
            _buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BillingInfo item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(item.policyHolderImageUrl)),
            const SizedBox(height: 16),
            Text(item.policyHolderName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(item.policyType,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BillingInfo item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Divider(),
            _buildDetailRow(icon: FontAwesomeIcons.hashtag, label: 'Invoice Number', value: item.invoiceNumber),
            _buildDetailRow(icon: FontAwesomeIcons.solidCalendarDays, label: 'Payment Date', value: DateFormat.yMMMMd().format(item.paymentDate)),
            _buildDetailRow(icon: FontAwesomeIcons.creditCard, label: 'Payment Method', value: item.paymentMethod),
            _buildDetailRow(icon: FontAwesomeIcons.solidCircleCheck, label: 'Status', value: item.status.name, valueColor: _getStatusColor(item.status)),
            const Divider(height: 32),
            _buildDetailRow(icon: FontAwesomeIcons.dollarSign, label: 'Amount Paid', value: '\$${item.amount.toStringAsFixed(2)}', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value, Color? valueColor, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 16),
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: isTotal ? 20 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500, color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    return ElevatedButton.icon(
      icon: const FaIcon(FontAwesomeIcons.download, size: 20),
      label: const Text('DOWNLOAD RECEIPT'),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Downloading receipt... (demo)'),
            backgroundColor: Color(0xFF0D47A1),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1565C0),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}