import 'package:flutter/widgets.dart';

import '../../../foo_form_field.dart';

abstract class FooTextEditingController<Value>
    extends FooFieldController<Value> {
  late final TextEditingController textEditingController;

  FooTextEditingController({
    required super.initialValue,
    required super.areEqual,
  }) : textEditingController = TextEditingController() {
    textEditingController.text = toText(initialValue) ?? '';
    _invokeSyncers();
  }

  String? toText(Value? value);

  Value? fromText(String? text);

  void _invokeSyncers() {
    addListener(_onValueChanged);
    textEditingController.addListener(_onTextEditingControllerChanged);
  }

  void _removeSyncers() {
    removeListener(_onValueChanged);
    textEditingController.removeListener(_onTextEditingControllerChanged);
  }

  @override
  void dispose() {
    _removeSyncers();
    textEditingController.dispose();
    super.dispose();
  }

  void _onTextEditingControllerChanged() {
    if (value == null && textEditingController.text == "") {
      return;
    }
    value = fromText(textEditingController.text);
  }

  void _onValueChanged() {
    final newText = toText(value) ?? '';
    if (textEditingController.text != newText) {
      textEditingController.text = newText;
    }
  }
}

class FooRangeTextEditingController<
  Value extends Comparable,
  BoundryController extends FooTextEditingController<Value>
>
    extends RangeFieldController<Value, BoundryController> {
  FooRangeTextEditingController({
    required super.minController,
    required super.maxController,
  });
}
