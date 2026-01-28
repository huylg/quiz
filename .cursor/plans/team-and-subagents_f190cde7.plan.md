---
name: team-and-subagents
overview: Populate TEAM.md with the specified roles and responsibilities, and add five project-level subagent definitions aligned to those roles for this quiz app.
todos:
  - id: team-doc
    content: Draft TEAM.md agents team with roles and responsibilities.
    status: completed
  - id: pm-agent
    content: Create product-manager subagent with planner workflow.
    status: completed
  - id: design-agent
    content: Create designer subagent focused on UI/UX research.
    status: completed
  - id: backend-agent
    content: Create backend-engineer subagent for system design/impl.
    status: completed
  - id: mobile-agent
    content: Create mobile-engineer subagent for Flutter client app.
    status: completed
  - id: qa-agent
    content: Create qa-engineer subagent for tests and QA workflow.
    status: completed
isProject: false
---

## Approach

- Update [`/Users/huy.ly/personal/quiz/TEAM.md`](/Users/huy.ly/personal/quiz/TEAM.md) with a concise team section listing the five roles and their responsibilities tailored to the real-time quiz described in [`/Users/huy.ly/personal/quiz/SPEC.md`](/Users/huy.ly/personal/quiz/SPEC.md).
- Create five project subagent files under `.cursor/agents/` with clear frontmatter and focused system prompts that mirror each role’s responsibilities and include “use proactively” in the description.

## Files to touch

- [`/Users/huy.ly/personal/quiz/TEAM.md`](/Users/huy.ly/personal/quiz/TEAM.md)
- [`/Users/huy.ly/personal/quiz/.cursor/agents/product-manager.md`](/Users/huy.ly/personal/quiz/.cursor/agents/product-manager.md)
- [`/Users/huy.ly/personal/quiz/.cursor/agents/designer.md`](/Users/huy.ly/personal/quiz/.cursor/agents/designer.md)
- [`/Users/huy.ly/personal/quiz/.cursor/agents/backend-engineer.md`](/Users/huy.ly/personal/quiz/.cursor/agents/backend-engineer.md)
- [`/Users/huy.ly/personal/quiz/.cursor/agents/mobile-engineer.md`](/Users/huy.ly/personal/quiz/.cursor/agents/mobile-engineer.md)
- [`/Users/huy.ly/personal/quiz/.cursor/agents/qa-engineer.md`](/Users/huy.ly/personal/quiz/.cursor/agents/qa-engineer.md)

## Content outline for TEAM.md

- Title: “Agents Team”
- Bulleted list with role name + short responsibility summary tied to the quiz requirements (participation, realtime score updates, leaderboard, nonfunctional requirements).

## Subagent prompt structure (each file)

- YAML frontmatter: `name` and `description` (with “use proactively”).
- Body: role-specific mission, workflow steps, deliverables, and output format.
