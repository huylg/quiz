# UI Flows

## Join Flow

- User enters quiz ID and name.
- App validates input and shows loading state.
- On success, app navigates to gameplay.
- On error, app shows inline error and retry.

## Gameplay Flow

- App displays question and answer options.
- User selects an answer and submits.
- App disables input and shows submit progress.
- App updates score and loads next question.

## Leaderboard Flow

- User opens leaderboard from gameplay.
- App shows live rankings and highlights user.
- Updates arrive in real time without refresh.
