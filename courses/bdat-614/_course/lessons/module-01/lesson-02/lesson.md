# Lesson 2: Process Variation — Sources and Types

## Goal
Distinguish between common-cause variation and special-cause variation, and identify the sources of process variation using the 6M framework and the 5 Whys technique.

## Concept

Every process has variation. A machine that fills bottles never fills exactly 500 ml each time — some variation is always present. The key question in quality control is: **what kind of variation is it?**

**Common-cause variation** (also called natural or random variation):
- Always present in any process
- Due to many small, unknown factors acting together (materials slightly different, temperature fluctuating slightly, operator hand pressure varying)
- Predictable — the process is "in control"
- Can only be reduced by changing the process itself (a management decision)

**Special-cause variation** (also called assignable or non-random variation):
- Caused by a specific, identifiable event
- Examples: a new batch of raw material, a broken tool, an operator error, a software bug in a pipeline
- Unpredictable — the process has gone "out of control"
- Must be found and fixed immediately, without changing the whole process

Think of it this way: a river's water level rises and falls every year with seasons — that is common-cause variation. A dam bursting upstream is a special cause — it is identifiable, unusual, and must be addressed.

**The 6Ms — Sources of Process Variation:**

Variation always comes from one or more of these six categories:

| M | Category | Example |
|---|---|---|
| Man | People (operators, analysts) | Operator fatigue, inconsistent technique |
| Machine | Equipment | Tool wear, sensor drift |
| Material | Inputs / raw data | Batch variation, corrupted data source |
| Method | Process / algorithm | Different coding standards, wrong procedure |
| Measurement | How output is measured | Sensor error, calibration drift |
| Environment | Physical/digital surroundings | Temperature, network latency |

**5 Whys:** A simple technique to find the root cause of a special-cause variation. Ask "why?" five times in sequence. Each answer prompts the next "why?" until you reach the true root cause.

Example: *Defective parts increase suddenly (effect).*
1. Why? — The cutting tool is worn.
2. Why? — Maintenance schedule was skipped.
3. Why? — The maintenance log system went offline.
4. Why? — A server update deleted the cron job.
5. Why? — There was no version-controlled backup of the cron configuration.

Root cause: no backup/version control for scheduled maintenance jobs.

## Example

An ETL pipeline that normally runs in 45 minutes suddenly takes 3 hours.

- **Special cause:** a new data source was added with 50× more records than expected.
- **6M analysis:** *Material* (data volume) is the source.
- **5 Whys:** Why slow? → Too many records. Why? → New source added. Why no alert? → Threshold monitor wasn't updated. Why not updated? → No change-management process for data sources. Why no process? → Root cause — lack of a data source onboarding protocol.
- **Action:** fix the immediate issue (partition the load), then address the root cause (implement a data source onboarding checklist).

## Task

Open `exercise.py`. You will:
1. Classify a list of variation scenarios as `"common"` or `"special"` cause.
2. Map each scenario to the correct 6M category.
3. Simulate a simple 5 Whys chain for a given problem statement.

Run the check when done:
`npm run check -- bdat-614 module-01 lesson-02`

## Check

```
npm run check -- bdat-614 module-01 lesson-02
```

## Reflection

In a manufacturing plant, the fill weight of cereal boxes varies slightly every day but stays within a predictable range. One morning the average fill weight drops by 15 grams. A worker says "the machine is just random — ignore it." Do you agree? What type of variation is the 15-gram drop, and what should be done?
