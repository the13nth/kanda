import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- Data Model for a Premium Plan ---
// This makes managing the data for each card clean and scalable.
class PremiumPlan {
  final String logoUrl;
  final String planName;
  final String coverageType;
  final int rating;
  final int price;
  final List<String> features;
  final List<String> userImageUrls;

  const PremiumPlan({
    required this.logoUrl,
    required this.planName,
    required this.coverageType,
    required this.rating,
    required this.price,
    required this.features,
    required this.userImageUrls,
  });
}

// --- The Main Screen Widget ---
class ComparePremiumsPage extends StatelessWidget {
  const ComparePremiumsPage({super.key});

  // --- Dummy Data Source ---
// --- Dummy Data Source ---
// --- Dummy Data Source ---
  final List<PremiumPlan> premiumPlans = const [
    PremiumPlan(
      logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSd9K20XQYf7lwEJmGCSy_TTzzQQe8FKk6g-w&s', // Cigna SVG
      planName: 'Multi Star Family Health',
      coverageType: 'Coverage',
      rating: 5,
      price: 45,
      features: ['Quick', 'Less Paperwork', '2000+ Partner Hospitals'],
      userImageUrls: [
        'https://randomuser.me/api/portraits/women/68.jpg',
        'https://randomuser.me/api/portraits/men/32.jpg',
        'https://randomuser.me/api/portraits/men/45.jpg',
      ],
    ),
    PremiumPlan(
      logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFW9JUwVHtZEHfubTMb4G8NNzhilnIjZqGSg&s', // Aetna SVG
      planName: 'Multi Star Family Health',
      coverageType: 'Coverage',
      rating: 5,
      price: 45,
      features: ['Quick', 'Less Paperwork', '2000+ Partner Hospitals'],
      userImageUrls: [
        'https://randomuser.me/api/portraits/women/44.jpg',
        'https://randomuser.me/api/portraits/men/60.jpg',
        'https://randomuser.me/api/portraits/women/33.jpg',
      ],
    ),
    PremiumPlan(
      logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcdRJUvlYg35KosH95l02OqZIOYRVAeBDPUw&s',
      planName: 'Premium Plus Plan',
      coverageType: 'Full Coverage',
      rating: 4,
      price: 55,
      features: ['Dental Included', 'Vision Care', '24/7 Support'],
      userImageUrls: [
        'https://randomuser.me/api/portraits/women/65.jpg',
        'https://randomuser.me/api/portraits/men/75.jpg',
        'https://randomuser.me/api/portraits/women/22.jpg',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // This container simulates the phone's frame and background
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F5F3), // Light pinkish-beige background
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const CustomAppBar(),
                  const SizedBox(height: 20),
                  const InfoHeader(),
                  const SizedBox(height: 1),
                  // Use ListView.separated for better performance with many items
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: premiumPlans.length,
                    itemBuilder: (context, index) {
                      return PremiumCard(plan: premiumPlans[index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                  ),
                  const SizedBox(height: 14),
                  const ReferralCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Reusable Widgets ---

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.black,
          radius: 20,
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
        const Text(
          'Compare Premiums',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const FaIcon(FontAwesomeIcons.filter, size: 22),
      ],
    );
  }
}

class InfoHeader extends StatelessWidget {
  const InfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Showing 2 of 56 health insurance plans based on your requirements',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black54, fontSize: 16, height: 1.4),
    );
  }
}

class PremiumCard extends StatelessWidget {
  final PremiumPlan plan;
  const PremiumCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use SVG if the URL points to one, otherwise use standard Image
              Image.network(plan.logoUrl, height: 80, width: 100),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingStars(rating: plan.rating),
                    const SizedBox(height: 4),
                    Text(plan.planName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(plan.coverageType, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Text(
                    '\$${plan.price}',
                    style: const TextStyle(
                      color: Color(0xFFF36A6A),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('mo', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          FeaturesChip(features: plan.features),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explore',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              StackedAvatars(imageUrls: plan.userImageUrls),
            ],
          ),
        ],
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final int rating;
  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        7,
            (index) => Icon(
          Icons.star,
          color: index < rating ? const Color(0xFFF36A6A) : Colors.grey.shade300,
          size: 18,
        ),
      ),
    );
  }
}

class FeaturesChip extends StatelessWidget {
  final List<String> features;
  const FeaturesChip({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDEEE9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: features
            .map((feature) => Text(
          feature,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ))
            .toList(),
      ),
    );
  }
}

class StackedAvatars extends StatelessWidget {
  final List<String> imageUrls;
  const StackedAvatars({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    const double overlap = 15.0;
    return SizedBox(
      height: 30,
      width: (imageUrls.length * (30 - overlap)) + overlap,
      child: Stack(
        children: List.generate(imageUrls.length, (index) {
          return Positioned(
            left: index * (30 - overlap),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 13,
                backgroundImage: NetworkImage(imageUrls[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ReferralCard extends StatelessWidget {
  const ReferralCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Placeholder for the friends image
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/6213/6213799.png',
            width: 100,
            height: 80,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Refer you friends to earn free month',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}