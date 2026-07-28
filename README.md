# MONDAY

A mobile community app: user accounts, private messaging, post/message boards,
upvote/downvote voting, a "ForgePoint" karma system, and topic communities
prefixed with `m/` (e.g. `m/gaming`, `m/science`).

## Stack

- **Flutter** — single codebase for iOS + Android
- **Firebase** — free tier covers everything this app needs to start:
  - Firebase Auth (accounts / login)
  - Cloud Firestore (posts, comments, communities, votes, ForgePoint)
  - Firebase Cloud Messaging (optional, for push notifications on replies/DMs)

  Supabase is a drop-in alternative if you'd rather have a Postgres backend —
  the `services/` layer is written so you can swap the implementation without
  touching the UI.

## Project structure

```
lib/
  core/            # theme, constants, shared config
  models/          # data classes: AppUser, Community, Post, Comment, Message...
  services/         # Firebase-facing logic (auth, firestore, voting, messaging)
  screens/
    auth/           # login, register
    home/           # main feed, community list
    community/      # m/community view, create community
    post/            # post detail (with comments), create post
    messages/       # conversation list, chat screen
    profile/        # user profile, ForgePoint total, post history
  widgets/          # reusable pieces: PostCard, VoteButtons, CommentTile...
```

## Feature map

| # | Feature | Where it lives |
|---|---------|----------------|
| 1 | User accounts | `services/auth_service.dart`, `screens/auth/` |
| 2 | Private messaging | `services/message_service.dart`, `screens/messages/` |
| 3 | Post & message board | `services/firestore_service.dart`, `screens/post/`, `screens/community/` |
| 4 | Upvote / downvote | `services/vote_service.dart`, `widgets/vote_buttons.dart` |
| 5 | ForgePoint karma | tracked on `AppUser.forgePoints`, updated by `vote_service.dart` |
| 6 | `m/` communities | `models/community.dart`, `screens/community/` |

## Setup

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Create a free Firebase project: https://console.firebase.google.com
3. Run `flutterfire configure` in this directory (installs `firebase_options.dart`
   automatically) — see https://firebase.google.com/docs/flutter/setup
4. Enable **Email/Password** auth and **Cloud Firestore** in the Firebase console
5. `flutter pub get`
6. `flutter run`

## Data model (Firestore collections)

- `users/{uid}` — username, email, forgePoints, createdAt
- `communities/{communityId}` — name (`m/xxx`), description, memberCount
- `posts/{postId}` — communityId, authorId, title, body, upvotes, downvotes, createdAt
- `posts/{postId}/comments/{commentId}` — authorId, body, upvotes, downvotes, createdAt
- `votes/{voteId}` — userId, targetId (post or comment), value (1 or -1)
- `conversations/{conversationId}` — participantIds, lastMessage, updatedAt
- `conversations/{conversationId}/messages/{messageId}` — senderId, body, sentAt

## Status

This is a full scaffold: every screen, model, and service for all 6 features
exists and compiles conceptually, with clear `TODO` markers where you'll wire
in your actual Firebase project. Not yet wired to a live Firebase project —
do the Setup steps above first.
