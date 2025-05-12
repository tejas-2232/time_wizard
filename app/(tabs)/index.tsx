import { useState, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Timer, Play, Pause, Square, Clock } from 'lucide-react-native';

interface TimeEntry {
  id: string;
  taskName: string;
  projectName?: string;
  startTime: string;
  endTime?: string;
  duration: number;
}

export default function HomeScreen() {
  const [isRunning, setIsRunning] = useState(false);
  const [time, setTime] = useState(0);
  const [currentTask, setCurrentTask] = useState('');
  const [currentProject, setCurrentProject] = useState('');
  const [timeEntries, setTimeEntries] = useState<TimeEntry[]>([]);
  
  useEffect(() => {
    loadTimeEntries();
  }, []);

  useEffect(() => {
    let interval: NodeJS.Timeout;
    if (isRunning) {
      interval = setInterval(() => {
        setTime((prevTime) => prevTime + 1);
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [isRunning]);

  const loadTimeEntries = async () => {
    try {
      const entries = await AsyncStorage.getItem('timeEntries');
      if (entries) {
        setTimeEntries(JSON.parse(entries));
      }
    } catch (error) {
      console.error('Error loading time entries:', error);
    }
  };

  const formatTime = (seconds: number) => {
    const hrs = Math.floor(seconds / 3600);
    const mins = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;
    return `${hrs.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const startTimer = () => {
    setIsRunning(true);
    setCurrentTask('New Task');
    setCurrentProject('Default Project');
  };

  const pauseTimer = () => {
    setIsRunning(false);
  };

  const stopTimer = async () => {
    setIsRunning(false);
    const newEntry: TimeEntry = {
      id: Date.now().toString(),
      taskName: currentTask,
      projectName: currentProject,
      startTime: new Date(Date.now() - time * 1000).toISOString(),
      endTime: new Date().toISOString(),
      duration: time,
    };

    const updatedEntries = [newEntry, ...timeEntries];
    setTimeEntries(updatedEntries);
    
    try {
      await AsyncStorage.setItem('timeEntries', JSON.stringify(updatedEntries));
      // Here you would also sync with Google Sheets
      syncWithGoogleSheets(newEntry);
    } catch (error) {
      console.error('Error saving time entry:', error);
    }

    setTime(0);
    setCurrentTask('');
    setCurrentProject('');
  };

  const syncWithGoogleSheets = async (entry: TimeEntry) => {
    // Implementation for Google Sheets sync would go here
    console.log('Syncing with Google Sheets:', entry);
  };

  return (
    <View style={styles.container}>
      <View style={styles.timerContainer}>
        <View style={styles.timerDisplay}>
          <Timer size={32} color="#0A84FF" style={styles.timerIcon} />
          <Text style={styles.timerText}>{formatTime(time)}</Text>
        </View>
        
        {currentTask && (
          <View style={styles.taskInfo}>
            <Text style={styles.taskName}>{currentTask}</Text>
            <Text style={styles.projectName}>{currentProject}</Text>
          </View>
        )}

        <View style={styles.controls}>
          {!isRunning ? (
            <TouchableOpacity style={styles.startButton} onPress={startTimer}>
              <Play size={24} color="#fff" />
              <Text style={styles.buttonText}>Start</Text>
            </TouchableOpacity>
          ) : (
            <View style={styles.runningControls}>
              <TouchableOpacity style={styles.pauseButton} onPress={pauseTimer}>
                <Pause size={24} color="#fff" />
                <Text style={styles.buttonText}>Pause</Text>
              </TouchableOpacity>
              <TouchableOpacity style={styles.stopButton} onPress={stopTimer}>
                <Square size={24} color="#fff" />
                <Text style={styles.buttonText}>Stop</Text>
              </TouchableOpacity>
            </View>
          )}
        </View>
      </View>

      <View style={styles.historyContainer}>
        <View style={styles.historyHeader}>
          <Clock size={24} color="#0A84FF" />
          <Text style={styles.historyTitle}>Recent Time Entries</Text>
        </View>
        <ScrollView style={styles.entriesList}>
          {timeEntries.map((entry) => (
            <View key={entry.id} style={styles.entryCard}>
              <Text style={styles.entryTask}>{entry.taskName}</Text>
              <Text style={styles.entryProject}>{entry.projectName}</Text>
              <Text style={styles.entryDuration}>
                {formatTime(entry.duration)}
              </Text>
              <Text style={styles.entryDate}>
                {new Date(entry.startTime).toLocaleDateString()}
              </Text>
            </View>
          ))}
        </ScrollView>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  timerContainer: {
    backgroundColor: '#fff',
    padding: 20,
    alignItems: 'center',
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
  },
  timerDisplay: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 20,
  },
  timerIcon: {
    marginRight: 10,
  },
  timerText: {
    fontSize: 48,
    fontWeight: '600',
    color: '#0A84FF',
  },
  taskInfo: {
    alignItems: 'center',
    marginBottom: 20,
  },
  taskName: {
    fontSize: 18,
    fontWeight: '600',
    color: '#333',
  },
  projectName: {
    fontSize: 14,
    color: '#666',
    marginTop: 4,
  },
  controls: {
    flexDirection: 'row',
    justifyContent: 'center',
    width: '100%',
  },
  startButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#34C759',
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 12,
  },
  runningControls: {
    flexDirection: 'row',
    gap: 16,
  },
  pauseButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FF9500',
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 12,
  },
  stopButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FF3B30',
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 12,
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 8,
  },
  historyContainer: {
    flex: 1,
    padding: 20,
  },
  historyHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  historyTitle: {
    fontSize: 20,
    fontWeight: '600',
    marginLeft: 8,
  },
  entriesList: {
    flex: 1,
  },
  entryCard: {
    backgroundColor: '#fff',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  entryTask: {
    fontSize: 16,
    fontWeight: '600',
    color: '#333',
  },
  entryProject: {
    fontSize: 14,
    color: '#666',
    marginTop: 4,
  },
  entryDuration: {
    fontSize: 14,
    color: '#0A84FF',
    fontWeight: '500',
    marginTop: 8,
  },
  entryDate: {
    fontSize: 12,
    color: '#999',
    marginTop: 4,
  },
});