import 'package:flutter/material.dart';

import '../../components.dart';
import 'component_effect.dart';
import 'controllers/effect_controller.dart';

/// Change the color of a component over time.
///
/// Due to how this effect is implemented, and how Flutter's [ColorFilter]
/// class works, this effect can't be mixed with other [ColorEffect]s, when more
/// than one is added to the component, only the last one will have effect.
class ColorEffect extends ComponentEffect<HasPaint> {
  final String? paintId;
  final Color color;
  late final ColorFilter? _original;
  late final Tween<double> _tween;

  ColorEffect(
    this.color,
    Offset offset,
    EffectController controller, {
    this.paintId,
  })  : _tween = Tween(begin: offset.dx, end: offset.dy),
        super(controller);

  @override
  Future<void> onMount() async {
    super.onMount();

    _original = target.getPaint(paintId).colorFilter;
  }

  @override
  void apply(double progress) {
    final currentColor = color.withOpacity(
      _tween.transform(progress),
    );
    target.tint(currentColor, paintId: paintId);
    super.apply(progress);
  }

  @override
  void reset() {
    super.reset();
    target.getPaint(paintId).colorFilter = _original;
  }
}