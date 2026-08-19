import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/app_session.dart';
import '../theme/wtr_theme.dart';

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(title: const Text('Location')),
      body: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text('Choose your city',
                style: TextStyle(color: p.ink, fontSize: 18, fontWeight: FontWeight.w800)),
          ),
          for (final city in MockData.cities) _cityRow(context, city),
        ],
      ),
    );
  }

  Widget _cityRow(BuildContext context, CityLocation city) {
    final p = paletteOf(context);
    final selected = session.city.id == city.id;
    return InkWell(
      onTap: () {
        session.setCity(city);
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: p.divider)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: p.ink),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(city.name,
                      style: TextStyle(
                          color: p.ink, fontSize: 16, fontWeight: FontWeight.w700)),
                  Text('${city.region} · The Roof',
                      style: TextStyle(color: p.muted, fontSize: 13)),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: p.ink, size: 22)
            else
              Icon(Icons.chevron_right, color: p.muted),
          ],
        ),
      ),
    );
  }
}
