import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const _projects = [
    _Project(
      title: 'Adelaide Tambo Digital Visitor Register',
      description:
          'A digital library visitor registration system '
          'with attendance tracking, administrator analytics, '
          'and reporting features.',
      technologies: ['Flutter', 'Dart', 'Node.js', 'PostgreSQL'],
      githubUrl: 'https://github.com/AvelaSelomane/adelaide-register',
      icon: Icons.local_library_outlined,
    ),
    _Project(
      title: 'Adelaide Programme Register',
      description:
          'A programme attendance application that allows '
          'supervisors to create programmes and participants '
          'to register digitally.',
      technologies: ['Flutter', 'Dart'],
      githubUrl: '',
      icon: Icons.event_note_outlined,
    ),
    _Project(
      title: 'PocketTrack',
      description:
          'A personal expense tracking application featuring '
          'financial summaries, transaction management, '
          'and visual dashboards.',
      technologies: ['Flutter', 'Dart'],
      githubUrl: '',
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 70,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '03 / FEATURED WORK',
                style: TextStyle(
                  color: AppTheme.secondary,
                  fontSize: 13,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Projects I've built.",
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: isMobile ? 30 : 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'A selection of applications focused on '
                'solving real-world problems.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 17,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 45),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth < 700 ? 1 : 2;
                  const spacing = 20.0;
                  final cardWidth =
                      (constraints.maxWidth - (columns - 1) * spacing) /
                      columns;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: _projects.map((project) {
                      return SizedBox(
                        width: cardWidth,
                        child: _ProjectCard(project: project),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String githubUrl;
  final IconData icon;

  const _Project({
    required this.title,
    required this.description,
    required this.technologies,
    required this.githubUrl,
    required this.icon,
  });
}

class _ProjectCard extends StatefulWidget {
  final _Project project;

  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  Future<void> _openGitHub(String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) {
      return;
    }

    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        throw Exception('Unable to open GitHub');
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the GitHub repository.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.025 : 1,
        duration: const Duration(milliseconds: 220),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered ? AppTheme.primary : AppTheme.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      blurRadius: 30,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(project.icon, color: AppTheme.secondary, size: 32),
              ),
              const SizedBox(height: 25),
              Text(
                project.title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                project.description,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.technologies.map((tech) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tech,
                      style: const TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),
             
if (project.githubUrl.isNotEmpty)
  ElevatedButton.icon(
    onPressed: () => _openGitHub(project.githubUrl),
    icon: const Icon(Icons.code, size: 18),
    label: const Text('View on GitHub'),
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 18,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  )
            ],
          ),
        ),
      ),
    );
  }
}
