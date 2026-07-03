import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/widgets/components/app_card.dart';
import 'package:aqedu/features/home/home_view/components/home_models.dart';
import 'package:flutter/material.dart';

class HomeQuickActions extends StatefulWidget {
  const HomeQuickActions({
    super.key,
    required this.catalog,
    required this.preferences,
    this.onPreferencesChanged,
  });

  final List<HomeShortcutDefinition> catalog;
  final List<HomeShortcutPreference> preferences;
  final Future<void> Function(List<HomeShortcutPreference> preferences)?
  onPreferencesChanged;

  @override
  State<HomeQuickActions> createState() => _HomeQuickActionsState();
}

class _HomeQuickActionsState extends State<HomeQuickActions> {
  late List<HomeShortcutPreference> _preferences;
  bool _isEditing = false;
  bool _showLimitWarning = false;

  @override
  void initState() {
    super.initState();
    _preferences = normalizeHomeShortcutPreferences(
      widget.catalog,
      widget.preferences,
    );
  }

  @override
  void didUpdateWidget(covariant HomeQuickActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preferences != widget.preferences ||
        oldWidget.catalog != widget.catalog) {
      _preferences = normalizeHomeShortcutPreferences(
        widget.catalog,
        widget.preferences,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabledShortcuts = enabledHomeShortcutDefinitions(
      widget.catalog,
      _preferences,
    );

    return AppCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lối tắt', style: AppTextStyles.sectionTitle),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Chọn tối đa 8 chức năng thường dùng',
                      style: AppTextStyles.sectionSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                key: const Key('home-shortcuts-edit-toggle'),
                onPressed: () => setState(() => _isEditing = !_isEditing),
                icon: Icon(
                  _isEditing ? Icons.check_rounded : Icons.tune_rounded,
                ),
                label: Text(_isEditing ? 'Xong' : 'Sửa'),
              ),
            ],
          ),
          if (_showLimitWarning) ...[
            SizedBox(height: AppSpacing.md),
            _InlineWarning(message: 'Tối đa 8 lối tắt được bật'),
          ],
          SizedBox(height: AppSpacing.lg),
          if (_isEditing)
            _buildEditList()
          else if (enabledShortcuts.isEmpty)
            const _EmptyShortcutState()
          else
            _ShortcutGrid(shortcuts: enabledShortcuts),
        ],
      ),
    );
  }

  Widget _buildEditList() {
    final catalogByKey = {for (final item in widget.catalog) item.key: item};

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 320),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _preferences.length,
        itemBuilder: (context, index) {
          final definition = catalogByKey[_preferences[index].key];
          if (definition == null) return const SizedBox.shrink();
          return _ShortcutEditRow(
            key: ValueKey('shortcut-edit-row-${_preferences[index].key}'),
            definition: definition,
            preference: _preferences[index],
            canMoveUp: index > 0,
            canMoveDown: index < _preferences.length - 1,
            onToggle: (value) => _toggleShortcut(index, value),
            onMoveUp: () => _moveShortcut(index, -1),
            onMoveDown: () => _moveShortcut(index, 1),
          );
        },
      ),
    );
  }

  Future<void> _toggleShortcut(int index, bool enabled) async {
    final enabledCount = _preferences.where((item) => item.enabled).length;
    if (enabled &&
        !_preferences[index].enabled &&
        enabledCount >= kHomeMaxEnabledShortcuts) {
      setState(() => _showLimitWarning = true);
      return;
    }

    final updated = [..._preferences];
    updated[index] = updated[index].copyWith(enabled: enabled);
    await _commitPreferences(updated);
  }

  Future<void> _moveShortcut(int index, int direction) async {
    final target = index + direction;
    if (target < 0 || target >= _preferences.length) return;
    final updated = [..._preferences];
    final item = updated.removeAt(index);
    updated.insert(target, item);
    await _commitPreferences(updated);
  }

  Future<void> _commitPreferences(
    List<HomeShortcutPreference> preferences,
  ) async {
    final ordered = [
      for (var index = 0; index < preferences.length; index++)
        preferences[index].copyWith(sortOrder: index),
    ];
    final normalized = normalizeHomeShortcutPreferences(
      widget.catalog,
      ordered,
    );
    setState(() {
      _preferences = normalized;
      _showLimitWarning = false;
    });

    try {
      await widget.onPreferencesChanged?.call(normalized);
    } catch (_) {
      if (!mounted) return;
      setState(() => _showLimitWarning = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Chưa lưu được lối tắt')));
    }
  }
}

class _ShortcutGrid extends StatelessWidget {
  const _ShortcutGrid({required this.shortcuts});

  final List<HomeShortcutDefinition> shortcuts;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: shortcuts
          .map((shortcut) => _ShortcutTile(shortcut: shortcut))
          .toList(),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({required this.shortcut});

  final HomeShortcutDefinition shortcut;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('home-shortcut-tile-${shortcut.key}'),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: shortcut.builder));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: shortcut.color.withValues(alpha: AppOpacity.bg10),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: shortcut.color.withValues(alpha: AppOpacity.bg12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: shortcut.color.withValues(alpha: AppOpacity.bg18),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(shortcut.icon, color: shortcut.color, size: 20),
            ),
            SizedBox(width: AppSpacing.md),
            Flexible(
              child: Text(
                shortcut.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.actionTileTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutEditRow extends StatelessWidget {
  const _ShortcutEditRow({
    super.key,
    required this.definition,
    required this.preference,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onToggle,
    required this.onMoveUp,
    required this.onMoveDown,
  });

  final HomeShortcutDefinition definition;
  final HomeShortcutPreference preference;
  final bool canMoveUp;
  final bool canMoveDown;
  final ValueChanged<bool> onToggle;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: definition.color.withValues(alpha: AppOpacity.bg10),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(definition.icon, color: definition.color, size: 20),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              definition.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.actionTileTitle,
            ),
          ),
          IconButton(
            key: Key('shortcut-move-up-${definition.key}'),
            tooltip: 'Đưa lên',
            onPressed: canMoveUp ? onMoveUp : null,
            icon: const Icon(Icons.keyboard_arrow_up_rounded),
          ),
          IconButton(
            key: Key('shortcut-move-down-${definition.key}'),
            tooltip: 'Đưa xuống',
            onPressed: canMoveDown ? onMoveDown : null,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
          Switch(
            key: Key('shortcut-toggle-${definition.key}'),
            value: preference.enabled,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}

class _InlineWarning extends StatelessWidget {
  const _InlineWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.warning),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.actionTileSubtitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyShortcutState extends StatelessWidget {
  const _EmptyShortcutState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: AppBorders.lightBorder,
      ),
      child: Text(
        'Chưa bật lối tắt nào',
        textAlign: TextAlign.center,
        style: AppTextStyles.actionTileSubtitle,
      ),
    );
  }
}
