import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'feedback_capture_service.dart';
import 'feedback_disk_writer.dart';
import 'feedback_export_bundle.dart';
import 'portal_build_version.dart';

/// Full-screen editor: draw rectangles on the capture, attach notes, export PNG+JSON.
class FeedbackAnnotationPage extends StatefulWidget {
  const FeedbackAnnotationPage({super.key, required this.payload});

  final FeedbackCapturePayload payload;

  @override
  State<FeedbackAnnotationPage> createState() => _FeedbackAnnotationPageState();
}

class _FeedbackAnnotationPageState extends State<FeedbackAnnotationPage> {
  final List<FeedbackRegion> _regions = [];
  Offset? _dragStart;
  Offset? _dragCurrent;
  int _idCounter = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.payload;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Annotate for AI'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Discard'),
          ),
          FilledButton(
            onPressed: _save,
            child: const Text('Save export'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Drag on the screenshot to draw a box around what should change, '
                'then describe the fix. Repeat for multiple spots. '
                'Saving writes a PNG and a JSON file your assistant can read together.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: p.logicalWidth,
                    height: p.logicalHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(
                          p.pngBytes,
                          width: p.logicalWidth,
                          height: p.logicalHeight,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.medium,
                          gaplessPlayback: true,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (d) => setState(() {
                            _dragStart = d.localPosition;
                            _dragCurrent = d.localPosition;
                          }),
                          onPanUpdate: (d) =>
                              setState(() => _dragCurrent = d.localPosition),
                          onPanEnd: (_) => _finishDrag(),
                          child: CustomPaint(
                            painter: _DragPainter(
                              regions: _regions,
                              dragStart: _dragStart,
                              dragCurrent: _dragCurrent,
                            ),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 160,
            child: Material(
              elevation: 2,
              color: theme.colorScheme.surface,
              child: _regions.isEmpty
                  ? Center(
                      child: Text(
                        'No regions yet — drag on the image above.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: _regions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final r = _regions[i];
                        return ListTile(
                          dense: true,
                          title: Text(
                            r.note.isEmpty ? '(no description)' : r.note,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '#${r.id}  ${r.rectLogical.width.toStringAsFixed(0)}×${r.rectLogical.height.toStringAsFixed(0)}',
                            style: theme.textTheme.labelSmall,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => setState(() => _regions.removeAt(i)),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finishDrag() async {
    final start = _dragStart;
    final end = _dragCurrent;
    setState(() {
      _dragStart = null;
      _dragCurrent = null;
    });
    if (start == null || end == null) return;

    final rect = Rect.fromLTRB(
      math.min(start.dx, end.dx),
      math.min(start.dy, end.dy),
      math.max(start.dx, end.dx),
      math.max(start.dy, end.dy),
    );
    if (rect.width < 12 || rect.height < 12) return;

    final note = await showDialog<String>(
      context: context,
      builder: (ctx) => const _RegionNoteDialog(),
    );

    if (!mounted || note == null) return;

    _idCounter += 1;
    setState(() {
      _regions.add(
        FeedbackRegion(
          id: 'r$_idCounter',
          rectLogical: RectLogical(
            left: rect.left,
            top: rect.top,
            width: rect.width,
            height: rect.height,
          ),
          note: note,
        ),
      );
    });
  }

  Future<void> _save() async {
    try {
      final paths = await FeedbackDiskWriter.write(
        payload: widget.payload,
        regions: _regions,
        appVersion: kPortalPackageVersion,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Saved'),
          content: SelectableText(
            'PNG:\n${paths.pngPath}\n\nJSON:\n${paths.jsonPath}\n\n'
            'Attach both files (or paste the JSON) when you send a screenshot to your AI assistant.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save: $e')),
      );
    }
  }
}

class _DragPainter extends CustomPainter {
  _DragPainter({
    required this.regions,
    required this.dragStart,
    required this.dragCurrent,
  });

  final List<FeedbackRegion> regions;
  final Offset? dragStart;
  final Offset? dragCurrent;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.amber.withValues(alpha: 0.18);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.amberAccent;

    for (final r in regions) {
      final rect = Rect.fromLTWH(
        r.rectLogical.left,
        r.rectLogical.top,
        r.rectLogical.width,
        r.rectLogical.height,
      );
      canvas.drawRect(rect, fill);
      canvas.drawRect(rect, stroke);
    }

    if (dragStart != null && dragCurrent != null) {
      final rect = Rect.fromPoints(dragStart!, dragCurrent!);
      canvas.drawRect(rect, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _DragPainter oldDelegate) => true;
}

class _RegionNoteDialog extends StatefulWidget {
  const _RegionNoteDialog();

  @override
  State<_RegionNoteDialog> createState() => _RegionNoteDialogState();
}

class _RegionNoteDialogState extends State<_RegionNoteDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('What should change here?'),
      content: TextField(
        controller: _controller,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Describe the fix for this area…',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, ''),
          child: const Text('Skip'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

/// Entry used by the floating button and Settings.
Future<void> openAiFeedbackAnnotationFlow(BuildContext context) async {
  final theme = Theme.of(context);
  final go = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      title: const Text('Capture this screen?'),
      content: const Text(
        'The current portal view (navigation + content) will be frozen as a PNG. '
        'You can then draw boxes and add notes for an AI assistant.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Capture')),
      ],
    ),
  );
  if (go != true || !context.mounted) return;

  final messenger = ScaffoldMessenger.maybeOf(context);
  messenger?.showSnackBar(
    const SnackBar(content: Text('Capturing…'), duration: Duration(milliseconds: 600)),
  );

  await WidgetsBinding.instance.endOfFrame;
  if (!context.mounted) return;
  final payload = await FeedbackCaptureService.capturePortal(context: context);
  if (!context.mounted) return;

  if (payload == null) {
    messenger?.showSnackBar(
      const SnackBar(content: Text('Could not capture screen (try again after the view paints).')),
    );
    return;
  }

  await Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => FeedbackAnnotationPage(payload: payload),
    ),
  );
}
