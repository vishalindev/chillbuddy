import 'package:buddy_talk/features/profile/presentation/providers/profile_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spots = [12, 18, 21, 33, 24, 40, 35];
    final profile = context.watch<ProfileProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: Text(profile.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(profile.bio),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            title: Text('Following / Followers'),
            trailing: Text('128 / 211', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Weekly Practice Minutes'),
                const SizedBox(height: 14),
                SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: Theme.of(context).colorScheme.secondary,
                          spots: [for (int i = 0; i < spots.length; i++) FlSpot(i.toDouble(), spots[i].toDouble())],
                        ),
                      ],
                      titlesData: const FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, getTitlesWidget: _dayTitle),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Location & Place', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Place: ${profile.place}'),
                Text('State: ${profile.state}'),
                Text('Country: ${profile.country}'),
                Text('Mobile map data: ${profile.mapData}'),
                if (profile.locationError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(profile.locationError!, style: const TextStyle(color: Colors.redAccent)),
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: profile.loadingLocation ? null : () => context.read<ProfileProvider>().fetchCurrentLocationDetails(),
                  icon: const Icon(Icons.my_location),
                  label: Text(profile.loadingLocation ? 'Fetching location...' : 'Fetch Place/State from Map Data'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.emoji_events, color: Colors.amber),
            title: Text('Best Streak'),
            trailing: Text('14 days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  static Widget _dayTitle(double value, TitleMeta meta) {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final idx = value.toInt();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(idx >= 0 && idx < days.length ? days[idx] : ''),
    );
  }
}
