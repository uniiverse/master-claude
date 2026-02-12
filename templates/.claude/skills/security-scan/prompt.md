# Security Scan Skill

Perform a comprehensive security vulnerability assessment following OWASP Top 10 and universe security standards.

## Scan Focus

**Focus Area**: {{focus | default: "all"}}

## OWASP Top 10 Checklist

### 1. Broken Access Control
- [ ] Authentication required on sensitive endpoints
- [ ] Authorization checks before resource access
- [ ] No privilege escalation vulnerabilities
- [ ] Direct object references validated
- [ ] CORS properly configured

### 2. Cryptographic Failures
- [ ] Sensitive data encrypted at rest and in transit
- [ ] Strong encryption algorithms (AES-256, RSA-2048+)
- [ ] Proper key management
- [ ] No hardcoded keys or secrets
- [ ] TLS 1.2+ for all external communication

### 3. Injection
- [ ] SQL injection prevention (parameterized queries)
- [ ] NoSQL injection prevention
- [ ] Command injection prevention
- [ ] LDAP injection prevention
- [ ] XPath injection prevention

### 4. Insecure Design
- [ ] Security requirements defined
- [ ] Threat modeling performed
- [ ] Secure design patterns used
- [ ] Security controls at multiple layers

### 5. Security Misconfiguration
- [ ] No default credentials
- [ ] Error messages don't leak info
- [ ] Security headers configured (CSP, HSTS, etc.)
- [ ] Unnecessary features disabled
- [ ] Up-to-date dependencies

### 6. Vulnerable Components
- [ ] Dependencies regularly updated
- [ ] No known CVEs in dependencies
- [ ] Components from trusted sources
- [ ] Minimal dependency footprint

### 7. Authentication Failures
- [ ] Strong password requirements
- [ ] Multi-factor authentication available
- [ ] Session management secure
- [ ] Credential stuffing prevention
- [ ] Brute force protection

### 8. Data Integrity Failures
- [ ] Digital signatures for critical data
- [ ] CI/CD pipeline security
- [ ] No unsigned/unverified data processed
- [ ] Auto-update mechanisms secured

### 9. Security Logging Failures
- [ ] Authentication events logged
- [ ] Authorization failures logged
- [ ] Input validation failures logged
- [ ] Logs protected from tampering
- [ ] Sensitive data not logged

### 10. Server-Side Request Forgery (SSRF)
- [ ] URL validation on user input
- [ ] Internal resource access restricted
- [ ] Network segmentation enforced
- [ ] Response validation

## Scan Process

1. **Code Analysis**: Examine code for common vulnerability patterns
2. **Dependency Check**: Review dependencies for known CVEs
3. **Configuration Review**: Check security settings and configurations
4. **Authentication/Authorization**: Verify access control implementation
5. **Data Protection**: Assess encryption and data handling
6. **Input Validation**: Check all external input handling
7. **Error Handling**: Review error messages and logging

## Output Format

### Executive Summary
High-level security posture and critical findings.

### Critical Vulnerabilities 🔴
Immediate action required - exploitable security flaws.

### High Risk Issues 🟠
Should be addressed soon - potential security weaknesses.

### Medium Risk Issues 🟡
Should be addressed - security improvements needed.

### Low Risk Issues 🔵
Nice to have - defense-in-depth enhancements.

### Positive Security Controls ✅
Well-implemented security measures.

### Recommendations
Prioritized action items with remediation guidance.

## Example Finding Format

```markdown
**Vulnerability**: SQL Injection in User Search
**Location**: src/api/search.py:78
**Severity**: 🔴 Critical (CVSS: 9.8)
**OWASP**: A03:2021 - Injection
**CWE**: CWE-89

**Description**:
User-supplied search term directly interpolated into SQL query, allowing arbitrary SQL execution.

**Proof of Concept**:
```python
search_term = "'; DROP TABLE users; --"
query = f"SELECT * FROM users WHERE name LIKE '%{search_term}%'"
```

**Impact**:
- Complete database compromise
- Data exfiltration
- Data manipulation/deletion
- Potential remote code execution

**Remediation**:
```python
query = "SELECT * FROM users WHERE name LIKE ?"
cursor.execute(query, (f"%{search_term}%",))
```

**References**:
- OWASP SQL Injection: https://owasp.org/www-community/attacks/SQL_Injection
- CLAUDE.md Security Requirements section 2
```

## Focus-Specific Scans

### auth
Examine authentication and authorization mechanisms, session management, password handling, MFA implementation.

### injection
Focus on SQL injection, NoSQL injection, command injection, XSS, and other injection vulnerabilities.

### crypto
Review encryption implementations, key management, hashing algorithms, TLS configuration.

### dependencies
Analyze third-party dependencies for known vulnerabilities (CVEs), licensing issues, supply chain risks.

### configuration
Check security configurations, environment settings, default credentials, security headers, CORS.

### all
Comprehensive scan covering all aspects.

## Tools to Use

- **Read**: Examine source code files
- **Grep**: Search for vulnerability patterns
- **Bash**: Run security scanning tools (npm audit, pip-audit, etc.)
- **WebFetch**: Check OWASP references and CVE databases

## Common Vulnerability Patterns to Search

- Hardcoded credentials: `password`, `api_key`, `secret`, `token`
- SQL injection: String concatenation in SQL queries
- Command injection: `os.system()`, `exec()`, `eval()`
- XSS: Unescaped user input in HTML output
- Weak crypto: MD5, SHA1, DES
- Insecure randomness: `random.random()` for security-critical operations

Now proceed with the security scan based on the focus area specified.
