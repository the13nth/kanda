import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- Data Model for a Query ---
// This holds the data for each person in the query lists.
class QueryItem {
  final String name;
  final String imageUrl;
  final String type;
  final bool isLocked;

  const QueryItem({
    required this.name,
    required this.imageUrl,
    this.type = 'Car Insurance', // Default value as it's common in the design
    this.isLocked = true,
  });
}


// --- Screen 1: The Main Dashboard Page ---
class QueriesHomePage extends StatelessWidget {
  const QueriesHomePage({super.key});

  // --- Dummy Data ---
  final List<QueryItem> recentQueries = const [
    QueryItem(name: 'Rosie Richardson', imageUrl: 'https://randomuser.me/api/portraits/women/24.jpg'),
    QueryItem(name: 'Courtney Clark', imageUrl: 'https://randomuser.me/api/portraits/women/26.jpg'),
    QueryItem(name: 'Rosie Richardson', imageUrl: 'https://randomuser.me/api/portraits/women/29.jpg'),
    QueryItem(name: 'Courtney Clark', imageUrl: 'https://randomuser.me/api/portraits/women/21.jpg'),
    QueryItem(name: 'Jonathan Harper', imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg'),
  ];

  final List<QueryItem> openedQueries = const [
    QueryItem(name: 'Joshua Lucas', imageUrl: 'https://randomuser.me/api/portraits/men/45.jpg'),
    QueryItem(name: 'Millie Thornton', imageUrl: 'https://randomuser.me/api/portraits/women/50.jpg'),
    QueryItem(name: 'David Cooper', imageUrl: 'https://randomuser.me/api/portraits/men/55.jpg'),
  ];

  // A longer list for the "See All" page
  static final List<QueryItem> allRecentQueries = [
    const QueryItem(name: 'Joshua Lucas', imageUrl: 'https://randomuser.me/api/portraits/men/45.jpg'),
    const QueryItem(name: 'Millie Thornton', imageUrl: 'https://randomuser.me/api/portraits/women/50.jpg'),
    const QueryItem(name: 'Rosie Richardson', imageUrl: 'https://randomuser.me/api/portraits/women/24.jpg'),
    const QueryItem(name: 'Courtney Clark', imageUrl: 'https://randomuser.me/api/portraits/women/26.jpg'),
    const QueryItem(name: 'Jonathan Harper', imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg'),
    const QueryItem(name: 'David Cooper', imageUrl: 'https://randomuser.me/api/portraits/men/55.jpg'),
    const QueryItem(name: 'Sophia Lee', imageUrl: 'https://randomuser.me/api/portraits/women/33.jpg'),
    const QueryItem(name: 'James Wilson', imageUrl: 'https://randomuser.me/api/portraits/men/60.jpg'),

    const QueryItem(name: 'Joshua Lucas', imageUrl: 'https://randomuser.me/api/portraits/men/65.jpg'),
    const QueryItem(name: 'Millie Thornton', imageUrl: 'https://randomuser.me/api/portraits/women/100.jpg'),
    const QueryItem(name: 'Rosie Richardson', imageUrl: 'https://randomuser.me/api/portraits/women/123.jpg'),
    const QueryItem(name: 'Courtney Clark', imageUrl: 'https://randomuser.me/api/portraits/women/143.jpg'),
    const QueryItem(name: 'Jonathan Harper', imageUrl: 'https://randomuser.me/api/portraits/men/123.jpg'),
    const QueryItem(name: 'David Cooper', imageUrl: 'https://randomuser.me/api/portraits/men/176.jpg'),
    const QueryItem(name: 'Sophia Lee', imageUrl: 'https://randomuser.me/api/portraits/women/135.jpg'),
    const QueryItem(name: 'James Wilson', imageUrl: 'https://randomuser.me/api/portraits/men/197.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              children: [
                const HomeHeader(),
                const SizedBox(height: 10),
                const CreditsCard(),
                const SizedBox(height: 12),
                SectionHeader(
                  title: 'Recent Queries',
                  onSeeAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QueriesListPage(
                          title: 'Recent Queries',
                          queries: allRecentQueries,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                QueryList(queries: recentQueries),
                const SizedBox(height: 12),
                SectionHeader(
                  title: 'Opened Queries',
                  onSeeAll: () {
                    // You can navigate to another list or reuse the same one
                  },
                ),
                const SizedBox(height: 10),
                QueryList(queries: openedQueries, isLockedPink: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Screen 2: The Detailed List Page ---
class QueriesListPage extends StatelessWidget {
  final String title;
  final List<QueryItem> queries;

  const QueriesListPage({
    super.key,
    required this.title,
    required this.queries,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.more_horiz, color: Colors.black54),
            ),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: queries.length,
        itemBuilder: (context, index) {
          return QueryListItem(query: queries[index]);
        },
        separatorBuilder: (context, index) => const Divider(height: 20, thickness: 0.5),
      ),
    );
  }
}


// --- Reusable Widgets ---

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Hello Irshad',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue.shade50,
            child: FaIcon(
              FontAwesomeIcons.userTie,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class CreditsCard extends StatelessWidget {
  const CreditsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const FaIcon(FontAwesomeIcons.trophy, color: Color(0xFFFFD700), size: 30),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('400 Credits', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Total Accrued 150', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFF75555),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const SectionHeader({super.key, required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFEE8E8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('SEE ALL', style: TextStyle(color: Color(0xFFF75555), fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ],
    );
  }
}

class QueryList extends StatelessWidget {
  final List<QueryItem> queries;
  final bool isLockedPink;

  const QueryList({super.key, required this.queries, this.isLockedPink = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: queries.length,
      itemBuilder: (context, index) {
        return QueryListItem(query: queries[index], isLockedPink: isLockedPink);
      },
      separatorBuilder: (context, index) => const Divider(height: 20, thickness: 0.5),
    );
  }
}

class QueryListItem extends StatelessWidget {
  final QueryItem query;
  final bool isLockedPink;

  const QueryListItem({super.key, required this.query, this.isLockedPink = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(query.imageUrl),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(query.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(query.type, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
        if (query.isLocked)
          FaIcon(
            FontAwesomeIcons.lock,
            size: 16,
            color: isLockedPink ? const Color(0xFFF75555) : Colors.grey.shade400,
          ),
      ],
    );
  }
}