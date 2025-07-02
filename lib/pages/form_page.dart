import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/task_form.dart';



class FormPage extends StatelessWidget {

  final String? id;
  const FormPage({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id !=null ? AppLocalizations.of(context)!.edit_task : AppLocalizations.of(context)!.new_task),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(15),
        child: TaskForm(id: id,),
      ),
    );
  }
}