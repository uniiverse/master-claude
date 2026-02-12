# Code Review Skill

You are conducting a comprehensive code review following uniiverse organization standards.

## Review Scope

**Scope**: {{scope | default: "full"}}
**Severity Filter**: {{severity | default: "medium"}}

## Review Checklist

### 1. Code Quality
- [ ] Follows existing code patterns and conventions
- [ ] Clear, descriptive variable and function names
- [ ] Functions are focused and single-purpose
- [ ] Code is DRY (Don't Repeat Yourself)
- [ ] Appropriate use of language idioms

### 2. Security
- [ ] No hardcoded credentials or secrets
- [ ] Input validation on all external data
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Proper authentication and authorization
- [ ] Sensitive data properly encrypted
- [ ] Follows principle of least privilege

### 3. Error Handling
- [ ] No silent failures (empty except/catch blocks)
- [ ] Specific error types caught (not generic Exception)
- [ ] Meaningful error messages
- [ ] Errors logged appropriately
- [ ] Proper cleanup in error cases

### 4. Performance
- [ ] No N+1 database queries
- [ ] Efficient algorithms (no unnecessary O(n²))
- [ ] Proper use of caching where applicable
- [ ] Database queries use indexes
- [ ] Large datasets processed in streams/batches
- [ ] No memory leaks or excessive memory use

### 5. Testing
- [ ] New features have tests
- [ ] Bug fixes have regression tests
- [ ] Tests are meaningful (not just for coverage)
- [ ] Edge cases covered
- [ ] Tests are maintainable

### 6. Documentation
- [ ] Complex logic is commented
- [ ] Public APIs are documented
- [ ] Breaking changes noted
- [ ] README updated if needed

### 7. Database Changes
- [ ] Migrations are reversible
- [ ] Indexes created for new queries
- [ ] No breaking schema changes without migration plan
- [ ] Data migrations tested on staging data

### 8. API Changes
- [ ] Backwards compatible or version bumped
- [ ] OpenAPI/Swagger docs updated
- [ ] Error responses documented
- [ ] Rate limiting considered

## Review Process

1. **Read the code**: Use the Read tool to examine all changed files
2. **Understand context**: Look at related files, tests, and documentation
3. **Check against standards**: Reference CLAUDE.md and CLAUDE.local.md
4. **Categorize findings**: Group issues by severity and category
5. **Provide specific feedback**: Include file:line references
6. **Suggest improvements**: Provide code examples where helpful
7. **Highlight positives**: Note good practices and improvements

## Output Format

Structure your review as follows:

### Summary
Brief overview of changes and overall assessment.

### Critical Issues 🔴
Security vulnerabilities, data loss risks, breaking changes.

### High Priority Issues 🟠
Performance problems, major bugs, significant technical debt.

### Medium Priority Issues 🟡
Code quality improvements, minor bugs, maintainability concerns.

### Low Priority Issues 🔵
Style inconsistencies, minor optimizations, suggestions.

### Positive Observations ✅
Well-implemented features, good practices, improvements over previous code.

### Recommendations
Actionable next steps prioritized by importance.

## Example Feedback Format

```markdown
**Issue**: SQL Injection Vulnerability
**Location**: src/api/users.py:45
**Severity**: 🔴 Critical
**Category**: Security

The user_id parameter is directly interpolated into SQL:
```python
query = f"SELECT * FROM users WHERE id = {user_id}"
```

**Fix**:
```python
query = "SELECT * FROM users WHERE id = ?"
cursor.execute(query, (user_id,))
```

**Reference**: See CLAUDE.md Security Requirements section 2
```

## Scope-Specific Focus

### security
Focus exclusively on security vulnerabilities, authentication, authorization, data protection, and input validation.

### performance
Focus exclusively on algorithmic complexity, database efficiency, caching, memory usage, and scalability.

### style
Focus exclusively on code style, naming conventions, formatting, and adherence to language idioms.

### logic
Focus exclusively on correctness, edge cases, business logic implementation, and algorithmic soundness.

### full
Cover all aspects comprehensively.

## Remember

- Be specific with file:line references
- Provide code examples for fixes
- Cite relevant sections of CLAUDE.md
- Balance criticism with recognition of good work
- Prioritize issues by impact and severity
- Consider the context and constraints of the project

Now proceed with the code review based on the scope and severity settings provided.
