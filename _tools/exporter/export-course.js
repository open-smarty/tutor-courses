#!/usr/bin/env node
/**
 * Course exporter — packages the course folder as a distributable zip.
 * Excludes: node_modules, .git, .progress, teacher files, solution files.
 * Usage: npm run export
 *
 * Output: ../[course-title]-course.zip
 */

const fs = require('fs');
const path = require('path');
const archiver = require('archiver');

const ROOT = path.resolve(__dirname, '../..');

function loadCourse() {
  const p = path.join(ROOT, '_course/course.json');
  if (!fs.existsSync(p)) return { title: 'course' };
  return JSON.parse(fs.readFileSync(p, 'utf8'));
}

function slugify(str) {
  return (str || 'course').toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
}

async function main() {
  const course = loadCourse();
  const slug = slugify(course.title);
  const outPath = path.join(ROOT, '..', `${slug}.zip`);

  const output = fs.createWriteStream(outPath);
  const archive = archiver('zip', { zlib: { level: 9 } });

  output.on('close', () => {
    const kb = Math.round(archive.pointer() / 1024);
    console.log(`\n✅  Course exported: ${outPath} (${kb} KB)\n`);
  });

  archive.on('error', err => { throw err; });
  archive.pipe(output);

  const excludeDirs = ['node_modules', '.git', '.progress'];
  const excludePatterns = [
    /^_teacher\//,
    /solution\.[^/]+$/,
    /\.zip$/,
    /\.gitkeep$/
  ];

  archive.glob('**/*', {
    cwd: ROOT,
    ignore: [
      'node_modules/**',
      '.git/**',
      '.progress/**',
      '_teacher/**',
      '**/solution.*',
      '*.zip'
    ],
    dot: true
  });

  await archive.finalize();
}

main().catch(err => {
  console.error('Export failed:', err.message);
  process.exit(1);
});
