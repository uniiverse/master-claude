# Universe Organization - AI Coding Standards

**Template Version**: 1.0.0
**Last Updated**: 2026-02-12
**Repository**: {{REPO_NAME}}

---

## Purpose

This file defines AI coding standards and behaviors for all repositories in the universe organization. These instructions ensure consistent code quality, security practices, and development workflows when working with AI assistants like Claude Code.

**Customization**: For repository-specific preferences, see `CLAUDE.local.md` in this repository.

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [Code Quality Standards](#code-quality-standards)
3. [Security Requirements](#security-requirements)
4. [Testing Expectations](#testing-expectations)
5. [Documentation Standards](#documentation-standards)
6. [Performance Guidelines](#performance-guidelines)
7. [Available Skills](#available-skills)
8. [Available Agents](#available-agents)

---

## Core Principles

### 1. Read Before Writing

**REQUIRED**: Before modifying any file, use the `Read` tool to examine:
- The file being modified
- Similar files in the codebase to understand patterns
- Related test files
- Relevant documentation

**Why**: Understanding existing patterns ensures consistency and prevents breaking existing conventions.

### 2. Consistency Over Cleverness

**REQUIRED**: Follow existing codebase patterns even if you know a "better" way.

**Example**: If the codebase uses callbacks, continue using callbacks. Don't introduce promises without discussion.

### 3. Explicit Over Implicit

**REQUIRED**: Favor clarity and explicitness:
- Explicit error handling over silent failures
- Clear variable names over abbreviations
- Obvious algorithms over clever one-liners

### 4. Security First

**REQUIRED**: Security is non-negotiable:
- No hardcoded credentials
- Validate all external input
- Use parameterized queries
- Follow OWASP guidelines

### 5. Test What You Build

**REQUIRED**: New features and bug fixes require tests:
- Unit tests for logic
- Integration tests for workflows
- Document test scenarios

---

## Code Quality Standards

### Naming Conventions

Follow language-specific conventions:

**Python**:
- `snake_case` for functions, variables, modules
- `PascalCase` for classes
- `UPPER_SNAKE_CASE` for constants

**JavaScript/TypeScript**:
- `camelCase` for functions, variables
- `PascalCase` for classes, components, types
- `UPPER_SNAKE_CASE` for constants

**Go**:
- `PascalCase` for exported identifiers
- `camelCase` for unexported identifiers

### Code Structure

**REQUIRED**:
- Maximum function length: 50 lines (guideline, not strict)
- Maximum file length: 500 lines (consider splitting)
- Maximum nesting depth: 4 levels
- One class/component per file (exceptions for tiny helpers)

**Rationale**: Smaller units are easier to test, review, and maintain.

### Error Handling

**REQUIRED - Never silently fail**:

```python
# ❌ DON'T - Silent failure
try:
    result = risky_operation()
except:
    pass

# ✅ DO - Explicit handling
try:
    result = risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    raise OperationError("Could not complete operation") from e
```

**REQUIRED - Handle specific errors**:

```javascript
// ❌ DON'T - Generic catch-all
try {
    const data = await fetchData();
} catch (err) {
    console.log("Error:", err);
    return null;
}

// ✅ DO - Specific handling
try {
    const data = await fetchData();
} catch (err) {
    if (err instanceof NetworkError) {
        logger.warn("Network issue, will retry");
        return await retryFetch();
    } else if (err instanceof ValidationError) {
        throw new InvalidDataError("Data validation failed", err);
    } else {
        throw err; // Re-throw unexpected errors
    }
}
```

### Comments and Documentation

**REQUIRED**:
- Comment the "why", not the "what"
- Document complex algorithms
- Explain non-obvious business logic
- Add TODO/FIXME with issue numbers

**NOT REQUIRED**:
- Comments for self-explanatory code
- Docstrings for trivial getters/setters
- Redundant parameter descriptions

```python
# ❌ DON'T - Obvious comment
# Increment counter by 1
counter += 1

# ✅ DO - Explains reasoning
# Reset counter after batch size to prevent memory overflow
# See: https://github.com/universe/project/issues/123
counter += 1
if counter >= BATCH_SIZE:
    flush_batch()
    counter = 0
```

---

## Security Requirements

### 1. Credential Management

**REQUIRED - Never hardcode secrets**:

```python
# ❌ DON'T
API_KEY = "sk-1234567890"
DB_PASSWORD = "admin123"

# ✅ DO
import os
API_KEY = os.environ.get("API_KEY")
if not API_KEY:
    raise ValueError("API_KEY environment variable required")
```

**REQUIRED - Use secret management**:
- Environment variables for local development
- AWS Secrets Manager / Vault for production
- Never commit `.env` files

### 2. Input Validation

**REQUIRED - Validate all external input**:

```python
# ❌ DON'T - SQL injection vulnerability
def get_user(username):
    query = f"SELECT * FROM users WHERE username = '{username}'"
    return db.execute(query)

# ✅ DO - Parameterized query
def get_user(username):
    query = "SELECT * FROM users WHERE username = ?"
    return db.execute(query, (username,))
```

**REQUIRED - Sanitize user input**:

```javascript
// ❌ DON'T - XSS vulnerability
function displayUserInput(input) {
    document.innerHTML = input;
}

// ✅ DO - Sanitize or use safe APIs
function displayUserInput(input) {
    document.textContent = input; // Auto-escapes
    // OR use a sanitization library
    document.innerHTML = DOMPurify.sanitize(input);
}
```

### 3. Dependency Security

**REQUIRED**:
- Review new dependencies before adding
- Keep dependencies updated
- Use `npm audit`, `pip-audit`, or equivalent
- Prefer well-maintained libraries with security support

### 4. Principle of Least Privilege

**REQUIRED**:
- Run with minimum necessary permissions
- Don't use admin/root unless required
- Scope API tokens to specific operations
- Use read-only database users where possible

---

## Testing Expectations

### Test Coverage

**REQUIRED**:
- All new features must have tests
- All bug fixes must have regression tests
- Public APIs must have comprehensive tests

**RECOMMENDED**:
- Aim for 80%+ code coverage
- 100% coverage for critical paths (auth, payments, etc.)

### Test Types

**Unit Tests**:
- Test individual functions/methods in isolation
- Fast execution (milliseconds)
- No external dependencies

**Integration Tests**:
- Test component interactions
- Use test databases/services
- Verify end-to-end workflows

**Contract Tests**:
- For APIs consumed by others
- Ensure backwards compatibility
- Document breaking changes

### Test Structure

Follow **Arrange-Act-Assert** pattern:

```python
def test_calculate_total_with_discount():
    # Arrange
    cart = ShoppingCart()
    cart.add_item(Item("Widget", price=100))
    discount = Discount(percent=10)

    # Act
    total = cart.calculate_total(discount)

    # Assert
    assert total == 90.0
```

---

## Documentation Standards

### Code Documentation

**REQUIRED**:
- README.md in every repository
- API documentation for public interfaces
- Setup instructions for new developers
- Architecture decision records (ADRs) for significant changes

**REQUIRED in README**:
- What the project does
- How to set it up locally
- How to run tests
- How to deploy
- Who to contact for questions

### API Documentation

**REQUIRED for public APIs**:
- OpenAPI/Swagger for REST APIs
- JSON Schema for data formats
- Examples for common use cases
- Error response documentation

### Inline Documentation

**Use docstrings/JSDoc for**:
- Public functions and methods
- Complex algorithms
- Non-obvious behavior

```python
def calculate_discount(base_price: float, customer_tier: str) -> float:
    """
    Calculate discounted price based on customer tier.

    Args:
        base_price: Original price before discount
        customer_tier: One of 'bronze', 'silver', 'gold', 'platinum'

    Returns:
        Final price after tier-based discount applied

    Raises:
        ValueError: If customer_tier is not recognized

    Example:
        >>> calculate_discount(100.0, 'gold')
        85.0
    """
    # Implementation...
```

---

## Performance Guidelines

### Common Performance Issues

**Watch for**:
- N+1 database queries
- Nested loops over large datasets
- Loading entire files into memory
- Inefficient algorithms (O(n²) when O(n log n) possible)
- Unnecessary network calls

### Database Optimization

**REQUIRED**:
- Use database indexes on frequently queried columns
- Eager load related data to avoid N+1
- Paginate large result sets
- Use connection pooling

```python
# ❌ DON'T - N+1 query problem
users = User.query.all()
for user in users:
    user.posts = Post.query.filter_by(user_id=user.id).all()

# ✅ DO - Eager loading
users = User.query.options(joinedload(User.posts)).all()
```

### Memory Management

**REQUIRED**:
- Stream large files instead of loading into memory
- Use generators for large datasets
- Clean up resources with context managers

```python
# ❌ DON'T - Loads entire file
with open('large_file.txt') as f:
    lines = f.readlines()
    return [line.strip() for line in lines]

# ✅ DO - Streams line by line
def process_file(filename):
    with open(filename) as f:
        for line in f:
            yield line.strip()
```

---

## Available Skills

Skills are reusable capabilities you can invoke. Located in `.claude/skills/`.

### Core Skills

- **`/code-review`**: Comprehensive code review following universe standards
- **`/security-scan`**: Security vulnerability assessment
- **`/test-generator`**: Generate test cases for functions/modules
- **`/architecture-review`**: Review system design and architecture
- **`/performance-profile`**: Analyze performance bottlenecks
- **`/deploy-helper`**: Deployment readiness checklist

### Usage

Invoke skills by name or description:

```bash
# By command
claude /code-review

# By description
"Review this code for security issues"
```

---

## Available Agents

Agents are specialized AI configurations for specific tasks. Located in `.claude/agents/`.

### Core Agents

- **security-auditor**: Deep security analysis, threat modeling
- **tech-lead**: Architecture guidance, design review
- **code-archaeologist**: Legacy code exploration and documentation
- **performance-expert**: Performance optimization recommendations
- **test-strategist**: Testing strategy and coverage analysis

### Usage

Agents are invoked automatically based on task context, or explicitly:

```bash
# Automatic based on context
"Analyze this code for security vulnerabilities"  # → security-auditor

# Explicit invocation
claude agent security-auditor "Review authentication flow"
```

---

## Customization

### Repository-Specific Instructions

Add customizations to `CLAUDE.local.md` in this repository:

```markdown
# My Repository Preferences

## Tech Stack
- Python 3.11+ with FastAPI
- PostgreSQL 15

## Conventions
- Use async/await for all I/O
- All API endpoints need OpenAPI docs

## Performance Critical
- Response time < 100ms for read endpoints
- Flag any O(n²) or worse algorithms
```

**Precedence**: `CLAUDE.local.md` overrides `CLAUDE.md` when conflicts occur.

---

## Template Management

### Version Tracking

This file is synced from [master-claude](https://github.com/universe/master-claude).

- **Current Version**: 1.0.0
- **Check for Updates**: `.claude/commands/sync.sh`
- **Validate Template**: `.claude/commands/validate.sh`

### Getting Updates

```bash
# Update to latest template
.claude/commands/sync.sh

# Validate template integrity
.claude/commands/validate.sh
```

---

## Questions or Issues?

- **Documentation**: See [master-claude README](https://github.com/universe/master-claude)
- **Issues**: [GitHub Issues](https://github.com/universe/master-claude/issues)
- **Chat**: #ai-tooling on Slack

---

**Maintained by**: Engineering Enablement Team
**Template Source**: [universe/master-claude](https://github.com/universe/master-claude)
