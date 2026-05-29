#!/usr/bin/env node
/**
 * Lesson checker — runs validation for a specific lesson's exercise file.
 * Usage: node _tools/grader/check.js [module-id] [lesson-id]
 * Example: npm run check module-01 lesson-01
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '../..');

function loadCourse() {
  const p = path.join(ROOT, '_course/course.json');
  if (!fs.existsSync(p)) {
    console.error('❌  _course/course.json not found. Has the course been generated?');
    process.exit(1);
  }
  return JSON.parse(fs.readFileSync(p, 'utf8'));
}

function findLesson(course, moduleId, lessonId) {
  const mod = course.modules.find(m => m.id === moduleId);
  if (!mod) return null;
  return mod.lessons.find(l => l.id === lessonId) || null;
}

function runTestFile(testFile) {
  if (!fs.existsSync(testFile)) {
    return { skipped: true, reason: 'No test file found at ' + testFile };
  }
  try {
    const result = require(testFile);
    if (typeof result === 'function') {
      return result();
    }
    return result;
  } catch (err) {
    return { passed: false, error: err.message };
  }
}

function checkHtmlExercise(exerciseFile) {
  if (!fs.existsSync(exerciseFile)) {
    return { passed: false, error: 'Exercise file not found: ' + exerciseFile };
  }
  const content = fs.readFileSync(exerciseFile, 'utf8').trim();
  const isStarter = content.includes('<!-- YOUR CODE HERE -->') || content.length < 50;
  if (isStarter) {
    return { passed: false, error: 'Exercise file appears to be unchanged. Did you complete it?' };
  }
  return { passed: true, message: 'Exercise file has content.' };
}

function saveProgress(moduleId, lessonId, result) {
  const progressDir = path.join(ROOT, '.progress');
  const progressFile = path.join(progressDir, 'progress.json');

  let progress = {};
  if (fs.existsSync(progressFile)) {
    progress = JSON.parse(fs.readFileSync(progressFile, 'utf8'));
  }
  if (!progress.taskResults) progress.taskResults = {};
  progress.taskResults[`${moduleId}-${lessonId}`] = {
    completed: result.passed,
    completedAt: new Date().toISOString()
  };
  if (result.passed && !progress.completedLessons) {
    progress.completedLessons = [];
  }
  if (result.passed && !progress.completedLessons.includes(lessonId)) {
    progress.completedLessons.push(lessonId);
  }
  progress.lastActiveAt = new Date().toISOString();
  fs.writeFileSync(progressFile, JSON.stringify(progress, null, 2));
}

async function main() {
  const args = process.argv.slice(2);
  const course = loadCourse();

  if (args.length === 0) {
    console.log('\n📚  Available lessons:\n');
    for (const mod of course.modules) {
      console.log(`  ${mod.id}: ${mod.title}`);
      for (const lesson of mod.lessons) {
        console.log(`    ${lesson.id}: ${lesson.title}`);
      }
    }
    console.log('\nUsage: npm run check <module-id> <lesson-id>\n');
    return;
  }

  const [moduleId, lessonId] = args;
  const lesson = findLesson(course, moduleId, lessonId);

  if (!lesson) {
    console.error(`❌  Lesson "${moduleId}/${lessonId}" not found in course.json`);
    process.exit(1);
  }

  console.log(`\n🔍  Checking: ${lesson.title}\n`);

  const results = [];

  // Check exercise file exists and has been edited
  if (lesson.files && lesson.files.exercise) {
    const exerciseFile = path.join(ROOT, lesson.files.exercise);
    const exResult = checkHtmlExercise(exerciseFile);
    results.push({ name: 'Exercise file', ...exResult });
  }

  // Run custom test file if it exists
  const testFile = path.join(ROOT, '_course/lessons', moduleId, lessonId, 'tests', 'check.js');
  const testResult = runTestFile(testFile);
  if (!testResult.skipped) {
    results.push({ name: 'Lesson tests', ...testResult });
  }

  // Report
  let allPassed = true;
  for (const r of results) {
    if (r.passed) {
      console.log(`  ✅  ${r.name}: ${r.message || 'Passed'}`);
    } else {
      console.log(`  ❌  ${r.name}: ${r.error || 'Failed'}`);
      allPassed = false;
    }
  }

  if (results.length === 0) {
    console.log('  ℹ️   No checks defined for this lesson yet.');
    allPassed = true;
  }

  console.log('');
  if (allPassed) {
    console.log('✅  All checks passed! Mark this lesson complete in index.html.');
    saveProgress(moduleId, lessonId, { passed: true });
  } else {
    console.log('❌  Some checks failed. Review the errors above and try again.');
    saveProgress(moduleId, lessonId, { passed: false });
  }
  console.log('');
}

main().catch(err => {
  console.error('Unexpected error:', err.message);
  process.exit(1);
});
