import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Helper Function
int alphaFromOpacity(double opacity) => (opacity * 255).round();

// Data Models
class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type;
  final String assignedTo;
  final String assignedToImage;
  final Color color;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.assignedTo,
    required this.assignedToImage,
    required this.color,
  });
}

// Dummy Data
final List<Reminder> dummyReminders = [
  Reminder(
    id: '1',
    title: 'Premium Payment Due',
    description: 'Health insurance premium payment for Q2 2023',
    date: DateTime.now().add(Duration(days: 2)),
    type: 'Payment',
    assignedTo: 'John Smith',
    assignedToImage: 'https://randomuser.me/api/portraits/men/11.jpg',
    color: Colors.blue,
  ),
  Reminder(
    id: '2',
    title: 'Policy Renewal',
    description: 'Auto insurance policy renewal',
    date: DateTime.now().add(Duration(days: 7)),
    type: 'Renewal',
    assignedTo: 'Sarah Johnson',
    assignedToImage: 'https://randomuser.me/api/portraits/women/22.jpg',
    color: Colors.green,
  ),
  Reminder(
    id: '3',
    title: 'Document Submission',
    description: 'Submit health checkup documents',
    date: DateTime.now().add(Duration(days: -1)),
    type: 'Document',
    assignedTo: 'Mike Brown',
    assignedToImage: 'https://randomuser.me/api/portraits/men/33.jpg',
    color: Colors.orange,
  ),
  Reminder(
    id: '4',
    title: 'Claim Follow-up',
    description: 'Follow up on pending claim #CL-2023-0456',
    date: DateTime.now().add(Duration(days: 3)),
    type: 'Claim',
    assignedTo: 'Emma Wilson',
    assignedToImage: 'https://randomuser.me/api/portraits/women/44.jpg',
    color: Colors.purple,
  ),
];

// Main Screen
class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders & Calendar'),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.calendarDays),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildUpcomingHeader(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: dummyReminders.length,
              itemBuilder: (context, index) {
                return ReminderCard(reminder: dummyReminders[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: FaIcon(FontAwesomeIcons.plus),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddReminderScreen()),
        ),
      ),
    );
  }

  Widget _buildUpcomingHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.bell, color: Colors.orange),
          SizedBox(width: 12),
          Text(
            'Upcoming Reminders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Reminder Card Widget
class ReminderCard extends StatelessWidget {
  final Reminder reminder;

  const ReminderCard({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReminderDetailsScreen(reminder: reminder),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: reminder.color.withAlpha(alphaFromOpacity(0.1)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      reminder.type,
                      style: TextStyle(
                        color: reminder.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(reminder.date),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                reminder.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                reminder.description,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(reminder.assignedToImage),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Assigned to ${reminder.assignedTo}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  Spacer(),
                  FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else if (difference.inDays < 0) {
      return '${difference.inDays.abs()} days ago';
    } else {
      return 'In ${difference.inDays} days';
    }
  }
}

// Reminder Details Screen
class ReminderDetailsScreen extends StatelessWidget {
  final Reminder reminder;

  const ReminderDetailsScreen({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminder Details')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.type.toUpperCase(),
                      style: TextStyle(
                        color: reminder.color,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      reminder.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.calendar,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _formatDetailedDate(reminder.date),
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.user,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Assigned to ${reminder.assignedTo}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              reminder.description,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.check),
                    label: Text('Mark as Done'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reminder marked as done')),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.penToSquare),
                    label: Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddReminderScreen(reminder: reminder),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDetailedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Calendar Screen
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Insurance Calendar')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'June 2023',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.chevronLeft),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.chevronRight),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildCalendarGrid(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Reminders this month',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...dummyReminders.map(
              (reminder) => ListTile(
                leading: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: reminder.color,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(reminder.title),
                subtitle: Text(_formatDate(reminder.date)),
                trailing: FaIcon(FontAwesomeIcons.chevronRight, size: 14),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReminderDetailsScreen(reminder: reminder),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Table(
      children: [
        TableRow(
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map(
                (day) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        ..._buildCalendarRows(),
      ],
    );
  }

  List<TableRow> _buildCalendarRows() {
    // This is a simplified calendar - in a real app you'd use a package like table_calendar
    List<TableRow> rows = [];
    List<Widget> currentRow = [];

    for (int i = 1; i <= 30; i++) {
      final hasReminder = dummyReminders.any((r) => r.date.day == i);

      currentRow.add(
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.all(4),
            height: 40,
            decoration: BoxDecoration(
              color: hasReminder
                  ? Colors.blue.withAlpha(alphaFromOpacity(0.1))
                  : null,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(i.toString()),
                if (hasReminder)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

      if (i % 7 == 0) {
        rows.add(TableRow(children: [...currentRow]));
        currentRow = [];
      }
    }

    if (currentRow.isNotEmpty) {
      rows.add(TableRow(children: currentRow));
    }

    return rows;
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]}';
  }
}

// Add/Edit Reminder Screen
class AddReminderScreen extends StatefulWidget {
  final Reminder? reminder;

  const AddReminderScreen({super.key, this.reminder});

  @override
  AddReminderScreenState createState() => AddReminderScreenState();
}

class AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _type;
  late DateTime _date;
  late String _assignedTo;

  @override
  void initState() {
    super.initState();
    _title = widget.reminder?.title ?? '';
    _description = widget.reminder?.description ?? '';
    _type = widget.reminder?.type ?? 'Payment';
    _date = widget.reminder?.date ?? DateTime.now().add(Duration(days: 1));
    _assignedTo = widget.reminder?.assignedTo ?? 'John Smith';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'Add Reminder' : 'Edit Reminder'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: InputDecoration(
                  labelText: 'Type',
                  prefixIcon: Icon(Icons.category),
                ),
                items: ['Payment', 'Renewal', 'Document', 'Claim', 'Other']
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _type = value!),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    setState(() => _date = selectedDate);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(_formatDate(_date)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _assignedTo,
                decoration: InputDecoration(
                  labelText: 'Assigned To',
                  prefixIcon: Icon(Icons.person),
                ),
                onSaved: (value) => _assignedTo = value ?? 'John Smith',
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  icon: FaIcon(FontAwesomeIcons.floppyDisk),
                  label: Text('Save Reminder'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reminder saved successfully')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
