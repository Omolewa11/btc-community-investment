# Enhanced Community Micro-Investment Smart Contract

This document describes the functionality, structure, and usage of the Enhanced Community Micro-Investment smart contract. The contract is designed for community-driven investment projects where participants can propose projects, invest in them, and vote to determine their outcome.

## Overview
This smart contract enables community members to:

1. **Create projects** with a defined title, description, and funding goal.
2. **Invest** STX tokens in active projects.
3. **Vote** to approve or reject projects during a specified voting period.
4. **Finalize projects** after the voting period, determining their status as approved, rejected, or failed.

### Features
- Comprehensive data validation for project creation, investments, and voting.
- Transparent project tracking, including funding status and vote counts.
- Built-in constraints for ensuring fair participation (e.g., minimum/maximum investments, unique project titles).

---

## Constants

### Key Parameters
- **`contract-owner`**: Owner of the contract.
- **`min-investment`**: Minimum amount for an investment (1 STX).
- **`max-investment`**: Maximum amount for an investment (1000 STX).
- **`voting-period`**: Voting period for each project (~1 day in blocks).
- **`min-vote-threshold`**: Minimum number of votes required to consider a project's outcome.
- **Title and Description Length Constraints**:
  - `min-title-length`: Minimum title length (4 characters).
  - `max-title-length`: Maximum title length (50 characters).
  - `min-description-length`: Minimum description length (10 characters).
  - `max-description-length`: Maximum description length (500 characters).

### Error Codes
Custom error codes for various validation failures, including unauthorized access (`ERR-NOT-AUTHORIZED`), invalid amounts (`ERR-INVALID-AMOUNT`), project not found (`ERR-PROJECT-NOT-FOUND`), and more.

---

## Data Structures

### Data Variables
- **`project-counter`**: Tracks the total number of created projects.

### Data Maps
- **`projects`**: Stores details of each project, including creator, title, description, funding goal, and status.
- **`project-titles`**: Tracks existing project titles to prevent duplicates.
- **`investments`**: Records investment details for each project and investor.
- **`votes`**: Tracks individual votes on projects.
- **`vote-counts`**: Aggregates total, positive, and negative votes for each project.

---

## Functionality

### Private Helper Functions

#### `is-valid-title`
Validates a project's title based on length constraints and uniqueness.

#### `is-valid-description`
Checks if a project's description meets length constraints.

#### `is-valid-project-id`
Ensures a project ID is within valid bounds.

#### `is-valid-amount`
Validates investment amounts against minimum and maximum limits.

#### `is-project-active`
Checks if a project is currently active.

#### `set-vote-counts`
Initializes or updates vote counts for a project.

---

### Public Functions

#### `create-project`
Creates a new project with the specified title, description, and funding goal.

**Parameters:**
- `title`: Project title.
- `description`: Project description.
- `funding-goal`: Target funding amount.

**Validation:**
- Title and description length.
- Unique title.
- Valid funding goal.

#### `invest`
Allows a user to invest in a specified project.

**Parameters:**
- `project-id`: ID of the project.
- `amount`: Amount to invest.

**Validation:**
- Active project.
- Valid project ID.
- Investment within allowed limits.
- Project not expired.

#### `vote`
Enables users to vote on a project's outcome.

**Parameters:**
- `project-id`: ID of the project.
- `vote-value`: Boolean value indicating approval (true) or rejection (false).

**Validation:**
- Active project.
- Valid project ID.
- No duplicate votes by the same voter.

#### `finalize-project`
Finalizes a project after the voting period, determining its outcome based on votes.

**Parameters:**
- `project-id`: ID of the project.

**Validation:**
- Voting period must have ended.
- Minimum vote threshold must be met.

### Read-Only Functions

#### `get-project`
Fetches details of a specified project.

#### `get-investment`
Retrieves investment details for a specific project and investor.

#### `get-vote`
Returns a voter's decision on a specific project.

#### `get-vote-counts`
Provides aggregated vote counts for a project.

---

## Usage Workflow

1. **Project Creation**:
   - A user creates a project by specifying a title, description, and funding goal.
   - The system validates inputs and assigns a unique project ID.

2. **Investments**:
   - Users can invest STX tokens in active projects.
   - Investments are subject to minimum and maximum constraints.

3. **Voting**:
   - Once a project is created, users can vote to approve or reject it within the voting period.
   - Each user can vote only once per project.

4. **Finalization**:
   - After the voting period, the project creator or any user can finalize the project.
   - The project's status is updated based on votes:
     - **Approved**: More positive votes than negative votes.
     - **Rejected**: More negative votes than positive votes.
     - **Failed**: Insufficient votes to meet the minimum threshold.

---

## Deployment Notes

- Ensure sufficient STX tokens in the contract for handling transactions.
- Monitor voting periods to finalize projects promptly.
- Utilize the `contract-owner` role responsibly for administrative tasks.

---

## Security Considerations

- **Validation**: Comprehensive checks prevent invalid data inputs.
- **Duplicate Handling**: Title uniqueness and single-vote constraints ensure fairness.
- **Boundary Constraints**: Limits on investments and project durations mitigate abuse.

---
