import 'package:flutter/material.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/section_header.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  final List<Map<String, dynamic>> aboutSections = [
    {
      'icon': '🌱',
      'title': 'Our Mission',
      'content':
          'Nourishing Communities, Reducing Waste\n\nWe bridge the gap between surplus food and those who need it most. Partnering with restaurants and grocers, we rescue quality food for shelters and families - with you as our essential link.',
    },
    // {
    //   'icon': '💚',
    //   'title': 'Your Impact',
    //   'content':
    //       'Every delivery makes a difference:\n\n• Saves 4 kg of food from landfills\n• Provides 10 nutritious meals\n• Reduces 8 kg of CO₂ emissions\n• Brings hope to communities',
    // },
    {
      'icon': '🚚',
      'title': 'Why You Matter',
      'content':
          'As a FoodBridge Hero:\n\n• Enable social responsibility for businesses\n• Support charities to focus on their core work\n• Connect communities through shared humanity\n• Transform logistics into opportunities for good',
    },
    {
      'icon': '✨',
      'title': 'Our Values',
      'content':
          'Sustainability First:\n\n🌍 Environmental Protection\n🤝 Social Responsibility\n🔗 Community Building\n🔍 Transparency & Tracking',
    },
    {
      'icon': '🌟',
      'title': 'Join the Movement',
      'content':
          'Deliver Hope, Drive Change:\n\n• Fight climate change one meal at a time\n• Support local communities in need\n• Be part of a global solution\n• Create smiles with every delivery',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Image.asset("assets/img/btn_back.png", width: 20, height: 20),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('About Us'),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColor.primary.withOpacity(0.1),
                      Colors.transparent
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildSectionCard(aboutSections[index]),
              childCount: aboutSections.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '"Every delivery is a story of hope. Thank you for being the hero in these stories."\n\n🌎 FoodBridge: Where Every Mile Matters',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(Map<String, dynamic> section) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  section['icon'],
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                Text(
                  section['title'],
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              section['content'],
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            if (section['title'] == 'Your Impact')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildImpactChip('4 kg saved', Icons.recycling),
                    _buildImpactChip('10 meals', Icons.restaurant),
                    _buildImpactChip('8 kg CO₂', Icons.eco),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactChip(String text, IconData icon) {
    return Chip(
      backgroundColor: TColor.primary.withOpacity(0.1),
      avatar: Icon(icon, size: 16, color: TColor.primary),
      label: Text(text,
          style: TextStyle(color: TColor.primary, fontSize: 12)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}