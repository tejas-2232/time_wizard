import { useState, useEffect } from 'react';
import { View, Text, StyleSheet, TextInput, TouchableOpacity } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { User, Mail, Briefcase } from 'lucide-react-native';

interface UserProfile {
  username: string;
  email?: string;
  company?: string;
}

export default function ProfileScreen() {
  const [profile, setProfile] = useState<UserProfile>({
    username: '',
    email: '',
    company: '',
  });
  const [isEditing, setIsEditing] = useState(false);

  useEffect(() => {
    loadProfile();
  }, []);

  const loadProfile = async () => {
    try {
      const savedProfile = await AsyncStorage.getItem('userProfile');
      if (savedProfile) {
        setProfile(JSON.parse(savedProfile));
      }
    } catch (error) {
      console.error('Error loading profile:', error);
    }
  };

  const saveProfile = async () => {
    try {
      await AsyncStorage.setItem('userProfile', JSON.stringify(profile));
      setIsEditing(false);
    } catch (error) {
      console.error('Error saving profile:', error);
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <View style={styles.avatarContainer}>
          <User size={48} color="#0A84FF" />
        </View>
        <Text style={styles.headerTitle}>
          {profile.username ? `Welcome, ${profile.username}` : 'Create Profile'}
        </Text>
      </View>

      <View style={styles.form}>
        <View style={styles.inputGroup}>
          <User size={20} color="#666" />
          <TextInput
            style={styles.input}
            placeholder="Username"
            value={profile.username}
            onChangeText={(text) => setProfile({ ...profile, username: text })}
            editable={isEditing}
          />
        </View>

        <View style={styles.inputGroup}>
          <Mail size={20} color="#666" />
          <TextInput
            style={styles.input}
            placeholder="Email (optional)"
            value={profile.email}
            onChangeText={(text) => setProfile({ ...profile, email: text })}
            keyboardType="email-address"
            editable={isEditing}
          />
        </View>

        <View style={styles.inputGroup}>
          <Briefcase size={20} color="#666" />
          <TextInput
            style={styles.input}
            placeholder="Company (optional)"
            value={profile.company}
            onChangeText={(text) => setProfile({ ...profile, company: text })}
            editable={isEditing}
          />
        </View>

        {isEditing ? (
          <TouchableOpacity style={styles.saveButton} onPress={saveProfile}>
            <Text style={styles.buttonText}>Save Profile</Text>
          </TouchableOpacity>
        ) : (
          <TouchableOpacity
            style={styles.editButton}
            onPress={() => setIsEditing(true)}
          >
            <Text style={styles.buttonText}>Edit Profile</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    backgroundColor: '#fff',
    padding: 20,
    alignItems: 'center',
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
  },
  avatarContainer: {
    width: 80,
    height: 80,
    backgroundColor: '#f0f0f0',
    borderRadius: 40,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 16,
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: '600',
    color: '#333',
  },
  form: {
    padding: 20,
  },
  inputGroup: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#fff',
    borderRadius: 12,
    paddingHorizontal: 16,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  input: {
    flex: 1,
    paddingVertical: 16,
    paddingHorizontal: 12,
    fontSize: 16,
    color: '#333',
  },
  saveButton: {
    backgroundColor: '#34C759',
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
    marginTop: 20,
  },
  editButton: {
    backgroundColor: '#0A84FF',
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
    marginTop: 20,
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },
});