#!/usr/bin/env node
/**
 * Lesson checker.
 *
 * Single-course mode:
 *   npm run check module-01 lesson-01
 *
 * Multi-course mode (auto-detected when sibling courses/ directory exists):
 *   npm run check -- intro-to-python module-01 lesson-01
 *   node _tools/grader/check.js --course-dir intro-to-python module-01 lesson-01
 */

const fs   = require('fs');
const path = require('path');

// ─── Context detection ────────────────────────────────────────────────────────
const TEMPLATE_DIR    = path.resolve(__dirname, '../..');
const PARENT_DIR      = path.resolve(TEMPLATE_DIR, '..');
const SIBLING_COURSES = path.join(PARENT_DIR, 'courses');
const IS_MULTI        = fs.existsSync(SIBLING_COURSES) && fs.statSync(SIBLING_COURSES).isDirectory();

// ─── Arg parsing ──────────────────────────────────────────────────────────────
const argv = process.argv.slice(2);
let courseDirArg = null;
const remaining  = [];
for (let i = 0; i < argv.length; i++) {
  if (argv[i] === '--course-dir') { courseDirArg = argv[++i]; continue; }
  remaining.push(argv[i]);
}

// In multi-course mode, first positional arg is the course slug if --course-dir not set
if (!courseDirArg && IS_MULTI && remaining.length >= 3) courseDirArg = remaining.shift();

function resolveArg(val) {
  if (!val) return null;
  if (path.isAbsolute(val) || val.startsWith('.')) return path.resolve(val);
  return path.join(SIBLING_COURSES, val);
}

const COURSE_DIR = resolveArg(courseDirArg) || TEMPLATE_DIR;

// ─── Helpers ──────────────────────────────────────────────────────────────────
function loadCourse() {
  const p = path.join(COURSE_DIR, '_course/course.json');
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
  if (!fs.existsSync(testFile)) return { skipped: true };
  try {
    const result = require(testFile);
    return typeof result === 'function' ? result() : result;
  } catch (err) {
    return { passed: false, error: err.message };
  }
}

function checkHtmlExercise(exerciseFile) {
  if (!fs.existsSync(exerciseFile)) return { passed: false, error: 'Exercise file not found: ' + exerciseFile };
  const content = fs.readFileSync(exerciseFile, 'utf8').trim();
  if (content.includes('<!-- YOUR CODE HERE -->') || content.length < 50) {
    return { passed: false, error: 'Exercise file appears to be unchanged. Did you complete it?' };
  }
  return { passed: true, message: 'Exercise file has content.' };
}

function saveProgress(moduleId, lessonId, result) {
  const progressDir  = path.join(COURSE_DIR, '.progress');
  const progressFile = path.join(progressDir, 'progress.json');
  let progress = {};
  if (fs.existsSync(progressFile)) progress = JSON.parse(fs.readFileSync(progressFile, 'utf8'));
  if (!progress.taskResults) progress.taskResults = {};
  progress.taskResults[`${moduleId}-${lessonId}`] = { completed: result.passed, completedAt: new Date().toISOString() };
  if (result.passed) {
    if (!progress.completedLessons) progress.completedLessons = [];
    if (!progress.completedLessons.includes(lessonId)) progress.completedLessons.push(lessonId);
  }
  progress.lastActiveAt = new Date().toISOString();
  if (!fs.existsSync(progressDir)) fs.mkdirSync(progressDir, { recursive: true });
  fs.writeFileSync(progressFile, JSON.stringify(progress, null, 2));
}

// ─── Main ─────────────────────────────────────────────────────────────────────
async function main() {
  const course = loadCourse();

  if (remaining.length === 0) {
    console.log('\n📚  Available lessons:\n');
    for (const mod of course.modules) {
      console.log(`  ${mod.id}: ${mod.title}`);
      for (const lesson of mod.lessons) console.log(`    ${lesson.id}: ${lesson.title}`);
    }
    if (IS_MULTI) console.log('\nUsage: npm run check -- <slug> <module-id> <lesson-id>\n');
    else           console.log('\nUsage: npm run check <module-id> <lesson-id>\n');
    return;
  }

  const [moduleId, lessonId] = remaining;
  const lesson = findLesson(course, moduleId, lessonId);
  if (!lesson) { console.error(`❌  Lesson "${moduleId}/${lessonId}" not found in course.json`); process.exit(1); }

  console.log(`\n🔍  Checking: ${lesson.title}\n`);
  const results = [];

  if (lesson.files?.exercise) {
    results.push({ name: 'Exercise file', ...checkHtmlExercise(path.join(COURSE_DIR, lesson.files.exercise)) });
  }

  const testFile = path.join(COURSE_DIR, '_course/lessons', moduleId, lessonId, 'tests', 'check.js');
  const testResult = runTestFile(testFile);
  if (!testResult.skipped) results.push({ name: 'Lesson tests', ...testResult });

  let allPassed = true;
  for (const r of results) {
    if (r.passed) console.log(`  ✅  ${r.name}: ${r.message || 'Passed'}`);
    else { console.log(`  ❌  ${r.name}: ${r.error || 'Failed'}`); allPassed = false; }
  }

  if (results.length === 0) { console.log('  ℹ️   No checks defined for this lesson yet.'); allPassed = true; }

  console.log('');
  if (allPassed) { console.log('✅  All checks passed!'); saveProgress(moduleId, lessonId, { passed: true }); }
  else           { console.log('❌  Some checks failed. Review the errors above and try again.'); saveProgress(moduleId, lessonId, { passed: false }); }
  console.log('');
}

main().catch(err => { console.error('Unexpected error:', err.message); process.exit(1); });
