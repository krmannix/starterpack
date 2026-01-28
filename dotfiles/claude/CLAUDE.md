## Operating Instructions

When working on an application repository, please ensure there is a Makefile with the following commands:
`make format`: this should run linting, formatters
`make test`: this should run all tests
`make build`: this runs any compilation step, or is a no-op if no complication is needed
`make dev`: this will run the application in a local development mode

When you modify or create code in an application repository, always do the following before committing:
1. Run `make format` to ensure code is formatted.
2. Run `make test` and include the output in your response.
3. If tests or linting fails, fix the issues and re-run until tests and/or linting pass.

Some general guidelines:
- I'm not a fan of comments, so please use sparingly
- Please ensure all files have newlines at the end
- Please trim all whitespace
- Please keep commit messages compact and to a single line

I like to have atomic, small commits that either make a behavior change or produce a refactor, as I often like to reoder commits or break them into smaller PRs when appropriate. When iterating through steps, please prefer to keep changes small and atomic.

When generating commit messages, do not include "Co-authored-by" metadata.

## Code Style Guidelines

### Comments
- **Avoid comments unless absolutely necessary** to explain complex patterns or non-obvious implementation details
- Code should be self-documenting through clear naming and structure
- Only add comments when the "why" cannot be expressed through code itself
