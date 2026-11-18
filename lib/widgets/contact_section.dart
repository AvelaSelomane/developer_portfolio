import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  // Replace these with your actual public contact details.
  static const String email = 'Avelaselomane3@gmail.com';
  static const String phone = '067 061 5297';
  static const String phoneLink = 'tel:+27670615297';
  static const String github = 'https://github.com/AvelaSelomane';
  static const String linkedin = '';

  Future<void> _openLink(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened) {
        throw Exception('Unable to open link');
      }
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open this link.')),
      );
    }
  }

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
                '04 / GET IN TOUCH',
                style: TextStyle(
                  color: AppTheme.secondary,
                  fontSize: 13,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Let's build something great together.",
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: isMobile ? 32 : 42,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                "I'm interested in software development "
                "opportunities, internships, and collaborations "
                "where I can contribute, learn, and build "
                "meaningful digital solutions.",
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 17,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  _ContactCard(
                    icon: Icons.phone_outlined,
                    title: 'Call Me',
                    subtitle: phone,
                    onTap: () => _openLink(context, phoneLink),
                  ),
                  if (email.isNotEmpty)
                    _ContactCard(
                      icon: Icons.mail_outline,
                      title: 'Email Me',
                      subtitle: email,
                      onTap: () => _openLink(
                        context,
                        Uri(scheme: 'mailto', path: email).toString(),
                      ),
                    ),
                  _ContactCard(
                    icon: Icons.code,
                    title: 'GitHub',
                    subtitle: 'Explore my projects',
                    onTap: () => _openLink(context, github),
                  ),
                  if (linkedin.isNotEmpty)
                    _ContactCard(
                      icon: Icons.work_outline,
                      title: 'LinkedIn',
                      subtitle: 'Connect professionally',
                      onTap: () => _openLink(context, linkedin),
                    ),
                ],
              ),
              const SizedBox(height: 90),
              const Divider(color: AppTheme.border),
              const SizedBox(height: 25),
              const Center(
                child: Text(
                  '\u00A9 2026 Avela Selomane. Built with Flutter.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.035 : 1.0,
        duration: const Duration(milliseconds: 220),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 300,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered ? AppTheme.primary : AppTheme.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      blurRadius: 25,
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Icon(widget.icon, color: AppTheme.secondary, size: 28),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.subtitle,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_outward,
                      color: AppTheme.secondary,
                      size: 18,
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
