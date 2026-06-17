import 'package:event_hub/core/widgets/events_list_tile.dart';
import 'package:event_hub/features/event_details/presentation/screens/event_details_screen.dart';
import 'package:event_hub/features/filter/pressentation/screens/filter_bottom_sheet.dart'
    show FilterBottomSheet;
import 'package:event_hub/features/search/presentation/cubit/search_cubit.dart';
import 'package:event_hub/features/search/presentation/screens/widgets/search_input_bar.dart';
import 'package:event_hub/model/repositories/ticketmaster_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(context.read<TicketmasterRepository>()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF222222)),
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222222),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SearchInputBar(
                  controller: searchController,
                  onChanged: (query) => context.read<SearchCubit>().searchByKeyword(query),
                  onFilterTap: () async {
                    final classificationId = await FilterBottomSheet.show(context);
                    if (classificationId != null || state.selectedClassificationId != null) {
                      context.read<SearchCubit>().applyFilter(classificationId);
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF5669FF)),
      );
    }
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!, style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.read<SearchCubit>().searchByKeyword(state.query),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (state.hasSearched && state.results.isEmpty) {
      return const Center(
        child: Text(
          'No events found',
          style: TextStyle(color: Color(0xFF888888), fontSize: 15),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.results.length,
      itemBuilder: (_, i) => EventListTile(
        event: state.results[i],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(event: state.results[i]),
          ),
        ),
      ),
    );
  }
}