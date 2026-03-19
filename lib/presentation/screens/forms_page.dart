import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../bloc/bloc/forms_bloc.dart';
import '../../bloc/events/forms_event.dart';
import '../../bloc/states/forms_state.dart';
import '../../data/repositories/forms_repository_impl.dart';
import '../../domain/usecases/get_forms.dart';
import '../common/form_item.dart';
import '../common/loading_card.dart';

class FormsPage extends StatelessWidget {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = FormsRepositoryImpl(firestore: FirebaseFirestore.instance);
    final useCase = GetForms(repository);

    return BlocProvider(
      create: (context) => FormsBloc(getForms: useCase)..add(FetchFormsEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: const FormsView(),
      ),
    );
  }
}

class FormsView extends StatelessWidget {
  const FormsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(
      builder: (context, state) {
        return Stack(
          children: [
            if (state is FormsLoaded)
              if (state.forms.isEmpty)
                const Center(
                  child: Text(
                    "No Forms Available",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                )
              else
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.forms.length,
                  itemBuilder: (context, index) {
                    return FormItem(form: state.forms[index]);
                  },
                ),

            if (state is FormsError)
              Center(child: Text(state.message)),

            if (state is FormsLoading || state is FormsInitial)
              const Center(child: LoadingCard()),
          ],
        );
      },
    );
  }
}