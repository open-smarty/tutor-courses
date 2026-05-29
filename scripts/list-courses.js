#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const coursesDir = path.join(__dirname, '..', 'courses');

if (!fs.existsSync(coursesDir)) {
  console.log('\nNo courses yet.\n\nRun: npm run add-course -- <slug> ["Title"]\n');
  process.exit(0);
}

const courses = fs.readdirSync(coursesDir).filter(f =>
  fs.statSync(path.join(coursesDir, f)).isDirectory()
);

if (courses.length === 0) {
  console.log('\nNo courses yet.\n\nRun: npm run add-course -- <slug> ["Title"]\n');
  process.exit(0);
}

console.log(`\nCourses (${courses.length}):\n`);

for (const slug of courses) {
  const courseDir = path.join(coursesDir, slug);
  const descFile = path.join(courseDir, '_teacher', 'course-description.md');
  const courseJson = path.join(courseDir, '_course', 'course.json');

  let title = slug;
  let status = 'draft — teacher files not yet filled in';

  if (fs.existsSync(descFile)) {
    const content = fs.readFileSync(descFile, 'utf8');
    const m = content.match(/\*\*Course title:\*\*\s*(.+)/);
    if (m && !m[1].includes('<!--')) title = m[1].trim();
    status = 'ready to generate — open Claude Code and say "create the course"';
  }

  if (fs.existsSync(courseJson)) {
    try {
      const json = JSON.parse(fs.readFileSync(courseJson, 'utf8'));
      const modules = json.modules?.length || 0;
      const lessons = json.modules?.reduce((n, m) => n + (m.lessons?.length || 0), 0) || 0;
      status = `generated — ${modules} module${modules !== 1 ? 's' : ''}, ${lessons} lesson${lessons !== 1 ? 's' : ''}`;
    } catch {}
  }

  console.log(`  ${slug}`);
  console.log(`    Title:  ${title}`);
  console.log(`    Status: ${status}`);
  console.log('');
}
