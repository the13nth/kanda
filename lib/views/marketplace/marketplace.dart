import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/colors.dart';
import '../../widgets/detailstext1.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String _selectedCategory = 'all';
  final List<String> _categories = ['all', 'insurance', 'services', 'products'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _priceFilter = 'all';
  String _ratingFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Marketplace'),
        backgroundColor: AppColors.bgColor,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.buttonColor.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.buttonColor,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Marketplace Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Services
                  const Text1(text1: 'Featured Services', size: 20),
                  const SizedBox(height: 16),
                  _buildFeaturedServices(),
                  const SizedBox(height: 24),

                  // Insurance Products
                  const Text1(text1: 'Insurance Products', size: 20),
                  const SizedBox(height: 16),
                  _buildInsuranceProducts(),
                  const SizedBox(height: 24),

                  // Service Providers
                  const Text1(text1: 'Service Providers', size: 20),
                  const SizedBox(height: 16),
                  _buildServiceProviders(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedServices() {
    final services = [
      {
        'title': 'Roadside Assistance',
        'description': '24/7 emergency roadside help',
        'price': '\$29.99/month',
        'icon': FontAwesomeIcons.truck,
        'color': Colors.orange,
      },
      {
        'title': 'Vehicle Inspection',
        'description': 'Professional vehicle safety check',
        'price': '\$49.99',
        'icon': FontAwesomeIcons.magnifyingGlass,
        'color': Colors.blue,
      },
      {
        'title': 'Towing Service',
        'description': 'Reliable towing to nearest garage',
        'price': '\$89.99',
        'icon': FontAwesomeIcons.truck,
        'color': Colors.red,
      },
    ];

    final filteredServices = _filterServices(services);
    return Column(
      children: filteredServices
          .map((service) => _buildServiceCard(service))
          .toList(),
    );
  }

  Widget _buildInsuranceProducts() {
    final products = [
      {
        'title': 'Comprehensive Auto Insurance',
        'description': 'Full coverage for your vehicle',
        'price': 'From \$120/month',
        'icon': FontAwesomeIcons.shield,
        'color': Colors.green,
      },
      {
        'title': 'Third Party Liability',
        'description': 'Basic coverage for legal requirements',
        'price': 'From \$45/month',
        'icon': FontAwesomeIcons.fileShield,
        'color': Colors.purple,
      },
    ];

    final filteredProducts = _filterServices(products);
    return Column(
      children: filteredProducts
          .map((product) => _buildServiceCard(product))
          .toList(),
    );
  }

  Widget _buildServiceProviders() {
    final providers = [
      {
        'title': 'Auto Repair Shop',
        'description': 'Certified mechanics near you',
        'rating': '4.8',
        'reviews': '1,234 reviews',
        'icon': FontAwesomeIcons.wrench,
        'color': Colors.blue,
      },
      {
        'title': 'Car Wash Service',
        'description': 'Professional car cleaning',
        'rating': '4.6',
        'reviews': '856 reviews',
        'icon': FontAwesomeIcons.droplet,
        'color': Colors.cyan,
      },
      {
        'title': 'Tire Service',
        'description': 'Tire replacement and repair',
        'rating': '4.9',
        'reviews': '2,156 reviews',
        'icon': FontAwesomeIcons.circle,
        'color': Colors.grey,
      },
    ];

    final filteredProviders = _filterServices(providers);
    return Column(
      children: filteredProviders
          .map((provider) => _buildProviderCard(provider))
          .toList(),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (service['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              service['icon'] as IconData,
              color: service['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  service['description'] as String,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  service['price'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _bookService(service);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (provider['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              provider['icon'] as IconData,
              color: provider['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider['description'] as String,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      provider['rating'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      provider['reviews'] as String,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _contactProvider(provider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Contact'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Marketplace'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search services, products...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = _searchController.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price Filter
            const Text(
              'Price Range:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _priceFilter,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Prices')),
                DropdownMenuItem(value: 'low', child: Text('Under \$50')),
                DropdownMenuItem(value: 'medium', child: Text('\$50 - \$100')),
                DropdownMenuItem(value: 'high', child: Text('Over \$100')),
              ],
              onChanged: (value) {
                setState(() {
                  _priceFilter = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            // Rating Filter
            const Text(
              'Minimum Rating:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _ratingFilter,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Ratings')),
                DropdownMenuItem(value: '4.0', child: Text('4.0+ Stars')),
                DropdownMenuItem(value: '4.5', child: Text('4.5+ Stars')),
                DropdownMenuItem(value: '4.8', child: Text('4.8+ Stars')),
              ],
              onChanged: (value) {
                setState(() {
                  _ratingFilter = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _priceFilter = 'all';
                _ratingFilter = 'all';
              });
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterServices(List<Map<String, dynamic>> items) {
    return items.where((item) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final title = (item['title'] as String).toLowerCase();
        final description = (item['description'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!title.contains(query) && !description.contains(query)) {
          return false;
        }
      }

      // Price filter
      if (_priceFilter != 'all') {
        final price = item['price'] as String;
        final priceValue = double.tryParse(
          price.replaceAll(RegExp(r'[^\d.]'), ''),
        );
        if (priceValue != null) {
          switch (_priceFilter) {
            case 'low':
              if (priceValue >= 50) return false;
              break;
            case 'medium':
              if (priceValue < 50 || priceValue > 100) return false;
              break;
            case 'high':
              if (priceValue <= 100) return false;
              break;
          }
        }
      }

      // Rating filter
      if (_ratingFilter != 'all' && item.containsKey('rating')) {
        final rating = double.tryParse(item['rating'] as String);
        final minRating = double.tryParse(_ratingFilter);
        if (rating != null && minRating != null && rating < minRating) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _bookService(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book ${service['title']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: ${service['price']}'),
            const SizedBox(height: 16),
            const Text('Choose booking option:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${service['title']} booked for immediate service',
                        ),
                      ),
                    );
                  },
                  child: const Text('Book Now'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${service['title']} scheduled for later',
                        ),
                      ),
                    );
                  },
                  child: const Text('Schedule'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _contactProvider(Map<String, dynamic> provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact ${provider['title']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rating: ${provider['rating']} ⭐'),
            Text('Reviews: ${provider['reviews']}'),
            const SizedBox(height: 16),
            const Text('Choose contact method:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Calling ${provider['title']}...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Call'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Opening chat with ${provider['title']}...',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
