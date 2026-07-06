# IPL SQL Analytics Project

A comprehensive SQL project built using the **Indian Premier League (IPL)** dataset to demonstrate SQL proficiency from **Basic** to **Advanced** concepts using **Microsoft SQL Server**.

This project analyzes IPL match and ball-by-ball data to generate meaningful insights into team performance, player statistics, venue analysis, and season trends.

---

## Project Overview

The project uses two datasets:

- **matches.csv** – Match-level information
- **deliveries.csv** – Ball-by-ball information

The objective is to practice and demonstrate SQL skills through real-world business problems using IPL data.

---

## Repository Structure

```
IPL-SQL-Analytics/
│
├── datasets/
│   ├── matches.csv
│   └── deliveries.csv
│
├── sql/
│   ├── IPL SQL Project.sql
│
├── screenshots/
│   ├── query_results/
│   └── dashboards/
│
└── README.md
```

---

# Dataset Information

### Matches Table

Contains match-level information including:

- Match ID
- Season
- Date
- Teams
- Toss Winner
- Toss Decision
- Venue
- Match Winner
- Player of the Match
- Win Margin

---

### Deliveries Table

Contains ball-by-ball information including:

- Match ID
- Innings
- Over
- Ball
- Batting Team
- Bowling Team
- Batsman
- Bowler
- Runs Scored
- Extras
- Dismissals

---

# Tools Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- GitHub

---

# SQL Concepts Covered

## Basic SQL

- SELECT
- WHERE
- ORDER BY
- DISTINCT
- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()

---

## Intermediate SQL

- INNER JOIN
- LEFT JOIN
- GROUP BY
- HAVING
- CASE WHEN
- Aggregate Functions
- Mathematical Calculations

---

## Advanced SQL

- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()
- Subqueries
- PARTITION BY
- FORMAT()
- Ranking Analysis

---

# Project Statistics

- ✔ 2 Datasets
- ✔ 30 SQL Queries
- ✔ 10 Basic Queries
- ✔ 10 Intermediate Queries
- ✔ 10 Advanced Queries

---

# Business Questions Solved

### Basic Analysis

- Total IPL Matches
- Total Runs Scored
- Total Sixes
- Total Venues
- Unique Teams
- Top Run Scorers
- Top Wicket Takers
- Highest Individual Score

---

### Intermediate Analysis

- Toss Impact
- Venue-wise Average Score
- Team Batting Statistics
- Bowling Economy
- Result Type Analysis
- Victory Type Analysis
- Runs Per Over
- Team Win Analysis

---

### Advanced Analysis

- Orange Cap Every Season
- Purple Cap Every Season
- Player Rankings
- Running Season Totals
- Season Comparison using LAG()
- Top Scorer in Every Match
- Highest Scoring Partnerships
- Venue Performance Analysis

---

# Sample Insights

- Identified the Orange Cap winner for every IPL season.
- Ranked batsmen based on career runs.
- Analyzed bowling economy across the tournament.
- Compared season-wise scoring trends.
- Calculated cumulative runs across IPL seasons.
- Determined the highest-scoring partnerships in every match.
- Evaluated venue scoring patterns.

---

# Project Preview

You can add screenshots of:

- SQL Query Results
- Execution Plans
- SSMS Output
- Power BI Dashboard (Optional)

Example:

```
screenshots/
    orange_cap.png
    purple_cap.png
    top_batsmen.png
```

---

# Future Improvements

- Add Stored Procedures
- Add Views
- Add User Defined Functions
- Add Triggers
- Add Indexes
- Add Dynamic SQL
- Create Interactive Power BI Dashboard
- Build SQL Reporting Views
- Optimize Queries using Execution Plans

---

# Learning Outcomes

This project demonstrates proficiency in:

- Data Exploration
- Data Aggregation
- SQL Query Writing
- Data Analysis
- Window Functions
- Business Intelligence
- Performance Optimization
- SQL Server Development
