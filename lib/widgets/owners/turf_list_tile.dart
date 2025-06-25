import 'package:flutter/material.dart';
import '../../models/common/turf_model.dart';


class TurfListTile extends StatelessWidget {
  final TurfModel turf;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TurfListTile({
    super.key,
    required this.turf,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      elevation: 2,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            turf.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (ctx, error, stackTrace) => const Icon(Icons.image_not_supported),
          ),
        ),
        title: Text(turf.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${turf.location}\n₹${turf.pricePerHour}/hour'),
        isThreeLine: true,
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
