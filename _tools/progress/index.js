#!/usr/bin/env node
/**
 * Progress tracker — prints a summary of lesson completion.
 * Usage: npm run progress
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '../..');

function loadCourse() {
  const p = path.join(ROOT, '_course/course.json');
  if (!fs.existsSync(p)) return null;
  return JSON.parse(fs.readFileSync(p, 'utf8'));
}

function loadProgress() {
  const p = path.join(ROOT, '.progress/progress.json');
  if (!fs.existsSync(p)) return { completedLessons: [], quizScores: {}, taskResults: {} };
  return JSON.parse(fs.readFileSync(p, 'utf8'));
}

function bar(pct, width = 30) {
  const filled = Math.round((pct / 100) * width);
  return '[' + '█'.repeat(filled) + '░'.repeat(width - filled) + '] ' + pct + '%';
}

function main() {
  const course = loadCourse();
  if (!course || !course.modules || course.modules.length === 0) {
    console.log('\n📚  No course found. Has the course been generated?\n');
    return;
  }

  const progress = loadProgress();
  const completed = new Set(progress.completedLessons || []);

  let totalLessons = 0;
  let completedCount = 0;

  console.log(`\n📊  Progress: ${course.title || 'Course'}\n`);

  for (const mod of course.modules) {
    const modLessons = mod.lessons || [];
    const modCompleted = modLessons.filter(l => completed.has(l.id)).length;
    const modPct = modLessons.length > 0 ? Math.round((modCompleted / modLessons.length) * 100) : 0;

    console.log(`  ${mod.title}`);
    console.log(`  ${bar(modPct, 20)}  (${modCompleted}/${modLessons.length} lessons)\n`);

    for (const lesson of modLessons) {
      const done = completed.has(lesson.id);
      const quizKey = `${mod.id}-${lesson.id}`;
      const quiz = progress.quizScores && progress.quizScores[quizKey];
      const quizStr = quiz ? ` [Quiz: ${quiz.score}%]` : '';
      console.log(`    ${done ? '✅' : '○'}  ${lesson.title}${quizStr}`);
      totalLessons++;
      if (done) completedCount++;
    }
    console.log('');
  }

  const overallPct = totalLessons > 0 ? Math.round((completedCount / totalLessons) * 100) : 0;
  console.log(`  Overall: ${bar(overallPct)}  (${completedCount}/${totalLessons} lessons)`);

  if (progress.lastActiveAt) {
    const d = new Date(progress.lastActiveAt);
    console.log(`  Last active: ${d.toLocaleDateString()} ${d.toLocaleTimeString()}`);
  }
  console.log('');
}

main();
