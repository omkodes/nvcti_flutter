// lib/presentation/screens/club_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvcti/bloc/bloc/club_detail_bloc.dart';
import 'package:nvcti/bloc/events/club_detail_event.dart';
import 'package:nvcti/bloc/states/club_detail_state.dart';
import 'package:nvcti/data/datasources/remote_datasource/club_detail_remote_data_source.dart';
import 'package:nvcti/data/repositories/club_detail_repository_impl.dart';
import 'package:nvcti/domain/entities/club_detail.dart';
import 'package:nvcti/domain/usecases/get_club_detail.dart';
import 'package:nvcti/presentation/common/loading_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ClubDetailScreen extends StatelessWidget {
  final String clubId;

  const ClubDetailScreen({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    final dataSource = ClubDetailRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );
    final repository = ClubDetailRepositoryImpl(remoteDataSource: dataSource);
    final useCase = GetClubDetail(repository);

    return BlocProvider(
      create: (_) =>
          ClubDetailBloc(getClubDetail: useCase)
            ..add(LoadClubDetailEvent(clubId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<ClubDetailBloc, ClubDetailState>(
          builder: (context, state) {
            if (state is ClubDetailLoading || state is ClubDetailInitial) {
              return const Center(child: LoadingCard());
            }
            if (state is ClubDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is ClubDetailLoaded) {
              return _ClubDetailBody(club: state.club);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BODY
// ─────────────────────────────────────────────

class _ClubDetailBody extends StatefulWidget {
  final ClubDetail club;
  const _ClubDetailBody({required this.club});

  @override
  State<_ClubDetailBody> createState() => _ClubDetailBodyState();
}

class _ClubDetailBodyState extends State<_ClubDetailBody>
    with SingleTickerProviderStateMixin {
  // Ordered list of all possible year labels (must match ClubDetailModel)
  static const _allYears = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year (Final Year)',
    '5th Year (Super Final)',
  ];

  late final List<String> _availableYears;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Only show tabs for years that actually have members
    _availableYears = _allYears
        .where((y) => widget.club.members.any((m) => m.year == y))
        .toList();
    _tabController = TabController(
      length: _availableYears.isEmpty ? 1 : _availableYears.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  List<ClubMember> _membersForYear(String year) =>
      widget.club.members.where((m) => m.year == year).toList();

  double _memberListHeight() {
    if (_availableYears.isEmpty) return 0;
    final max = _availableYears
        .map((y) => _membersForYear(y).length)
        .reduce((a, b) => a > b ? a : b);
    return (max * 52.0 + 32).clamp(100, 520);
  }

  bool _hasSocialLinks() {
    final c = widget.club;
    return c.websiteUrl.isNotEmpty ||
        c.linkedinUrl.isNotEmpty ||
        c.instagramUrl.isNotEmpty ||
        c.email.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final club = widget.club;

    return CustomScrollView(
      slivers: [
        // ── App bar ──────────────────────────────
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: const Color(0xFF1565C0),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Club',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Banner image
                club.bannerUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: club.bannerUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) =>
                            Container(color: Colors.black87),
                      )
                    : Container(color: Colors.black87),

                // Gradient overlay
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),

                // Teal accent bar at bottom of banner
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(height: 4, color: const Color(0xFF26C6DA)),
                ),

                // Club logo
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: _ClubLogo(logoUrl: club.logoUrl),
                ),
              ],
            ),
          ),
        ),

        // ── Body content ─────────────────────────
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Club name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  club.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  club.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Key Members card
              _buildKeyMembers(club),

              const SizedBox(height: 24),

              // Recent Projects
              if (club.projects.isNotEmpty) ...[
                _buildRecentProjects(club.projects),
                const SizedBox(height: 24),
              ],

              // Members list with year tabs
              if (_availableYears.isNotEmpty) _buildMembersList(),

              // Social links
              if (_hasSocialLinks()) _buildSocialLinks(club),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  // ── Key Members ──────────────────────────────

  Widget _buildKeyMembers(ClubDetail club) {
    final rows = [
      _LabelValue('FIC', club.fic),
      _LabelValue('Co-FIC', club.coFic),
      _LabelValue('Coordinator', club.coordinator),
      _LabelValue('Tech Coordinator', club.techCoordinator),
    ].where((r) => r.value.isNotEmpty).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Members',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: rows.map((r) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(
                          r.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          r.value,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Recent Projects ──────────────────────────

  Widget _buildRecentProjects(List<ClubProject> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent Projects',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: projects.length,
            itemBuilder: (_, i) => _ProjectCard(project: projects[i]),
          ),
        ),
      ],
    );
  }

  // ── Members list with year tabs ───────────────

  Widget _buildMembersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Text(
            'Club Members',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: const Color(0xFF1565C0),
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            indicatorColor: const Color(0xFF1565C0),
            indicatorWeight: 2,
            tabs: _availableYears
                .map((y) => Tab(text: y.toUpperCase()))
                .toList(),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE0E0E0)),
        SizedBox(
          height: _memberListHeight(),
          child: TabBarView(
            controller: _tabController,
            children: _availableYears.map((year) {
              final members = _membersForYear(year);
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: members.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                itemBuilder: (_, i) {
                  final m = members[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: Row(
                      children: [
                        // Avatar with initials
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(
                            0xFF1565C0,
                          ).withOpacity(0.1),
                          child: Text(
                            m.studentName.isNotEmpty
                                ? m.studentName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name + Student ID
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.studentName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                m.studentID,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Social links ─────────────────────────────

  Widget _buildSocialLinks(ClubDetail club) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (club.websiteUrl.isNotEmpty)
            _SocialIcon(
              icon: Icons.language,
              color: const Color(0xFF26C6DA),
              onTap: () => _launch(club.websiteUrl),
            ),
          if (club.linkedinUrl.isNotEmpty)
            _SocialIcon(
              icon: Icons.work_outline,
              color: const Color(0xFF0A66C2),
              onTap: () => _launch(club.linkedinUrl),
            ),
          if (club.instagramUrl.isNotEmpty)
            _SocialIcon(
              icon: Icons.camera_alt_outlined,
              color: const Color(0xFFE1306C),
              onTap: () => _launch(club.instagramUrl),
            ),
          if (club.email.isNotEmpty)
            _SocialIcon(
              icon: Icons.email_outlined,
              color: const Color(0xFF26C6DA),
              onTap: () => _launch('mailto:${club.email}'),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE SMALL WIDGETS
// ─────────────────────────────────────────────

class _ClubLogo extends StatelessWidget {
  final String logoUrl;
  const _ClubLogo({required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(3),
      child: ClipOval(
        child: logoUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: logoUrl,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.groups, size: 36, color: Colors.grey),
              )
            : const Icon(Icons.groups, size: 36, color: Colors.grey),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ClubProject project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail on the left
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 72,
              height: double.infinity,
              child: project.imgUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: project.imgUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.precision_manufacturing_outlined,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ),
                    )
                  : Container(
                      color: const Color(0xFFEEF2FF),
                      child: const Icon(
                        Icons.precision_manufacturing_outlined,
                        color: Color(0xFF1565C0),
                        size: 28,
                      ),
                    ),
            ),
          ),

          // Title + description on the right
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      project.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PRIVATE HELPER
// ─────────────────────────────────────────────

class _LabelValue {
  final String label;
  final String value;
  const _LabelValue(this.label, this.value);
}
