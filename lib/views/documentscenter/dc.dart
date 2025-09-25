import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- MAIN APP ENTRY POINT ---

// --- HELPER FUNCTION FOR OPACITY ---
int alphaFromOpacity(double opacity) {
  final clampedOpacity = opacity.clamp(0.0, 1.0);
  return (clampedOpacity * 255).round();
}

// --- DATA MODELS & ENUMS ---

enum DocumentCategory { idProof, policy, claim, miscellaneous }

class Document {
  final String title;
  final DocumentCategory category;
  final String uploadDate;
  final IconData icon;
  final Color color;

  Document({
    required this.title,
    required this.category,
    required this.uploadDate,
    required this.icon,
    required this.color,
  });
}

// --- SCREEN 1: DOCUMENT CENTER MAIN SCREEN ---

class DocumentCenterScreen extends StatefulWidget {
  const DocumentCenterScreen({super.key});

  @override
  State<DocumentCenterScreen> createState() => DocumentCenterScreenState();
}

class DocumentCenterScreenState extends State<DocumentCenterScreen> {
  final List<Document> _allDocuments = [
    Document(title: "Aadhar Card", category: DocumentCategory.idProof, uploadDate: "15-Jun-2023", icon: FontAwesomeIcons.idCard, color: Colors.blueAccent),
    Document(title: "Health Policy #HLT12345", category: DocumentCategory.policy, uploadDate: "12-Jun-2023", icon: FontAwesomeIcons.fileMedical, color: Colors.green),
    Document(title: "Car Insurance #CAR67890", category: DocumentCategory.policy, uploadDate: "01-May-2023", icon: FontAwesomeIcons.car, color: Colors.orange),
    Document(title: "Claim Form #CLM001", category: DocumentCategory.claim, uploadDate: "20-Jul-2023", icon: FontAwesomeIcons.fileInvoice, color: Colors.redAccent),
    Document(title: "Passport", category: DocumentCategory.idProof, uploadDate: "18-Mar-2023", icon: FontAwesomeIcons.passport, color: Colors.blueAccent),
    Document(title: "Hospital Bill", category: DocumentCategory.claim, uploadDate: "21-Jul-2023", icon: FontAwesomeIcons.receipt, color: Colors.redAccent),
    Document(title: "Renewal Notice", category: DocumentCategory.miscellaneous, uploadDate: "30-Jul-2023", icon: FontAwesomeIcons.bell, color: Colors.purple),
  ];

  List<Document> _filteredDocuments = [];
  DocumentCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _filteredDocuments = _allDocuments;
  }

  void _filterDocuments(DocumentCategory? category) {
    setState(() {
      _selectedCategory = category;
      if (category == null) {
        _filteredDocuments = _allDocuments;
      } else {
        _filteredDocuments = _allDocuments.where((doc) => doc.category == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Center"),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "All your important documents, securely stored in one place.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 20),
          _buildFilterChips(),
          const SizedBox(height: 10),
          Expanded(
            child: _filteredDocuments.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredDocuments.length,
              itemBuilder: (context, index) {
                final document = _filteredDocuments[index];
                return _buildDocumentCard(document);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to an upload screen (placeholder)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadDocumentScreen()),
          );
        },
        label: const Text("Upload"),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildChip("All", null),
          _buildChip("ID Proof", DocumentCategory.idProof, Colors.blueAccent),
          _buildChip("Policies", DocumentCategory.policy, Colors.green),
          _buildChip("Claims", DocumentCategory.claim, Colors.redAccent),
          _buildChip("Other", DocumentCategory.miscellaneous, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildChip(String label, DocumentCategory? category, [Color? color]) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => _filterDocuments(category),
        backgroundColor: Colors.white,
        selectedColor: (color ?? Colors.grey).withAlpha(alphaFromOpacity(0.2)),
        labelStyle: TextStyle(color: isSelected ? (color ?? Colors.black) : Colors.black, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? (color ?? Colors.grey) : Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(Document document) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 13),
      elevation: 3,
      shadowColor: Colors.black.withAlpha(alphaFromOpacity(0.08)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentViewerScreen(document: document),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: document.color.withAlpha(alphaFromOpacity(0.15)),
                child: FaIcon(document.icon, color: document.color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(document.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text("Uploaded: ${document.uploadDate}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.fileCircleXmark, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No Documents Found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            "Try selecting a different category.",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

// --- SCREEN 2: DOCUMENT VIEWER SCREEN (Placeholder) ---

class DocumentViewerScreen extends StatelessWidget {
  final Document document;

  const DocumentViewerScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: document.color.withAlpha(alphaFromOpacity(0.15)),
              child: FaIcon(document.icon, color: document.color, size: 50),
            ),
            const SizedBox(height: 24),
            Text(
              document.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Category: ${document.category.name}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "This is a placeholder for the document view. In a real app, the actual document (PDF, image) would be displayed here.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 3: UPLOAD DOCUMENT SCREEN (Placeholder) ---

class UploadDocumentScreen extends StatelessWidget {
  const UploadDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload New Document'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Select a file to upload",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "You can upload PDFs, JPGs, or PNGs up to 5MB.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.file, size: 16),
              label: const Text('Choose File from Device'),
              onPressed: () {
                // In a real app, this would open a file picker.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File picker functionality goes here.')),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document Uploaded Successfully!')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Upload', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}