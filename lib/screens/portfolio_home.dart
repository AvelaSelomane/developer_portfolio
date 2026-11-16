import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/typing_text.dart';
import '../widgets/glow_button.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/contact_section.dart';

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  String _activeSection = 'Home';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
    _scrollController.addListener(_updateActiveSection);
  }

  GlobalKey _keyForSection(String section) {
    switch (section) {
      case 'About':
        return _aboutKey;
      case 'Skills':
        return _skillsKey;
      case 'Projects':
        return _projectsKey;
      case 'Contact':
        return _contactKey;
      default:
        return _homeKey;
    }
  }

  void _scrollToSection(String section) {
    final targetContext = _keyForSection(section).currentContext;

    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );

    setState(() {
      _activeSection = section;
    });
  }

  void _updateActiveSection() {
    if (!_scrollController.hasClients) return;

    const sections = ['Home', 'About', 'Skills', 'Projects', 'Contact'];

    String current = 'Home';

    for (final section in sections) {
      final sectionContext = _keyForSection(section).currentContext;

      if (sectionContext == null) continue;

      final renderObject = sectionContext.findRenderObject();

      if (renderObject is RenderBox && renderObject.hasSize) {
        final position = renderObject.localToGlobal(Offset.zero);

        if (position.dy <= 220) {
          current = section;
        }
      }
    }

    if (_activeSection != current && mounted) {
      setState(() {
        _activeSection = current;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateActiveSection);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 800;

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildNavigation(isMobile),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        KeyedSubtree(
                          key: _homeKey,
                          child: _buildHero(isMobile),
                        ),
                        KeyedSubtree(
                          key: _aboutKey,
                          child: const AboutSection(),
                        ),
                        KeyedSubtree(
                          key: _skillsKey,
                          child: const SkillsSection(),
                        ),
                        KeyedSubtree(
                          key: _projectsKey,
                          child: const ProjectsSection(),
                        ),
                        KeyedSubtree(
                          key: _contactKey,
                          child: const ContactSection(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 70,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background.withValues(alpha: 0.90),
        border: const Border(
          bottom: BorderSide(color: AppTheme.border, width: 0.6),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => _scrollToSection('Home'),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'AS.',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.secondary,
                ),
              ),
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            _navItem('Home'),
            _navItem('About'),
            _navItem('Skills'),
            _navItem('Projects'),
            _navItem('Contact'),
            const SizedBox(width: 24),
            OutlinedButton.icon(
              onPressed: () => _scrollToSection('Contact'),
              icon: const Icon(Icons.mail_outline, size: 18),
              label: const Text('Hire Me'),
            ),
          ] else
            PopupMenuButton<String>(
              tooltip: 'Open navigation menu',
              icon: const Icon(
                Icons.menu_rounded,
                color: AppTheme.textPrimary,
                size: 28,
              ),
              color: AppTheme.surface,
              onSelected: _scrollToSection,
              itemBuilder: (context) {
                return ['Home', 'About', 'Skills', 'Projects', 'Contact'].map((
                  section,
                ) {
                  return PopupMenuItem<String>(
                    value: section,
                    child: Text(
                      section,
                      style: TextStyle(
                        color: _activeSection == section
                            ? AppTheme.secondary
                            : AppTheme.textPrimary,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    final isActive = _activeSection == title;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: TextButton(
        onPressed: () => _scrollToSection(title),
        style: TextButton.styleFrom(
          foregroundColor: isActive
              ? AppTheme.secondary
              : AppTheme.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _downloadCV() async {
    final cvUrl = Uri.base.resolve('Avela_Selomane_CV.pdf');

    try {
      final success = await launchUrl(
        cvUrl,
        mode: LaunchMode.platformDefault,
        webOnlyWindowName: '_blank',
      );

      if (!success) {
        throw Exception('Unable to open CV');
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open CV. Please try again.')),
      );
    }
  }

  Widget _buildHero(bool isMobile) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 600),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 70,
          vertical: isMobile ? 70 : 120,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WELCOME TO MY PORTFOLIO',
                      style: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 13,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Hi, I am\nAvela Selomane.',
                      style: TextStyle(
                        fontSize: isMobile ? 45 : 76,
                        height: 1.1,
                        letterSpacing: -2,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const TypingText(),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 650),
                      child: Text(
                        'I design and develop modern digital '
                        'experiences, from responsive web '
                        'applications to practical software '
                        'solutions. I enjoy turning real-world '
                        'challenges into clean, functional '
                        'applications.',
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.8,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 38),
                   
Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    GlowButton(
      label: 'View My Projects',
      icon: Icons.arrow_forward_rounded,
      onPressed: () => _scrollToSection('Projects'),
    ),
    GlowButton(
      label: 'Download CV',
      icon: Icons.download_rounded,
      outlined: true,
      onPressed: _downloadCV,
    ),
    GlowButton(
      label: 'Hire Me',
      icon: Icons.mail_outline_rounded,
      outlined: true,
      onPressed: () => _scrollToSection('Contact'),
    ),
  ],
),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
