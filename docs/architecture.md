# Architecture

## Overview

The system uses a real-time backend to manage quiz sessions, scoring, and
leaderboards, and a Flutter client for the user experience.

## Diagram

```
Flutter Client
   | HTTP / WebSocket
   v
API Gateway ----> Session Service ----> Persistence
   |                     |
   v                     v
Real-Time Server ---> Scoring Service ---> Leaderboard Service
```

## Components

- API Gateway: HTTP endpoints for join and session info.
- Real-Time Server: WebSocket connections for live events.
- Session Service: In-memory or persistent session state.
- Scoring Service: Computes and updates scores.
- Leaderboard Service: Aggregates scores and ranks players.
- Persistence: Database for sessions, questions, and answers.
- Observability: Logging, metrics, and health checks.

## Technology Choices

- WebSocket for bidirectional, low-latency updates.
- TypeScript backend for maintainability and strong typing.
- Relational database for transactional consistency.
- Structured logging for reliable production diagnostics.

## Data Ownership

- Sessions: Active state, participants, and current question.
- Questions: Ordered list and correct answers.
- Answers: Submissions for scoring and audit.
- Leaderboard: Derived view of participant scores.

## Reliability

- Heartbeats for connection liveness.
- Reconnect with state resync from server.
- Deterministic tie handling to avoid rank flapping.
