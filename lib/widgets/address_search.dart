import 'package:flutter/material.dart';
import 'package:renting_app_mobile/widgets/custom_text.dart';

import '../models/place_service.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  PlaceApiProvider apiClient = PlaceApiProvider("");

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Suggestion("", ""));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // throw UnimplementedError();
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : apiClient.fetchSuggestions(
              query, Localizations.localeOf(context).languageCode),
      builder: (context, AsyncSnapshot<List<Suggestion>> snapshot) => query ==
              ''
          ? Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text('Enter your address'),
            )
          : snapshot.hasData
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemBuilder: (context, index) => Column(
                    children: [
                      ListTile(
                        title: CustomText(
                          txtTitle:
                              (snapshot.data?[index] as Suggestion).description,
                        ),
                        onTap: () {
                          close(context, snapshot.data?[index] as Suggestion);
                        },
                      ),
                      if ((snapshot.data?.length) == index + 1) const SizedBox() else Divider()
                    ],
                  ),
                  itemCount: snapshot.data?.length,
                )
              : const Text('Loading...'),
    );
  }
}
