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
import 'package:nvcti/presentation/common/theme.dart';
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

class _ClubDetailBody extends StatelessWidget {
  final ClubDetail club;
  const _ClubDetailBody({required this.club});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  bool _hasSocialLinks() =>
      club.websiteUrl.isNotEmpty ||
      club.linkedinUrl.isNotEmpty ||
      club.instagramUrl.isNotEmpty ||
      club.email.isNotEmpty;

  void _showMembersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MembersBottomSheet(members: club.members),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Collapsible App Bar ───────────────────
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
                // Banner with gradient fallback
                club.bannerUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: club.bannerUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) =>
                            _BannerFallback(clubName: club.name),
                      )
                    : _BannerFallback(clubName: club.name),

                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(height: 4, color: const Color(0xFF26C6DA)),
                ),

                Positioned(
                  bottom: 12,
                  left: 16,
                  child: _ClubLogo(logoUrl: club.logoUrl),
                ),
              ],
            ),
          ),
        ),

        // ── Scrollable content ────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  club.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  club.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Key Members
                _buildKeyMembers(context),

                const SizedBox(height: 24),

                // Recent Projects
                if (club.projects.isNotEmpty) ...[
                  _buildRecentProjects(),
                  const SizedBox(height: 24),
                ],

                // Members button → opens bottom sheet
                if (club.members.isNotEmpty) ...[
                  _buildMembersButton(context),
                  const SizedBox(height: 32),
                ],

                // Social links with real image assets
                if (_hasSocialLinks()) _buildSocialLinks(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Key Members card ─────────────────────────

  Widget _buildKeyMembers(BuildContext context) {
    final rows = [
      _LabelValue('FIC', club.fic),
      _LabelValue('Co-FIC', club.coFic),
      _LabelValue('Coordinator', club.coordinator),
      _LabelValue('Tech Coordinator', club.techCoordinator),
    ].where((r) => r.value.isNotEmpty).toList();

    if (rows.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Members',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkInputFill : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppTheme.darkDivider : Colors.grey.shade200,
            ),
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
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[300] : Colors.black87,
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
    );
  }

  // ── Recent Projects horizontal list ──────────

  Widget _buildRecentProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Projects',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: club.projects.length,
            itemBuilder: (_, i) => _ProjectCard(project: club.projects[i]),
          ),
        ),
      ],
    );
  }

  // ── Members button ────────────────────────────

  Widget _buildMembersButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _showMembersSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkInputFill : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppTheme.darkDivider : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.people_alt_outlined,
                color: Color(0xFF1565C0),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Club Members',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF1565C0),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ── Social links ─────────────────────────────

  Widget _buildSocialLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Connect With Us',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (club.websiteUrl.isNotEmpty)
              _SocialImageIcon(
                assetPath: 'assets/logos/ic_website.png',
                label: 'Website',
                onTap: () => _launch(club.websiteUrl),
              ),
            if (club.linkedinUrl.isNotEmpty)
              _SocialImageIcon(
                assetPath: 'assets/logos/ic_linkedin.png',
                label: 'LinkedIn',
                onTap: () => _launch(club.linkedinUrl),
              ),
            if (club.instagramUrl.isNotEmpty)
              _SocialImageIcon(
                assetPath: 'assets/logos/ic_instagram.png',
                label: 'Instagram',
                onTap: () => _launch(club.instagramUrl),
              ),
            if (club.email.isNotEmpty)
              _SocialImageIcon(
                assetPath: 'assets/logos/ic_envelope.png',
                label: 'Email',
                onTap: () => _launch('mailto:${club.email}'),
              ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// MEMBERS BOTTOM SHEET
// ─────────────────────────────────────────────

class _MembersBottomSheet extends StatefulWidget {
  final List<ClubMember> members;
  const _MembersBottomSheet({required this.members});

  @override
  State<_MembersBottomSheet> createState() => _MembersBottomSheetState();
}

class _MembersBottomSheetState extends State<_MembersBottomSheet>
    with SingleTickerProviderStateMixin {
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
    _availableYears = _allYears
        .where((y) => widget.members.any((m) => m.year == y))
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

  List<ClubMember> _membersForYear(String year) =>
      widget.members.where((m) => m.year == year).toList();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.80,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Club Members',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Year tabs
          if (_availableYears.isNotEmpty)
            TabBar(
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

          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // Member list — scrollable inside the sheet
          Expanded(
            child: _availableYears.isEmpty
                ? const Center(child: Text('No members found.'))
                : TabBarView(
                    controller: _tabController,
                    children: _availableYears.map((year) {
                      final members = _membersForYear(year);
                      return ListView.separated(
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
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(
                                    0xFF1565C0,
                                  ).withOpacity(0.1),
                                  child: Text(
                                    m.studentName.isNotEmpty
                                        ? m.studentName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1565C0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m.studentName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
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
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SOCIAL IMAGE ICON
// ─────────────────────────────────────────────

class _SocialImageIcon extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onTap;

  const _SocialImageIcon({
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(assetPath, width: 26, height: 26),
            // const SizedBox(height: 5),
            // Text(
            //   label,
            //   style: TextStyle(
            //     fontSize: 9,
            //     color: Colors.grey[600],
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BANNER FALLBACK
// ─────────────────────────────────────────────

class _BannerFallback extends StatelessWidget {
  final String clubName;
  const _BannerFallback({required this.clubName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF26C6DA)],
        ),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.18,
          child: Text(
            clubName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CLUB LOGO
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

// ─────────────────────────────────────────────
// PROJECT CARD
// ─────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  final ClubProject project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.darkDivider : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

// ─────────────────────────────────────────────
// LABEL-VALUE HELPER
// ─────────────────────────────────────────────

class _LabelValue {
  final String label;
  final String value;
  const _LabelValue(this.label, this.value);
}
