#!/usr/bin/env node
/**
 * Submission client — sends progress and assessment results to the teacher API.
 * Usage: npm run submit
 *
 * Requires:
 *   - _course/course.json with apiSubmission.enabled = true and apiSubmission.endpoint set
 *   - .progress/progress.json with quiz/task results
 */

const fs = require('fs');
const path = require('path');
const https = require('https');
const http = require('http');

const ROOT = path.resolve(__dirname, '../..');

function loadCourse() {
  const p = path.join(ROOT, '_course/course.json');
  if (!fs.existsSync(p)) {
    console.error('❌  _course/course.json not found.');
    process.exit(1);
  }
  return JSON.parse(fs.readFileSync(p, 'utf8'));
}

function loadProgress() {
  const p = path.join(ROOT, '.progress/progress.json');
  if (!fs.existsSync(p)) {
    console.log('ℹ️   No progress file found. Complete some lessons first.');
    process.exit(0);
  }
  return JSON.parse(fs.readFileSync(p, 'utf8'));
}

function post(endpoint, payload) {
  return new Promise((resolve, reject) => {
    const url = new URL(endpoint);
    const body = JSON.stringify(payload);
    const options = {
      hostname: url.hostname,
      port: url.port || (url.protocol === 'https:' ? 443 : 80),
      path: url.pathname + url.search,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(body)
      }
    };
    const lib = url.protocol === 'https:' ? https : http;
    const req = lib.request(options, res => {
      let data = '';
      res.on('data', chunk => { data += chunk; });
      res.on('end', () => resolve({ status: res.statusCode, body: data }));
    });
    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

async function main() {
  const course = loadCourse();
  const progress = loadProgress();

  if (!course.apiSubmission || !course.apiSubmission.enabled) {
    console.log('ℹ️   API submission is not enabled for this course.');
    console.log('    Your progress is saved locally in .progress/progress.json');
    console.log('    Ask your teacher if they want you to submit results online.\n');
    return;
  }

  const endpoint = course.apiSubmission.endpoint;
  if (!endpoint) {
    console.error('❌  No endpoint configured in course.json apiSubmission.endpoint');
    process.exit(1);
  }

  const payload = {
    courseId: course.apiSubmission.courseId || course.id,
    submittedAt: new Date().toISOString(),
    completedLessons: progress.completedLessons || [],
    quizScores: progress.quizScores || {},
    taskResults: progress.taskResults || {},
    reflections: progress.reflections || {}
  };

  console.log(`\n📤  Submitting results to: ${endpoint}`);
  console.log(`    Lessons completed: ${payload.completedLessons.length}`);
  console.log(`    Quiz scores: ${Object.keys(payload.quizScores).length} quizzes\n`);

  try {
    const res = await post(endpoint, payload);
    if (res.status >= 200 && res.status < 300) {
      console.log('✅  Submitted successfully.\n');
    } else {
      console.error(`❌  Submission failed. Server responded with status ${res.status}`);
      console.error('    Response:', res.body);
      process.exit(1);
    }
  } catch (err) {
    console.error('❌  Could not connect to submission server:', err.message);
    console.log('    Your results are saved locally. Try again when online.\n');
    process.exit(1);
  }
}

main();
