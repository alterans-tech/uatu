# Bug Template

## Title Convention

Symptom as the user experiences it, not the technical cause.
- Good: "Login fails silently on expired token", "Estimate total doesn't update after deleting a line item"
- Bad: "Fix JWT bug", "Database error on delete"

## Description Template

```
## Current Behavior
[What happens now — include error messages, screenshots if available]

## Expected Behavior
[What should happen instead]

## Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Environment
- [Browser/OS/version if relevant]
- [Branch or deployment]

## Evidence
- [Error message, stack trace, or log excerpt]
```

## Rules

- Title = symptom, not cause
- Include reproduction steps (even if "intermittent", describe the conditions)
- Link to parent Epic if the bug falls within an initiative's scope
- Every Bug gets at least one domain Label

## Example

**Title:** Estimate total doesn't update after deleting a line item

**Description:**

```
## Current Behavior
After deleting a line item from the estimate, the total at the bottom
still shows the old amount. Refreshing the page shows the correct total.

## Expected Behavior
Total should recalculate immediately when a line item is deleted.

## Steps to Reproduce
1. Open any estimate with 3+ line items
2. Note the total amount
3. Delete the second line item
4. Observe the total — it does not change

## Environment
- Chrome 124, macOS 14.3
- Production (app.example.com)

## Evidence
- No console errors
- Network tab shows DELETE request succeeds (200)
- Total component does not re-render after deletion
```
