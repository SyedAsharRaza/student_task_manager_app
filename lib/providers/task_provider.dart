import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Stream<QuerySnapshot> getTasks(String userId) {
    return _firestore
        .collection('tasks')
        .doc(userId)
        .collection('userTasks')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<bool> addTask(String userId, String title, String description) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore
          .collection('tasks')
          .doc(userId)
          .collection('userTasks')
          .add({
        'taskTitle': title,
        'taskDescription': description,
        'createdAt': DateTime.now(),
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add task. Try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(String userId, String docId, String title, String description) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore
          .collection('tasks')
          .doc(userId)
          .collection('userTasks')
          .doc(docId)
          .update({
        'taskTitle': title,
        'taskDescription': description,
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update task. Try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(String userId, String docId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore
          .collection('tasks')
          .doc(userId)
          .collection('userTasks')
          .doc(docId)
          .delete();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete task. Try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}