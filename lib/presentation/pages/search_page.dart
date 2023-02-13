import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie/movie_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  static const ROUTE_NAME = '/search';
  final bool isMovie;

  const SearchPage({
    required this.isMovie,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late MovieBloc _movieBloc;
  late TvSeriesBloc _tvSeriesBloc;

  @override
  void initState() {
    super.initState();
    _movieBloc = BlocProvider.of(context);
    _tvSeriesBloc = BlocProvider.of(context);

    widget.isMovie
        ? _movieBloc.add(MovieEvent.movieSearchFetch(query: ''))
        : _tvSeriesBloc.add(TvSeriesEvent.tvSeriesSearchFetch(query: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                widget.isMovie
                    ? _movieBloc.add(MovieEvent.movieSearchFetch(query: query))
                    : _tvSeriesBloc
                        .add(TvSeriesEvent.tvSeriesSearchFetch(query: query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            widget.isMovie
                ? BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
                    final status = state.movieSearchStatus;
                    if (status == RequestState.Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (status == RequestState.Loaded) {
                      final result = state.movieList;
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final movie = state.movieList[index];
                            return MovieCard(movie);
                          },
                          itemCount: result.length,
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(),
                      );
                    }
                  })
                : BlocBuilder<TvSeriesBloc, TvSeriesState>(
                    builder: (context, state) {
                    final status = state.tvSeriesSearchStatus;
                    if (status == RequestState.Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (status == RequestState.Loaded) {
                      final result = state.tvSeriesList;
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final tv = state.tvSeriesList[index];
                            return TvSeriesCard(tv);
                          },
                          itemCount: result.length,
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(),
                      );
                    }
                  })
          ],
        ),
      ),
    );
  }
}
