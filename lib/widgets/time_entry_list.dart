import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/models/time_entry.dart';
import 'package:timetrack/services/sheets_service.dart';
import 'package:timetrack/services/storage_service.dart';
import 'package:timetrack/theme/app_theme.dart';

class TimeEntryList extends StatelessWidget {
  final List<TimeEntry> entries;
  
  const TimeEntryList({
    super.key, 
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No time entries yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your time to see your history',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    final sortedEntries = List<TimeEntry>.from(entries)
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
    
    return Column(
      children: [
        if (entries.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                final sheetsService = Provider.of<SheetsService>(context, listen: false);
                sheetsService.uploadTimeEntries(entries).then((success) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All entries uploaded successfully'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to upload: ${sheetsService.lastError}'),
                        action: SnackBarAction(
                          label: 'Retry',
                          onPressed: () => sheetsService.uploadTimeEntries(entries),
                        ),
                      ),
                    );
                  }
                });
              },
              icon: const Icon(Icons.upload),
              label: const Text('Upload All to Google Sheets'),
            ),
          ),
        
        Expanded(
          child: ListView.builder(
            itemCount: sortedEntries.length,
            itemBuilder: (context, index) {
              final entry = sortedEntries[index];
              return Dismissible(
                key: Key(entry.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  final storageService = Provider.of<StorageService>(
                    context, 
                    listen: false,
                  );
                  storageService.deleteTimeEntry(entry.id);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Time entry deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          storageService.saveTimeEntry(entry);
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16, 
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                entry.taskName ?? 'Untitled Task',
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              entry.formattedDuration,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (entry.projectName != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Project: ${entry.projectName}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.formattedStartTime,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.neutral500,
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}