
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

static const List<_Skill> _skills = [    _Skill('Flutter', Icons.phone_iphone, Color(0xFF54C5F8)),
    _Skill('Dart', Icons.code, Color(0xFF64B5F6)),
    _Skill('JavaScript', Icons.javascript, Color(0xFFF7DF1E)),
    _Skill('Node.js', Icons.dns_outlined, Color(0xFF68A063)),
    _Skill('PostgreSQL', Icons.storage, Color(0xFF75B4E4)),
    _Skill('Firebase', Icons.local_fire_department, Color(0xFFFFCA28)),
    _Skill('Git & GitHub', Icons.account_tree, Colors.white),
    _Skill('REST APIs', Icons.api, Color(0xFFB59AFF)),
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
                '02 / TECHNICAL EXPERTISE',
                style: TextStyle(
                  color: AppTheme.secondary,
                  fontSize: 13,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Technologies I work with.',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: isMobile ? 30 : 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'The tools and technologies I use to build '
                'modern applications and digital solutions.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 17,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 45),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns =
                      constraints.maxWidth < 500 ? 2 : 4;
                  const spacing = 16.0;
                  final cardWidth =
                      (constraints.maxWidth -
                          (columns - 1) * spacing) /
                      columns;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                   children: _skills.map((skill) {
                      return SizedBox(
                        width: cardWidth,
                        child: _SkillCard(skill: skill),
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

class _Skill {
  final String name;
  final IconData icon;
  final Color color;

  const _Skill(this.name, this.icon, this.color);
}

class _SkillCard extends StatefulWidget {
  final _Skill skill;

  const _SkillCard({required this.skill});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1,
        duration: const Duration(milliseconds: 220),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _hovered
                ? AppTheme.primary.withValues(alpha: 0.12)
                : AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered
                  ? AppTheme.primary
                  : AppTheme.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.14),
                      blurRadius: 24,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.skill.icon,
                color: widget.skill.color,
                size: 32,
              ),
              const SizedBox(height: 22),
              Text(
                widget.skill.name,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
