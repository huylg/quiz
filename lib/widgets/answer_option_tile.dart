import 'package:flutter/material.dart';

import '../models/answer_option.dart';

class AnswerOptionTile extends StatelessWidget {
  const AnswerOptionTile({
    super.key,
    required this.answer,
    required this.isSelected,
    required this.onSelected,
  });

  final AnswerOption answer;
  final bool isSelected;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Answer option ${answer.text}',
      child: Card(
        child: ListTile(
          title: Text(answer.text),
          trailing: isSelected
              ? const Icon(Icons.check_circle)
              : const Icon(Icons.circle_outlined),
          onTap: onSelected,
        ),
      ),
    );
  }
}
