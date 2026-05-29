#!/usr/bin/env node
/**
 * One-time setup script.
 * Installs Node dependencies and VS Code extensions.
 * Run via: npm run setup
 * Or ask Claude Code: "Set up this repo"
 */

const { execSync, spawnSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '../..');

function run(cmd, label) {
  process.stdout.write(`  ${label}... `);
  try {
    execSync(cmd, { cwd: ROOT, stdio: 'pipe' });
    console.log('✓');
    return true;
  } catch (err) {
    console.log('✗');
    console.log(`    Error: ${err.stderr ? err.stderr.toString().trim() : err.message}`);
    return false;
  }
}

function checkCommand(cmd) {
  try {
    execSync(`${cmd} --version`, { stdio: 'pipe' });
    return true;
  } catch {
    return false;
  }
}

function installExtensions() {
  const extFile = path.join(ROOT, '.vscode/extensions.json');
  if (!fs.existsSync(extFile)) return;

  let exts = [];
  try {
    const data = JSON.parse(fs.readFileSync(extFile, 'utf8'));
    exts = data.recommendations || [];
  } catch { return; }

  if (!checkCommand('code')) {
    console.log('  VS Code CLI not found — extensions will be suggested when you open the folder.');
    console.log('  (This is normal — VS Code will prompt you to install them.)');
    return;
  }

  console.log('  Installing VS Code extensions:');
  for (const ext of exts) {
    run(`code --install-extension ${ext} --force`, `    ${ext}`);
  }
}

async function main() {
  console.log('\n📚  Tutor Setup\n');

  // Check Node
  if (!checkCommand('node')) {
    console.error('❌  Node.js is not installed. Download it from https://nodejs.org\n');
    process.exit(1);
  }
  const nodeVer = execSync('node --version', { encoding: 'utf8' }).trim();
  console.log(`  Node.js: ${nodeVer} ✓`);

  // npm install
  console.log('\n  Installing dependencies:');
  const npmOk = run('npm install', '    npm install');

  if (!npmOk) {
    console.log('\n  Try running: npm install\n  manually in the terminal.\n');
  }

  // VS Code extensions
  console.log('\n  Setting up VS Code extensions:');
  installExtensions();

  // Summary
  console.log('\n✅  Setup complete.\n');
  console.log('  Next steps:');
  console.log('  ─────────────────────────────────────────────────────');

  const courseFile = path.join(ROOT, '_course/course.json');
  let courseReady = false;
  try {
    const c = JSON.parse(fs.readFileSync(courseFile, 'utf8'));
    courseReady = c.modules && c.modules.length > 0;
  } catch { /* */ }

  if (courseReady) {
    console.log('  1. Open index.html with Live Server to start learning');
    console.log('     Right-click index.html → Open with Live Server');
  } else {
    console.log('  FOR TEACHERS:');
    console.log('  1. Fill in _teacher/course-description.md');
    console.log('  2. Fill in _teacher/requirements.md');
    console.log('  3. Tell Claude Code: "Create the course from the description"');
    console.log('\n  FOR STUDENTS:');
    console.log('  1. Open index.html with Live Server');
    console.log('     Right-click index.html → Open with Live Server');
  }
  console.log('');
}

main();
