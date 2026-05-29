#!/usr/bin/env node
/**
 * Build every generated course under courses/ into dist/<slug>/,
 * then write a dist/index.html landing page listing them all.
 *
 * Usage: npm run build
 */

const fs   = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ROOT       = path.join(__dirname, '..');
const BASE_DIR   = path.join(ROOT, 'base');
const COURSES_DIR = path.join(ROOT, 'courses');
const DIST_DIR   = path.join(ROOT, 'dist');
const BUILDER    = path.join(BASE_DIR, '_tools/builder/build-static.js');

// ─── Helpers ──────────────────────────────────────────────────────────────────
function getCourseSlugs() {
  if (!fs.existsSync(COURSES_DIR)) return [];
  return fs.readdirSync(COURSES_DIR).filter(f =>
    fs.statSync(path.join(COURSES_DIR, f)).isDirectory()
  );
}

function getCourseMeta(slug) {
  const p = path.join(COURSES_DIR, slug, '_course/course.json');
  if (!fs.existsSync(p)) return null;
  try { return JSON.parse(fs.readFileSync(p, 'utf8')); } catch { return null; }
}

function buildLandingPage(entries) {
  const cards = entries.map(({ slug, title, description, level }) => `
    <div class="card">
      ${level ? `<span class="level">${level}</span>` : ''}
      <h2><a href="${slug}/">${title}</a></h2>
      ${description ? `<p>${description}</p>` : ''}
      <a class="btn" href="${slug}/">Start →</a>
    </div>`).join('\n');

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Courses</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: system-ui, sans-serif; background: #f5f6fa; color: #212529; }
    header { background: #1a1a2e; color: #fff; padding: 2.5rem 1.5rem; text-align: center; }
    header h1 { font-size: 2rem; letter-spacing: -.02em; }
    header p  { margin-top: .4rem; opacity: .7; font-size: .95rem; }
    .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(270px, 1fr)); gap: 1.25rem; max-width: 1080px; margin: 2rem auto; padding: 0 1.25rem; }
    .card { background: #fff; border-radius: 8px; padding: 1.5rem; box-shadow: 0 1px 6px rgba(0,0,0,.08); display: flex; flex-direction: column; gap: .6rem; }
    .level { font-size: .7rem; text-transform: uppercase; letter-spacing: .06em; color: #6c757d; }
    h2 { font-size: 1.15rem; }
    h2 a { color: inherit; text-decoration: none; }
    h2 a:hover { color: #0057d8; }
    p { font-size: .875rem; color: #495057; line-height: 1.55; flex: 1; }
    .btn { align-self: flex-start; background: #0057d8; color: #fff; padding: .35rem .85rem; border-radius: 4px; font-size: .85rem; text-decoration: none; margin-top: .25rem; }
    .btn:hover { background: #0041a8; }
    .empty { text-align: center; color: #6c757d; padding: 5rem 1rem; }
  </style>
</head>
<body>
  <header>
    <h1>Courses</h1>
    <p>${entries.length} course${entries.length !== 1 ? 's' : ''} available</p>
  </header>
  <main>
    ${entries.length ? `<div class="grid">${cards}\n  </div>` : '<p class="empty">No courses have been generated yet.</p>'}
  </main>
</body>
</html>`;
}

// ─── Main ─────────────────────────────────────────────────────────────────────
async function main() {
  if (!fs.existsSync(path.join(BASE_DIR, 'node_modules'))) {
    console.error('\n✗  base/node_modules not found. Run: npm run install-base\n');
    process.exit(1);
  }

  if (!fs.existsSync(DIST_DIR)) fs.mkdirSync(DIST_DIR, { recursive: true });
  fs.writeFileSync(path.join(DIST_DIR, '.nojekyll'), '');

  const slugs   = getCourseSlugs();
  const built   = [];
  const skipped = [];

  for (const slug of slugs) {
    if (!fs.existsSync(path.join(COURSES_DIR, slug, '_course/course.json'))) {
      console.log(`  ⚠  Skipping ${slug} — _course/course.json not found (not yet generated)`);
      skipped.push(slug);
      continue;
    }
    console.log(`\n  Building: ${slug}`);
    // base script auto-detects courses/ sibling, so slug is enough
    execSync(`node "${BUILDER}" "${slug}"`, { cwd: ROOT, stdio: 'inherit' });
    built.push(slug);
  }

  // Landing page lists only successfully built courses
  const entries = built.map(slug => {
    const meta = getCourseMeta(slug);
    return { slug, title: meta?.title || slug, description: meta?.description || '', level: meta?.level || '' };
  });

  fs.writeFileSync(path.join(DIST_DIR, 'index.html'), buildLandingPage(entries), 'utf8');

  console.log(`\n✅  Built ${built.length} course${built.length !== 1 ? 's' : ''} → dist/`);
  if (skipped.length) console.log(`   Skipped (not generated): ${skipped.join(', ')}`);
  console.log(`   Landing page: dist/index.html`);
  if (built.length) console.log(`   Courses:      ${built.map(s => `dist/${s}/`).join('  ')}`);
  console.log('');
}

main().catch(err => { console.error('Build failed:', err.message); process.exit(1); });
