#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const args = process.argv.slice(2);
const slug = args[0];
const title = args.slice(1).join(' ') || slug;

if (!slug) {
  console.error('Usage: npm run add-course -- <slug> ["Course Title"]');
  console.error('Example: npm run add-course -- intro-to-python "Introduction to Python"');
  process.exit(1);
}

if (!/^[a-z0-9-]+$/.test(slug)) {
  console.error('Slug must be lowercase letters, numbers, and hyphens only.');
  process.exit(1);
}

const root = path.join(__dirname, '..');
const courseDir = path.join(root, 'courses', slug);

if (fs.existsSync(courseDir)) {
  console.error(`Course "${slug}" already exists at courses/${slug}/`);
  process.exit(1);
}

const dirs = [
  '_teacher',
  '_teacher/resources/slides',
  '_teacher/resources/past-questions',
  '_teacher/resources/exercises',
  '_teacher/resources/readings',
  '_teacher/resources/datasets',
  '_teacher/resources/syllabus',
  '_course',
  '_assessments/quizzes',
  '_assessments/tasks',
  '_assessments/rubrics',
];

for (const dir of dirs) {
  fs.mkdirSync(path.join(courseDir, dir), { recursive: true });
}

// .gitkeep for empty folders that won't have files yet
const generated = ['_course', '_assessments/quizzes', '_assessments/tasks', '_assessments/rubrics'];
for (const dir of generated) {
  fs.writeFileSync(path.join(courseDir, dir, '.gitkeep'), '');
}
for (const dir of ['slides', 'past-questions', 'exercises', 'readings', 'datasets', 'syllabus']) {
  fs.writeFileSync(path.join(courseDir, '_teacher/resources', dir, '.gitkeep'), '');
}

fs.writeFileSync(path.join(courseDir, '_teacher/course-description.md'), `# Course Description

**Course title:** ${title}

**Subject area:** <!-- e.g. Programming, Mathematics, Design, Science -->

**Target audience:** <!-- e.g. High school students, adult learners, complete beginners -->

**Approximate duration:** <!-- e.g. 4 hours, 2 weeks, 6 lessons -->

## Overview

<!-- Describe the course in 2–4 paragraphs.
     Cover: what it teaches, why it matters, and how it is structured. -->

## Topics covered

- <!-- Topic 1 -->
- <!-- Topic 2 -->
- <!-- Topic 3 -->
`);

fs.writeFileSync(path.join(courseDir, '_teacher/requirements.md'), `# Learning Requirements

## Learning outcomes

After completing this course, students will be able to:

1. <!-- Outcome 1 — use action verbs: explain, build, identify, apply, create -->
2. <!-- Outcome 2 -->
3. <!-- Outcome 3 -->

## Prerequisites

<!-- What should students already know before starting? Write "None" if zero. -->

- None

## Constraints

<!-- Any constraints on structure, delivery, or audience?
     e.g. "no coding required", "suitable for ages 12–14", "must work offline" -->

- <!-- constraint or remove this section -->

## Structure (optional)

<!-- Target module/lesson counts. Claude will decide if left blank. -->

- Modules: <!-- e.g. 3–4 -->
- Lessons per module: <!-- e.g. 3–5 -->
`);

fs.writeFileSync(path.join(courseDir, '_teacher/grading-policy.md'), `# Grading Policy

## Quiz passing score

Minimum score to pass a quiz: **70%**

## Retakes

Students may retake quizzes: **unlimited times**

## Solutions policy

<!-- When can students view solution files?
     Options: after-attempt | after-passing | always | never -->

Solutions visible: **after-passing**

## Final grade weighting (optional)

<!-- Remove this section if there is no cumulative grade. -->

| Assessment | Weight |
|---|---|
| Quizzes    | 50%    |
| Tasks      | 50%    |
`);

console.log(`
Course "${slug}" created at courses/${slug}/

Fill in these files before asking Claude to generate the course:

  courses/${slug}/_teacher/course-description.md   ← what the course covers
  courses/${slug}/_teacher/requirements.md         ← outcomes and constraints
  courses/${slug}/_teacher/grading-policy.md       ← quiz and solution rules

Drop any supporting materials into:

  courses/${slug}/_teacher/resources/slides/         ← slide decks (sets lesson order)
  courses/${slug}/_teacher/resources/syllabus/       ← syllabus (sets module structure)
  courses/${slug}/_teacher/resources/past-questions/ ← past exams (informs quizzes)
  courses/${slug}/_teacher/resources/exercises/      ← worksheets to adapt
  courses/${slug}/_teacher/resources/readings/       ← reference texts
  courses/${slug}/_teacher/resources/datasets/       ← data files for examples

When ready, open Claude Code in this folder and say:
  "create the course for ${slug}"
`);
