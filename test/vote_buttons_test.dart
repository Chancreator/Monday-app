import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monday_app/widgets/vote_buttons.dart';

// Deliberately tests VoteButtons in isolation, not the full app — MondayApp
// starts with AuthService().authStateChanges, which needs a real Firebase
// project connected (see README Setup). Once Firebase is wired in, this file
// is the place to add a test that pumps MondayApp itself.
void main() {
  testWidgets('VoteButtons shows score and calls callbacks on tap',
      (tester) async {
    var upvoted = false;
    var downvoted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VoteButtons(
            score: 5,
            userVote: 0,
            onUpvote: () => upvoted = true,
            onDownvote: () => downvoted = true,
          ),
        ),
      ),
    );

    expect(find.text('5'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    expect(upvoted, isTrue);

    await tester.tap(find.byIcon(Icons.arrow_downward));
    await tester.pump();
    expect(downvoted, isTrue);
  });
}
