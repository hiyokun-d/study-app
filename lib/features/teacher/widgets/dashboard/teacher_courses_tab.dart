import 'package:flutter/material.dart';
import '../../../../core/services/tutor_api_service.dart';

class TeacherCoursesTab extends StatefulWidget {
  const TeacherCoursesTab({super.key});

  @override
  State<TeacherCoursesTab> createState() => _TeacherCoursesTabState();
}

class _TeacherCoursesTabState extends State<TeacherCoursesTab> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _filtered = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
    _loadOffers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOffers() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await TutorApiService.instance.getMyOffers();
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (result.success) {
        _offers = result.offers ?? [];
        _filtered = _offers;
      } else {
        _error = result.errorMessage;
      }
    });
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? _offers
          : _offers
              .where((o) =>
                  (o['title']?.toString() ?? '').toLowerCase().contains(query))
              .toList();
    });
  }

  Future<void> _deleteOffer(String offerId) async {
    final result = await TutorApiService.instance.deleteOffer(offerId);
    if (!mounted) return;
    if (result.success) {
      _loadOffers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'Failed to delete offer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3B82F6),
              Color(0xFF93C5FD),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'My Offers',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 24),
              if (_loading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (_error != null)
                Expanded(
                  child: Center(
                    child: Text(_error!,
                        style: const TextStyle(color: Colors.red)),
                  ),
                )
              else if (_filtered.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      _offers.isEmpty
                          ? 'No offers yet. Create your first offer!'
                          : 'No results.',
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadOffers,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        bottom: 40.0,
                      ),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) =>
                          _buildOfferItem(_filtered[index]),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search offers...',
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade400,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildOfferItem(Map<String, dynamic> offer) {
    final title = offer['title']?.toString() ?? 'Untitled';
    final coinsPerHour = offer['coins_per_hour']?.toString() ?? '—';
    final durationRaw = offer['duration_minutes'];
    final duration = durationRaw != null ? '${durationRaw}min' : null;
    final offerId = offer['id']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Color(0xFF4F46E5),
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.toll_rounded,
                        size: 14, color: Color(0xFF6366F1)),
                    const SizedBox(width: 4),
                    Text(
                      '$coinsPerHour coins/hr',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                    if (duration != null) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.timer_outlined,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.grey.shade400),
            onSelected: (value) {
              if (value == 'delete' && offerId.isNotEmpty) {
                _deleteOffer(offerId);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'analytics', child: Text('Analytics')),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete',
                    style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
