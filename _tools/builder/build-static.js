#!/usr/bin/env node
/**
 * Static site builder.
 * Reads the live index.html + all course data, then produces dist/index.html —
 * a single self-contained file that works offline (no server, no VS Code).
 *
 * Strategy: override window.fetch in the output so the existing index.html JS
 * continues to work unchanged. All course data is embedded as JSON.
 *
 * Usage: npm run build
 */

const fs   = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '../..');

// ─── Helpers ──────────────────────────────────────────────────────────────────

function read(rel) {
  const full = path.join(ROOT, rel);
  return fs.existsSync(full) ? fs.readFileSync(full, 'utf8') : null;
}

function readJson(rel) {
  const raw = read(rel);
  if (!raw) return null;
  try { return JSON.parse(raw); } catch { return null; }
}

// ─── Main ─────────────────────────────────────────────────────────────────────

async function main() {
  console.log('\n🔨  Building static site...\n');

  // 1. Load course
  const course = readJson('_course/course.json');
  if (!course) {
    console.error('  ✗  _course/course.json not found. Generate the course first.\n');
    process.exit(1);
  }
  if (!course.modules || course.modules.length === 0) {
    console.error('  ✗  Course has no modules yet. Generate the course content first.\n');
    process.exit(1);
  }
  console.log(`  Course: ${course.title}`);

  // 2. Collect all lesson markdown (raw — marked.js in the browser renders it)
  const lessons = {};
  const quizzes = {};
  let lessonCount = 0;

  for (const mod of course.modules) {
    for (const lesson of (mod.lessons || [])) {
      if (lesson.files && lesson.files.lesson) {
        const content = read(lesson.files.lesson);
        if (content) { lessons[lesson.files.lesson] = content; lessonCount++; }
      }
      if (lesson.quiz) {
        const q = readJson(lesson.quiz);
        if (q) quizzes[lesson.quiz] = q;
      }
    }
  }
  console.log(`  Lessons: ${lessonCount}`);

  // 3. Collect clarifications
  let clarificationsIndex = {};
  const clarifications = {};

  const clarIdx = readJson('_course/clarifications/index.json');
  if (clarIdx) {
    clarificationsIndex = clarIdx;
    for (const key of Object.keys(clarIdx)) {
      for (const entry of (clarIdx[key] || [])) {
        if (entry.file) {
          const content = read(entry.file);
          if (content) clarifications[entry.file] = content;
        }
      }
    }
  }

  // 4. Try to inline marked.js for offline support
  const markedCandidates = [
    'node_modules/marked/marked.min.js',
    'node_modules/marked/src/marked.js',
  ];
  let markedJs = null;
  for (const p of markedCandidates) {
    const src = read(p);
    if (src) { markedJs = src; break; }
  }

  // 5. Read index.html as the base template
  const template = read('index.html');
  if (!template) {
    console.error('  ✗  index.html not found.\n');
    process.exit(1);
  }

  // 6. Build the fetch-override + data injection script
  const data = { course, lessons, quizzes, clarificationsIndex, clarifications };
  const dataJson = JSON.stringify(data);

  const injectedScript = `
<script>
/* ── Tutor static build: embedded course data + fetch override ── */
(function () {
  var D = ${dataJson};
  var _f = window.fetch;
  function mock(body, isJson) {
    return Promise.resolve({
      ok: true,
      status: 200,
      text: function () { return Promise.resolve(isJson ? JSON.stringify(body) : body); },
      json: function () { return Promise.resolve(isJson ? body : JSON.parse(body)); }
    });
  }
  window.fetch = function (url) {
    if (url === '_course/course.json')                  return mock(D.course, true);
    if (url === '_course/clarifications/index.json')    return mock(D.clarificationsIndex, true);
    if (D.lessons      && url in D.lessons)             return mock(D.lessons[url],      false);
    if (D.quizzes      && url in D.quizzes)             return mock(D.quizzes[url],      true);
    if (D.clarifications && url in D.clarifications)    return mock(D.clarifications[url], false);
    return _f ? _f.apply(this, arguments) : Promise.reject(new Error('Not found: ' + url));
  };
})();
</script>`;

  // 7. Patch the template
  let out = template;

  // Inline marked.js if available (enables full offline use)
  if (markedJs) {
    out = out.replace(
      /<script src="https:\/\/cdn\.jsdelivr\.net\/npm\/marked[^"]*"><\/script>/,
      `<script>${markedJs}</script>`
    );
  }

  // Inject the data + fetch override just before </head>
  out = out.replace('</head>', injectedScript + '\n</head>');

  // 8. Write output
  const distDir = path.join(ROOT, 'dist');
  if (!fs.existsSync(distDir)) fs.mkdirSync(distDir, { recursive: true });

  const outPath = path.join(distDir, 'index.html');
  fs.writeFileSync(outPath, out, 'utf8');

  // .nojekyll so GitHub Pages doesn't strip _course/ paths referenced in data
  fs.writeFileSync(path.join(distDir, '.nojekyll'), '');

  const kb = Math.round(fs.statSync(outPath).size / 1024);
  console.log(`\n✅  dist/index.html  (${kb} KB)\n`);
  console.log('  Open directly in any browser — no server needed.');
  console.log('  Or run:  npx serve dist\n');
}

main().catch(err => {
  console.error('Build failed:', err.message);
  process.exit(1);
});
