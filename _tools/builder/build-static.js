#!/usr/bin/env node
/**
 * Static site builder.
 *
 * Single-course mode (default — running inside a standalone tutor fork):
 *   npm run build
 *
 * Multi-course mode (auto-detected when a sibling courses/ directory exists):
 *   npm run build-course -- intro-to-python
 *   node _tools/builder/build-static.js --course-dir intro-to-python
 *
 * When --course-dir is a slug (no slashes), it is resolved relative to the
 * sibling courses/ directory.  An absolute or relative path is used as-is.
 * --out-dir follows the same resolution: slug → sibling dist/<slug>/, otherwise as-is.
 */

const fs   = require('fs');
const path = require('path');

// ─── Context detection ────────────────────────────────────────────────────────
const TEMPLATE_DIR   = path.resolve(__dirname, '../..');          // tutor base
const PARENT_DIR     = path.resolve(TEMPLATE_DIR, '..');          // repo root above base
const SIBLING_COURSES = path.join(PARENT_DIR, 'courses');
const IS_MULTI       = fs.existsSync(SIBLING_COURSES) && fs.statSync(SIBLING_COURSES).isDirectory();

// ─── Arg parsing ──────────────────────────────────────────────────────────────
const argv = process.argv.slice(2);
let courseDirArg = null;
let outDirArg    = null;
for (let i = 0; i < argv.length; i++) {
  if (argv[i] === '--course-dir') { courseDirArg = argv[++i]; continue; }
  if (argv[i] === '--out-dir')    { outDirArg    = argv[++i]; continue; }
  // First bare positional arg treated as course-dir slug in multi-course mode
  if (!courseDirArg && IS_MULTI && !argv[i].startsWith('-')) courseDirArg = argv[i];
}

function resolveArg(val, siblingSubdir) {
  if (!val) return null;
  if (path.isAbsolute(val) || val.startsWith('.')) return path.resolve(val);
  return path.join(PARENT_DIR, siblingSubdir, val);
}

const COURSE_DIR = resolveArg(courseDirArg, 'courses') || TEMPLATE_DIR;
const OUT_DIR    = resolveArg(outDirArg,    'dist')
                || (IS_MULTI && courseDirArg
                      ? path.join(PARENT_DIR, 'dist', path.basename(COURSE_DIR))
                      : path.join(TEMPLATE_DIR, 'dist'));

// ─── Helpers ──────────────────────────────────────────────────────────────────
const readFrom     = (base, rel) => { const f = path.join(base, rel); return fs.existsSync(f) ? fs.readFileSync(f, 'utf8') : null; };
const readJsonFrom = (base, rel) => { const r = readFrom(base, rel); if (!r) return null; try { return JSON.parse(r); } catch { return null; } };
const readCourse   = rel => readFrom(COURSE_DIR, rel);
const readTemplate = rel => readFrom(TEMPLATE_DIR, rel);
const readCourseJson = rel => readJsonFrom(COURSE_DIR, rel);

// ─── Main ─────────────────────────────────────────────────────────────────────
async function main() {
  console.log('\n🔨  Building static site...\n');

  const course = readCourseJson('_course/course.json');
  if (!course) { console.error('  ✗  _course/course.json not found. Generate the course first.\n'); process.exit(1); }
  if (!course.modules?.length) { console.error('  ✗  Course has no modules yet. Generate the course content first.\n'); process.exit(1); }
  console.log(`  Course: ${course.title}`);

  const lessons = {};
  const quizzes = {};
  let lessonCount = 0;

  for (const mod of course.modules) {
    for (const lesson of (mod.lessons || [])) {
      if (lesson.files?.lesson) {
        const content = readCourse(lesson.files.lesson);
        if (content) { lessons[lesson.files.lesson] = content; lessonCount++; }
      }
      if (lesson.quiz) {
        const q = readCourseJson(lesson.quiz);
        if (q) quizzes[lesson.quiz] = q;
      }
    }
  }
  console.log(`  Lessons: ${lessonCount}`);

  let clarificationsIndex = {};
  const clarifications = {};
  const clarIdx = readCourseJson('_course/clarifications/index.json');
  if (clarIdx) {
    clarificationsIndex = clarIdx;
    for (const entries of Object.values(clarIdx)) {
      for (const entry of (entries || [])) {
        if (entry.file) { const c = readCourse(entry.file); if (c) clarifications[entry.file] = c; }
      }
    }
  }

  let markedJs = null;
  for (const p of ['node_modules/marked/marked.min.js', 'node_modules/marked/src/marked.js']) {
    const src = readTemplate(p);
    if (src) { markedJs = src; break; }
  }

  const template = readTemplate('index.html');
  if (!template) { console.error('  ✗  index.html not found.\n'); process.exit(1); }

  const data = { course, lessons, quizzes, clarificationsIndex, clarifications };

  const injectedScript = `
<script>
/* ── Tutor static build: embedded course data + fetch override ── */
(function () {
  var D = ${JSON.stringify(data)};
  var _f = window.fetch;
  function mock(body, isJson) {
    return Promise.resolve({
      ok: true, status: 200,
      text: function () { return Promise.resolve(isJson ? JSON.stringify(body) : body); },
      json: function () { return Promise.resolve(isJson ? body : JSON.parse(body)); }
    });
  }
  window.fetch = function (url) {
    if (url === '_course/course.json')               return mock(D.course, true);
    if (url === '_course/clarifications/index.json') return mock(D.clarificationsIndex, true);
    if (D.lessons        && url in D.lessons)        return mock(D.lessons[url],        false);
    if (D.quizzes        && url in D.quizzes)        return mock(D.quizzes[url],        true);
    if (D.clarifications && url in D.clarifications) return mock(D.clarifications[url], false);
    return _f ? _f.apply(this, arguments) : Promise.reject(new Error('Not found: ' + url));
  };
})();
</script>`;

  let out = template;
  if (markedJs) {
    out = out.replace(/<script src="https:\/\/cdn\.jsdelivr\.net\/npm\/marked[^"]*"><\/script>/, `<script>${markedJs}</script>`);
  }
  out = out.replace('</head>', injectedScript + '\n</head>');

  if (!fs.existsSync(OUT_DIR)) fs.mkdirSync(OUT_DIR, { recursive: true });
  const outPath = path.join(OUT_DIR, 'index.html');
  fs.writeFileSync(outPath, out, 'utf8');
  fs.writeFileSync(path.join(OUT_DIR, '.nojekyll'), '');

  const kb = Math.round(fs.statSync(outPath).size / 1024);
  console.log(`\n✅  ${outPath}  (${kb} KB)\n`);
  console.log('  Open directly in any browser — no server needed.');
  console.log('  Or run:  npx serve dist\n');
}

main().catch(err => { console.error('Build failed:', err.message); process.exit(1); });
