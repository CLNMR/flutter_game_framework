import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/context_extension.dart';
import 'own_text.dart';

/// A base widget for displaying game log entries in an expandable,
/// scrollable panel grouped by round.
///
/// Subclasses provide game-specific customization via the constructor
/// parameters: [decoration], [headerTranslationKey], [buildHeaderForRound],
/// and [buildExtraEntryContent].
class LogEntryListDisplay extends ConsumerStatefulWidget {
  /// Creates a [LogEntryListDisplay].
  const LogEntryListDisplay({
    super.key,
    required this.game,
    required this.logEntries,
    this.decoration,
    this.headerTranslationKey = 'LOG:boxTitle',
    this.buildHeaderForRound,
    this.buildExtraEntryContent,
    this.buildEntryTextSpan,
    this.expandedRounds,
  });

  /// The current game.
  final Game game;

  /// Log entries grouped by round number, with entries flattened into a list.
  /// Games with nested structures (round → turn → entries) should flatten
  /// before passing.
  final Map<RoundNumber, List<LogEntry>> logEntries;

  /// Decoration for the log panel background.
  final Decoration? decoration;

  /// Translation key for the log box title.
  final String headerTranslationKey;

  /// Builds the header widget for a given round.
  /// If null, defaults to "Round N" text.
  final TrObject Function(RoundNumber round)? buildHeaderForRound;

  /// Builds extra content below a log entry (e.g., fight reports).
  /// Return null for no extra content.
  final Widget? Function(LogEntry entry)? buildExtraEntryContent;

  /// Builds the text span for a log entry. When provided, replaces the
  /// default [BuildContext.trFromObjectToTextSpan] call, allowing the
  /// caller to customize rich text rendering (e.g., adding hover callbacks).
  final TextSpan Function(BuildContext context, LogEntry entry)?
  buildEntryTextSpan;

  /// Which rounds should be expanded by default.
  /// If null, all rounds are expanded.
  final Set<RoundNumber>? expandedRounds;

  @override
  ConsumerState<LogEntryListDisplay> createState() =>
      _LogEntryListDisplayState();
}

class _LogEntryListDisplayState extends ConsumerState<LogEntryListDisplay> {
  final _scrollController = ScrollController();
  final _expansionControllers = <RoundNumber, ExpandableController>{};
  bool _isMinimized = false;

  @override
  void didUpdateWidget(covariant LogEntryListDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final controller in _expansionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  ExpandableController _getExpansionController(RoundNumber round) =>
      _expansionControllers.putIfAbsent(round, () {
        final isExpanded = widget.expandedRounds?.contains(round) ?? true;
        return ExpandableController(initialExpanded: isExpanded);
      });

  void _scrollToBottom({bool force = false}) {
    if (!_scrollController.hasClients) return;
    final isNearBottom =
        _scrollController.offset >=
        _scrollController.position.maxScrollExtent - 100;
    if (!isNearBottom && !force) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration:
        widget.decoration ??
        BoxDecoration(
          color: Colors.blueGrey.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
    child: _isMinimized ? _buildMaximizeButton() : _buildMaximizedLog(),
  );

  Widget _buildMaximizeButton() => IconButton(
    icon: const Icon(Icons.expand_more, color: Colors.white),
    onPressed: () => setState(() => _isMinimized = false),
  );

  Widget _buildMinimizeButton() => IconButton(
    icon: const Icon(Icons.expand_less, color: Colors.white),
    iconSize: 16,
    onPressed: () => setState(() => _isMinimized = true),
  );

  Widget _buildMaximizedLog() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildHeader(),
      const Divider(height: 1),
      Expanded(child: _buildEntryList()),
    ],
  );

  Widget _buildHeader() => Row(
    children: [
      _buildMinimizeButton(),
      Expanded(
        child: OwnText(
          text: widget.headerTranslationKey,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.arrow_downward, color: Colors.white),
        iconSize: 16,
        onPressed: () => _scrollToBottom(force: true),
      ),
    ],
  );

  Widget _buildEntryList() {
    final roundKeys = widget.logEntries.keys.toList()..sort();
    return ListView.builder(
      controller: _scrollController,
      itemCount: roundKeys.length,
      itemBuilder: (context, index) {
        final round = roundKeys[index];
        final entries = widget.logEntries[round] ?? [];
        return _buildExpansionPanelForRound(round, entries);
      },
    );
  }

  Widget _buildExpansionPanelForRound(
    RoundNumber round,
    List<LogEntry> entries,
  ) {
    return ExpandablePanel(
      controller: _getExpansionController(round),
      theme: const ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        iconColor: Colors.white,
        iconSize: 16,
      ),
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: _buildRoundHeader(round),
      ),
      collapsed: const SizedBox.shrink(),
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entries
            .map((entry) => _buildSingleLogEntryDisplay(entry))
            .toList(),
      ),
    );
  }

  Widget _buildRoundHeader(RoundNumber round) {
    if (widget.buildHeaderForRound != null) {
      return OwnText(trObject: widget.buildHeaderForRound!(round));
    }
    if (round == 0) {
      return const OwnText(text: 'LOG:headerGameStart');
    }
    return OwnText(
      trObject: TrObject(
        'roundDisplay',
        namedArgs: {'round': round.toString()},
      ),
    );
  }

  Widget _buildSingleLogEntryDisplay(LogEntry entry) {
    final span =
        widget.buildEntryTextSpan?.call(context, entry) ??
        context.trFromObjectToTextSpan(
          entry.getDescription(widget.game),
          widget.game.shortenedPlayerNames,
        );
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0 + entry.indentLevel * 12.0,
        right: 8,
        top: 2,
        bottom: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 4, right: 6),
                child: Icon(Icons.circle, size: 6, color: Colors.white70),
              ),
              Expanded(
                child: SelectableText.rich(
                  span,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          if (widget.buildExtraEntryContent != null)
            widget.buildExtraEntryContent!(entry) ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
