# tutor-courses — Claude Code Instructions

This repo is a **multi-course hub** built on top of the tutor template.

- `base/` — the tutor template (git subtree). Do not edit files inside `base/` directly.
- `courses/<slug>/` — one directory per course. This is where all course work happens.

---

## How this differs from a standalone tutor fork

In a standalone tutor fork, course content lives at the repo root (`_course/`, `_assessments/`, etc.).
Here, each course has its own root: `courses/<slug>/`.

**Always write course files under `courses/<slug>/`, never at the repo root.**

| Standalone tutor path | Multi-course path |
|---|---|
| `_course/course.json` | `courses/<slug>/_course/course.json` |
| `_course/lessons/…` | `courses/<slug>/_course/lessons/…` |
| `_assessments/quizzes/…` | `courses/<slug>/_assessments/quizzes/…` |
| `_course/clarifications/…` | `courses/<slug>/_course/clarifications/…` |
| `_teacher/…` | `courses/<slug>/_teacher/…` |

---

## Detecting which course to work on

If the user says "work on intro-to-python" or "create the course for intro-to-python":
- The course root is `courses/intro-to-python/`
- Read teacher files from `courses/intro-to-python/_teacher/`
- Write all generated content under `courses/intro-to-python/`

If no slug is mentioned and only one course folder exists under `courses/`, assume that one.
If multiple courses exist and no slug is mentioned, ask: "Which course? (list slugs)"

---

## Creating a new course

When asked to create a course for slug `<slug>`:

1. Read `courses/<slug>/_teacher/course-description.md`
2. Read `courses/<slug>/_teacher/requirements.md`
3. Read `courses/<slug>/_teacher/grading-policy.md`
4. Scan `courses/<slug>/_teacher/resources/` for any materials
5. Generate all content under `courses/<slug>/` following the lesson format rules in the
   tutor CLAUDE.md (reproduced below for reference)

All paths in `course.json`, quiz files, and task files must be relative to the repo root,
prefixed with `courses/<slug>/`. Example:

```json
"lesson": "courses/intro-to-python/_course/lessons/module-01/lesson-01/lesson.md"
```

---

## Running commands

The base tools auto-detect the multi-course layout. Pass the course slug as the argument.

| Task | Command |
|---|---|
| Preview a course in browser | `npm run dev -- <slug>` |
| Check a lesson | `npm run check -- <slug> <module-id> <lesson-id>` |
| Build one course (offline HTML) | `npm run build-course -- <slug>` |
| Build all courses + landing page | `npm run build` |
| Add a new course scaffold | `npm run add-course -- <slug> "Title"` |
| List all courses and status | `npm run list-courses` |
| Pull latest tutor template | `npm run update-base` |

---

## Lesson format and course.json structure

Follow the same rules as in `base/CLAUDE.md`. Key points:

- `lesson.md` must use the Goal / Concept / Example / Task / Check / Reflection structure
- `course.json` must be valid JSON matching the schema in `base/CLAUDE.md`
- Quiz files follow the multiple-choice / true-false schema
- Do not leave `solution.*` files empty
- Do not modify any file under `base/`

---

## Clarifications (student questions)

When a student asks for a better explanation, save the clarification at:

```
courses/<slug>/_course/clarifications/<module-id>-<lesson-id>/<question-slug>.md
```

And update (or create):

```
courses/<slug>/_course/clarifications/index.json
```

Tell the student the clarification has been saved and will appear in the course viewer.

---

## What NOT to do

- Do not edit any file inside `base/` — it is a git subtree and changes will be lost on `update-base`
- Do not write course content at the repo root
- Do not create a `dist/` folder manually — `npm run build` handles that
- Do not delete `courses/<slug>/_teacher/` files
- Do not delete `courses/<slug>/_course/lessons/*/solution.*` files
