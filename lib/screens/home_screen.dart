import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/models/time_entry.dart';
import 'package:timetrack/screens/profile_screen.dart';
import 'package:timetrack/services/sheets_service.dart';
import 'package:timetrack/services/storage_service.dart';
import 'package:timetrack/services/timer_service.dart';
import 'package:timetrack/widgets/timer_display.dart';
import 'package:timetrack/widgets/time_entry_list.dart';
import 'package:timetrack/widgets/task_input_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserProfile();
    });
  }
  
  void _checkUserProfile() {
    final storageService = Provider.of<StorageService>(context, listen: false);
    if (storageService.userProfile == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ProfileScreen(isInitialSetup: true),
        ),
      );
    }
  }
  
  void _onTimerStart() async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (context) => const TaskInputDialog(),
    );
    
    if (result != null) {
      final timerService = Provider.of<TimerService>(context, listen: false);
      timerService.start(
        taskName: result['taskName'],
        projectName: result['projectName'],
      );
    }
  }
  
  void _onTimerStop() async {
    final timerService = Provider.of<TimerService>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);
    final sheetsService = Provider.of<SheetsService>(context, listen: false);
    
    if (storageService.userProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set up your profile first')),
      );
      return;
    }
    
    final timeEntry = timerService.stop(storageService.userProfile!.username);
    await storageService.saveTimeEntry(timeEntry);
    
    // Upload to Google Sheets in background
    sheetsService.uploadTimeEntry(timeEntry).then((success) {
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload: ${sheetsService.lastError}'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => sheetsService.uploadTimeEntry(timeEntry),
            ),
          ),
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);
    final storageService = Provider.of<StorageService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Time Tracker' : 'History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Timer screen
          Column(
            children: [
              const SizedBox(height: 40),
              const TimerDisplay(),
              const SizedBox(height: 40),
              
              // Task info
              if (timerService.currentTaskName != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task: ${timerService.currentTaskName}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (timerService.currentProjectName != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Project: ${timerService.currentProjectName}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              const Spacer(),
              
              // Timer controls
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (timerService.isIdle || timerService.isPaused)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: timerService.isIdle
                              ? _onTimerStart
                              : () => timerService.start(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(timerService.isIdle
                                  ? Icons.play_arrow
                                  : Icons.replay),
                              const SizedBox(width: 8),
                              Text(timerService.isIdle ? 'Start' : 'Resume'),
                            ],
                          ),
                        ),
                      ),
                    if (timerService.isRunning) ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => timerService.pause(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pause),
                              SizedBox(width: 8),
                              Text('Pause'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (timerService.isRunning || timerService.isPaused)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _onTimerStop,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stop),
                              SizedBox(width: 8),
                              Text('Stop'),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          // History screen
          TimeEntryList(entries: storageService.completedEntries),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}