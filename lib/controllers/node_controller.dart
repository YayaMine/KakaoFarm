import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NodeController {
  List<String> _farmNodes = [];
  int? _selectedIndex;
  Map<String, Map<String, dynamic>> _farmDataMap = {};

  List<String> get farmNodes => _farmNodes;
  int? get selectedIndex => _selectedIndex;
  Map<String, Map<String, dynamic>> get farmDataMap => _farmDataMap;

  Function? onNodesUpdated;
  Function? onSelectedIndexUpdated;
  Function? onFarmDataUpdated;
  Function(bool)? onLoadingChanged;

  NodeController({
    this.onNodesUpdated,
    this.onSelectedIndexUpdated,
    this.onFarmDataUpdated,
    this.onLoadingChanged,
  });

  Future<void> loadFarmNodes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedNodes = prefs.getStringList('farmNodes');
    int? savedSelectedIndex = prefs.getInt('selectedIndex');

    if (savedNodes != null && savedNodes.isNotEmpty) {
      _farmNodes = savedNodes;
      if (savedSelectedIndex != null &&
          savedSelectedIndex < _farmNodes.length) {
        _selectedIndex = savedSelectedIndex;
      } else {
        _selectedIndex = null;
      }
      onNodesUpdated?.call();
      onSelectedIndexUpdated?.call();

      for (String node in _farmNodes) {
        await fetchFarmData(node);
      }
    }
  }

  Future<void> _saveFarmNodes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('farmNodes', _farmNodes);
  }

  Future<void> _saveSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedIndex != null) {
      await prefs.setInt('selectedIndex', _selectedIndex!);
    } else {
      await prefs.remove('selectedIndex');
    }
  }

  Future<void> fetchFarmData(String node) async {
    onLoadingChanged?.call(true);
    try {
      final ref = FirebaseDatabase.instance.ref(node);
      final snapshot = await ref.get();

      if (snapshot.exists) {
        Map<String, dynamic> data = Map<String, dynamic>.from(
          snapshot.value as Map,
        );
        _farmDataMap[node] = data;
      } else {
        _farmDataMap[node] = {};
      }
      onFarmDataUpdated?.call();
    } catch (e) {
      _farmDataMap[node] = {'error': 'Failed to fetch data'};
      onFarmDataUpdated?.call();
    } finally {
      onLoadingChanged?.call(false);
    }
  }

  void addNode(String newNode) {
    if (newNode.isNotEmpty && !_farmNodes.contains(newNode)) {
      _farmNodes.add(newNode);
      _saveFarmNodes();
      fetchFarmData(newNode);
      setSelectedIndex(_farmNodes.indexOf(newNode));
      onNodesUpdated?.call();
    }
  }

  void deleteNode(int index) {
    String node = _farmNodes[index];
    _farmNodes.removeAt(index);
    _farmDataMap.remove(node);
    if (_selectedIndex != null) {
      if (_farmNodes.isEmpty) {
        _selectedIndex = null;
      } else if (_selectedIndex! >= _farmNodes.length) {
        _selectedIndex = _farmNodes.length - 1;
      }
    }
    _saveFarmNodes();
    _saveSelectedIndex();
    onNodesUpdated?.call();
    onSelectedIndexUpdated?.call();
    onFarmDataUpdated?.call();
  }

  void setSelectedIndex(int? index) {
    _selectedIndex = index;
    _saveSelectedIndex();
    onSelectedIndexUpdated?.call();
  }

  String getField(String node, String key) {
    if (_farmDataMap[node] == null) return "-";
    return _farmDataMap[node]![key]?.toString() ?? "-";
  }
}
