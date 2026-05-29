#!/usr/bin/env node
/**
 * Static file server for course preview.
 *
 * Single-course mode:
 *   npm start
 *
 * Multi-course mode (auto-detected when sibling courses/ directory exists):
 *   npm run dev -- intro-to-python
 *   node _tools/preview/serve.js --course-dir intro-to-python
 *
 * In multi-course mode, requests for /_course/** and /_assessments/** are
 * served from the course directory; everything else from the tutor base.
 */

const http = require('http');
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
for (let i = 0; i < argv.length; i++) {
  if (argv[i] === '--course-dir') { courseDirArg = argv[++i]; continue; }
  if (!courseDirArg && IS_MULTI && !argv[i].startsWith('-')) courseDirArg = argv[i];
}

function resolveArg(val) {
  if (!val) return null;
  if (path.isAbsolute(val) || val.startsWith('.')) return path.resolve(val);
  return path.join(SIBLING_COURSES, val);
}

const COURSE_DIR = resolveArg(courseDirArg) || TEMPLATE_DIR;
const PORT = process.env.PORT || 5500;

// ─── MIME types ───────────────────────────────────────────────────────────────
const MIME = {
  '.html': 'text/html', '.css': 'text/css', '.js': 'text/javascript',
  '.json': 'application/json', '.md': 'text/plain', '.png': 'image/png',
  '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon', '.txt': 'text/plain', '.csv': 'text/csv'
};

// ─── Path resolution ──────────────────────────────────────────────────────────
// Course-owned paths come from COURSE_DIR; everything else from TEMPLATE_DIR.
const COURSE_PREFIXES = ['/_course/', '/_assessments/'];

function resolveFilePath(urlPath) {
  if (COURSE_DIR !== TEMPLATE_DIR && COURSE_PREFIXES.some(p => urlPath.startsWith(p))) {
    return { filePath: path.join(COURSE_DIR, urlPath.slice(1)), base: COURSE_DIR };
  }
  return { filePath: path.join(TEMPLATE_DIR, urlPath.slice(1)), base: TEMPLATE_DIR };
}

// ─── Server ───────────────────────────────────────────────────────────────────
const server = http.createServer((req, res) => {
  let urlPath = req.url.split('?')[0];
  if (urlPath === '/') urlPath = '/index.html';

  const { filePath, base } = resolveFilePath(urlPath);

  if (!filePath.startsWith(base)) {
    res.writeHead(403); res.end('Forbidden'); return;
  }

  fs.readFile(filePath, (err, data) => {
    if (err) { res.writeHead(404, { 'Content-Type': 'text/plain' }); res.end('Not found: ' + urlPath); return; }
    const mimeType = MIME[path.extname(filePath).toLowerCase()] || 'application/octet-stream';
    res.writeHead(200, { 'Content-Type': mimeType });
    res.end(data);
  });
});

server.listen(PORT, () => {
  const label = COURSE_DIR !== TEMPLATE_DIR ? `course: ${path.basename(COURSE_DIR)}` : 'course';
  console.log(`\n📚  Serving ${label} at: http://localhost:${PORT}`);
  console.log('    Press Ctrl+C to stop.\n');
});
