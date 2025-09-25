import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Helper function to convert opacity to an alpha value for colors.
int _alphaFromOpacity(double opacity) => (opacity * 255).round();

// --- Data Models (can be moved to separate files in a real app) ---

class Expert {
  final String name;
  final String category;
  final String imageUrl;

  Expert({required this.name, required this.category, required this.imageUrl});
}

class Blog {
  final String title;
  final String description;
  final String category;
  final String readTime;
  final String imageUrl;

  Blog({
    required this.title,
    required this.description,
    required this.category,
    required this.readTime,
    required this.imageUrl,
  });
}

// --- Main Screen Widget ---

class InsightfulBlogsScreen extends StatelessWidget {
  InsightfulBlogsScreen({super.key});

  // --- Mock Data ---

  final List<Expert> experts = [
    Expert(
        name: 'Dr. Sarah',
        category: 'Health',
        imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&auto=format&fit=crop'
    ),
    Expert(
        name: 'Mike',
        category: 'Automotive',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop'
    ),
    Expert(
        name: 'Robert',
        category: 'Home',
        imageUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400&auto=format&fit=crop'
    ),
    Expert(
        name: 'Emily',
        category: 'Fitness',
        imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&auto=format&fit=crop'
    ),
    Expert(
        name: 'John',
        category: 'Tech',
        imageUrl: 'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=400&auto=format&fit=crop'
    ),
    Expert(
        name: 'Sophia',
        category: 'Travel',
        imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&auto=format&fit=crop'
    ),
    Expert(
        name: 'David',
        category: 'Finance',
        imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop'
    ),
    Expert(
        name: 'Laura',
        category: 'Food',
        imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&auto=format&fit=crop'
    ),
  ];

  final List<Blog> blogs = [
    Blog(
      title: 'Future of Electric Vehicles',
      description: 'Discover how EVs are transforming the automotive industry and what to expect in 2024.',
      category: 'Automotive',
      readTime: '4 min read',
      imageUrl: 'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800&auto=format&fit=crop',
    ),
    Blog(
      title: 'Holistic Wellness Guide',
      description: 'Integrate mind, body and spirit with these ancient and modern wellness practices.',
      category: 'Wellness',
      readTime: '6 min read',
      imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=800&auto=format&fit=crop',
    ),
    Blog(
      title: 'AI Revolution',
      description: 'How artificial intelligence is reshaping industries and our daily lives.',
      category: 'Technology',
      readTime: '5 min read',
      imageUrl: 'https://images.unsplash.com/photo-1677442135136-760c813a743a?w=800&auto=format&fit=crop',
    ),
  ];

  final List<Blog> articles = [
    Blog(
        title: 'Sustainable Living',
        description: '',
        category: '',
        readTime: '',
        imageUrl: 'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=800&auto=format&fit=crop'
    ),
    Blog(
        title: 'Financial Freedom',
        description: '',
        category: '',
        readTime: '',
        imageUrl: 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=800&auto=format&fit=crop'
    ),
    Blog(
        title: 'Digital Nomad Life',
        description: '',
        category: '',
        readTime: '',
        imageUrl: 'https://images.unsplash.com/photo-1506929562872-bb421503ef21?w=800&auto=format&fit=crop'
    ),
  ];


  @override
  Widget build(BuildContext context) {
    const Color _ = Color(0xFF7B2CBF);
    const Color backgroundColor = Color(0xFFF8F9FA);
    const Color textColor = Color(0xFF212529);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () {},
        ),
        title: Text(
          'Insightful Blogs',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontSize: 20
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.bell, color: textColor, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Search Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: SearchBarWidget(),
            ),

            // --- Experts Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpertsSection(experts: experts),
            ),
            const SizedBox(height: 10),

            // --- Insightful Blogs Section ---
            SectionHeader(title: 'Featured Articles', actionText: 'View All'),
            const SizedBox(height: 8),
            BlogsSection(blogs: blogs),
            const SizedBox(height: 10),

            // --- News & Article Section ---
            SectionHeader(title: 'Trending Now', actionText: 'See All'),
            const SizedBox(height: 8),
            ArticleSection(articles: articles),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// --- Reusable and Sectional Widgets ---

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(_alphaFromOpacity(0.08)),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 18, color: Colors.grey),
          hintText: 'Search topics, articles...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          suffixIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7B2CBF).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune_rounded, color: Color(0xFF7B2CBF), size: 18),
          ),
        ),
      ),
    );
  }
}

class ExpertsSection extends StatelessWidget {
  final List<Expert> experts;
  const ExpertsSection({super.key, required this.experts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Experts',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: experts.length,
            itemBuilder: (context, index) {
              final expert = experts[index];
              return Container(
                width: 80,
                margin: EdgeInsets.only(right: index == experts.length - 1 ? 0 : 2),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF7B2CBF),
                            const Color(0xFF7B2CBF).withValues(alpha:0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(expert.imageUrl),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      expert.name,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      expert.category,
                      style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 10
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  const SectionHeader({super.key, required this.title, required this.actionText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212529),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              actionText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF7B2CBF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlogsSection extends StatefulWidget {
  final List<Blog> blogs;
  const BlogsSection({super.key, required this.blogs});

  @override
  State<BlogsSection> createState() => BlogsSectionState();
}

class BlogsSectionState extends State<BlogsSection> {
  int _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 310,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.blogs.length,
            itemBuilder: (context, index) {
              final blog = widget.blogs[index];
              return BlogCard(blog: blog);
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.blogs.length,
                (index) => buildDot(index: index, currentPage: _currentPage),
          ),
        ),
      ],
    );
  }

  Widget buildDot({required int index, required int currentPage}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? const Color(0xFF7B2CBF) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(_alphaFromOpacity(0.08)),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              blog.imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B2CBF).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    blog.category,
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF7B2CBF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  blog.title,
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  blog.description,
                  style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.5
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      blog.readTime,
                      style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B2CBF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B2CBF).withValues(alpha:0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 16
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleSection extends StatelessWidget {
  final List<Blog> articles;
  const ArticleSection({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: articles.length,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          final article = articles[index];
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(article.imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(_alphaFromOpacity(0.1)),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha:0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '5 min read',
                        style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}