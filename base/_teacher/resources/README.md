# Teacher Resources

Drop existing materials here before asking Claude Code to generate the course.
Claude Code reads this folder automatically and uses what it finds to shape the lessons.

---

## Folders

### `slides/`
Lecture slides in any format: PDF, images (PNG/JPG), or Markdown.
Claude Code will extract topics, examples, and explanations from them.
Slides set the **content and depth** of each lesson.

### `past-questions/`
Past exam papers, quiz banks, or sample assessments.
Format: PDF, text, or Markdown.
Claude Code uses these to:
- Align quiz questions with what students are actually tested on
- Ensure lessons prepare students for those question types
- Set the right difficulty and phrasing

### `exercises/`
Existing worksheets, lab sheets, or practice problems.
Claude Code adapts these into the lesson exercise format (exercise file + solution file).

### `readings/`
Textbook excerpts, reference PDFs, articles, or reading lists.
Claude Code uses these to ensure lesson content matches required readings and uses consistent terminology.

### `datasets/`
CSV, JSON, Excel, or other data files for data-focused courses.
Claude Code uses these in examples and exercises so students work with real data.

### `syllabus/`
Existing course syllabus, module breakdown, or topic list.
If present, Claude Code uses this to set the module and lesson structure
rather than inferring structure from the course description alone.

---

## Tips

- **Any format is fine.** Claude Code can read PDFs, images, Markdown, plain text, CSV, and JSON.
- **Drop in what you have.** You do not need to fill every folder — Claude Code works with whatever is present.
- **More is better.** Past questions and an existing syllabus are the most valuable inputs.
- **Datasets go here AND in `_assets/data/`.** Put raw data files in `datasets/` for Claude Code to read during generation. Claude Code will also copy them to `_assets/data/` for the student-facing course.
- **Nothing here is shown to students.** This entire `_teacher/` folder is excluded from the student zip export.
