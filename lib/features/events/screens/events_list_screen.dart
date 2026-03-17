import 'package:flutter/material.dart';
import '../widgets/event_card.dart';

class EventsListScreen extends StatelessWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        'title': "Power Hour - Let's do it together",
        'dateTime': 'Wednesday, 12 May · 2:00 PM – 4:00 PM',
        'location': 'Sedra',
        'image':
            'https://www.figma.com/api/mcp/asset/2dab6fcb-bfd8-4700-8218-daa79c189def',
      },
      {
        'title': 'Sunset Movement - Evening Energy Stroll',
        'dateTime': 'Friday, May 14 · 6:30 PM – 8:00 PM',
        'location': 'Riyadh',
        'image':
            'https://www.figma.com/api/mcp/asset/af722a5c-9044-4320-8081-7881949ec5e5',
      },
      {
        'title': 'Green Friday - Community Sustainability',
        'dateTime': 'Friday, 21 May · 10:00 AM – 6:00 PM',
        'location': 'Central Park',
        'image':
            'https://www.figma.com/api/mcp/asset/cf26da97-a3ce-470c-b51e-19edd54497e4',
      },
      {
        'title': 'Midnight Movement',
        'dateTime': 'Saturday, 22 May · 9:30 PM – 11:00 PM',
        'location': 'Riyadh',
        'image':
            'https://www.figma.com/api/mcp/asset/d7bf4d86-5526-4d98-90fa-687266c87de0',
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status bar placeholder
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '19:27',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.signal_cellular_4_bar,
                                size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Icon(Icons.wifi, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Icon(Icons.battery_full,
                                size: 12, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
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
              // Events list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(
                    title: event['title']!,
                    dateTime: event['dateTime']!,
                    location: event['location']!,
                    imageUrl: event['image']!,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/events/details',
                        arguments: {
                          'title': event['title'],
                          'description': event['dateTime'],
                          'date': event['dateTime'],
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
              // Bottom navigation
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home),
                      color: Colors.white.withValues(alpha: 0.6),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      color: Colors.white.withValues(alpha: 0.6),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.bar_chart),
                      color: Colors.white.withValues(alpha: 0.6),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_events),
                      color: Colors.white.withValues(alpha: 0.6),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.person),
                      color: Colors.white.withValues(alpha: 0.6),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
