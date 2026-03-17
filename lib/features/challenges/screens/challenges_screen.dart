import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final challenges = [
      {
        'title': "Power Hour - Let's do it together",
        'dateTime': 'Wednesday, 12 May · 2:00 PM – 4:00 PM',
        'location': 'Sedra Community',
        'image':
            'assets/images/onboarding_1_bg.png',
      },
      {
        'title': 'Sunset Movement - Evening Energy Stroll',
        'dateTime': 'Friday, May 14 · 6:30 PM – 8:00 PM',
        'location': 'Riyadh Parks',
        'image':
            'assets/images/onboarding_2_bg.png',
      },
      {
        'title': 'Green Friday - Community Sustainability',
        'dateTime': 'Friday, 21 May · 10:00 AM – 6:00 PM',
        'location': 'Central Park',
        'image':
            'assets/images/onboarding_3_bg.png',
      },
      {
        'title': 'Midnight Movement',
        'dateTime': 'Saturday, 22 May · 9:30 PM – 11:00 PM',
        'location': 'Downtown Riyadh',
        'image':
            'assets/images/onboarding_2_bg.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "Let's move together.",
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Challenges list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  final challenge = challenges[index];
                  return _ChallengeCard(
                    title: challenge['title']!,
                    dateTime: challenge['dateTime']!,
                    location: challenge['location']!,
                    imageUrl: challenge['image']!,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/events/details',
                        arguments: {
                          'title': challenge['title'],
                          'description':
                              'We\'re pleased to invite you to take part in ${challenge['title']}. The event features running routes from 1 to 5 km, suitable for different ages and fitness levels, set in a lively, high-energy atmosphere that reflects Riyadh\'s culture of community sports and active living.',
                          'date': challenge['dateTime'],
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String dateTime;
  final String location;
  final String imageUrl;
  final VoidCallback onTap;

  const _ChallengeCard({
    required this.title,
    required this.dateTime,
    required this.location,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              // Background with image
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),
              // Bottom gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF634299).withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title at top right
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        title,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Date and location at bottom
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              dateTime,
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: const Color(0xFFfdfdfd),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}