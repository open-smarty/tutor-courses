# Lesson 2: Process Variation — Sources and Types

## Goal

Distinguish common-cause from special-cause variation and identify sources using the 6M framework.

## Concept

Every process produces variation. No two server response times are identical. No two blood pressure readings are the same. No two ETL batch runtimes match exactly. The critical question is not "is there variation?" — there always is. The question is: **why** is there variation, and what should you do about it?

**Common-Cause Variation**

Common-cause variation (also called random or natural variation) is always present. It comes from the combined effect of many small, independent sources: tiny fluctuations in temperature, minor differences in input data, background network jitter, small batch-to-batch differences in materials. No single cause is identifiable or addressable without redesigning the entire process.

Formal definition: a process is **in statistical control** when only common-cause variation is present. The process is predictable — future output will behave like past output.

**Special-Cause Variation**

Special-cause variation (also called assignable variation) comes from a specific, identifiable event. A worn sensor, a new untrained operator, a software deployment, a power surge, a corrupted data file.

Formal definition: a process is **out of statistical control** when special-cause variation is present. The process is unpredictable — something changed.

**Why the distinction matters**: if you treat special-cause variation as if it were common cause, you do nothing — the problem persists. If you treat common-cause variation as if it were special cause, you over-adjust — you "chase noise" and actually increase variation. Walter Shewhart called this the two types of error in process management.

**The 6M Framework (Ishikawa Categories)**

When investigating a potential special cause, the 6M framework provides a structured checklist of where to look:

- **Machine** — equipment malfunction, hardware failure, misconfigured server
- **Method** — wrong procedure, outdated algorithm, incorrect query logic
- **Material** — bad input data, corrupted file, wrong API response
- **Man** — operator error, untrained staff, incorrect manual entry
- **Measurement** — faulty sensor, miscalibrated gauge, logging bug
- **Mother Nature** — temperature, humidity, peak traffic load, seasonal effects

**Run Chart**

A run chart is the simplest diagnostic tool: plot measurements in time order. Look for:
- **Trends**: 6+ consecutive points steadily rising or falling (process drifting)
- **Shifts**: 8+ consecutive points all above or below the historical median (process jumped to new level)
- **Cycles**: repeating up-down patterns at regular intervals

## Example

Consider server response times (ms) measured every minute from a production web API.

Normal operation: mean ≈ 245ms, variation ≈ ±15ms due to network jitter and CPU scheduling — this is common-cause variation. The process is in control.

At observation 35, response time spikes to 820ms. Investigation reveals that at observation 34, a developer deployed a query that performs a full table scan on a 50M-row table rather than using an index. This is a special cause: **Method** (wrong query algorithm) in the 6M framework.

The correct action: roll back or fix the query. Not: accept the higher response time as "normal variation" and widen the control limits.

6M analysis for this event: Machine = web server (unchanged), Method = SQL query algorithm (changed — root cause), Material = database records (unchanged), Man = developer who deployed the query, Measurement = APM monitor (correct), Mother Nature = no unusual traffic at that time.

## Task

In `exercise.py`, generate 50 server response time measurements with normal common-cause variation (mean=245ms, sd=15ms). Insert a special cause at observation 35 by adding 200ms to that observation and all subsequent ones (simulating a process shift after a bad deployment). Create a run chart: plot all 50 observations in time order. Mark the special-cause point with a red marker. Add a horizontal reference line at the baseline mean. Label the chart clearly.

## Check

```
npm run check -- bdat-614 module-01 lesson-02
```

## Reflection

Why is it dangerous to treat special-cause variation as if it were common-cause variation? Describe the practical consequence in a data pipeline context where you incorrectly conclude that a sudden jump in error rate is "just normal noise."
