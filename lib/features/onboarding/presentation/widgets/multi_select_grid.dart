import 'package:flutter/material.dart';

/// A generic GridView that manages multi-select state locally.
///
/// [T] is the type of each option (typically an enum).
/// [itemBuilder] receives the item and whether it is currently selected.
class MultiSelectGrid<T> extends StatefulWidget {
  final List<T> options;
  final List<T> initiallySelected;
  final int? maxSelections;
  final Widget Function(T item, bool isSelected, VoidCallback onTap)
      itemBuilder;
  final void Function(List<T> selected) onChanged;
  final int crossAxisCount;
  final double childAspectRatio;

  const MultiSelectGrid({
    super.key,
    required this.options,
    required this.initiallySelected,
    required this.itemBuilder,
    required this.onChanged,
    this.maxSelections,
    this.crossAxisCount = 2,
    this.childAspectRatio = 2.2,
  });

  @override
  State<MultiSelectGrid<T>> createState() => _MultiSelectGridState<T>();
}

class _MultiSelectGridState<T> extends State<MultiSelectGrid<T>> {
  late final List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.initiallySelected);
  }

  void _toggle(T item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else {
        final max = widget.maxSelections;
        if (max == null || _selected.length < max) {
          _selected.add(item);
        }
      }
    });
    widget.onChanged(List<T>.unmodifiable(_selected));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: widget.options.length,
      itemBuilder: (context, index) {
        final item = widget.options[index];
        final isSelected = _selected.contains(item);
        return widget.itemBuilder(item, isSelected, () => _toggle(item));
      },
    );
  }
}
