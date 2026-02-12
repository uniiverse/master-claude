# {{REPO_NAME}} - Local AI Customizations

> This file contains repository-specific AI instructions that override or extend `CLAUDE.md`.
> Instructions here take precedence over the master template.

---

## Repository Information

**Repository**: {{REPO_NAME}}
**Purpose**: {{REPO_PURPOSE}}
**Primary Languages**: {{PRIMARY_LANGUAGES}}
**Team**: {{TEAM_CONTACTS}}

---

## Technology Stack

<!-- Document your specific tech stack -->

**Languages**:
- (e.g., Python 3.11+, TypeScript 5.0+)

**Frameworks**:
- (e.g., FastAPI, React, Django)

**Databases**:
- (e.g., PostgreSQL 15, Redis 7)

**Infrastructure**:
- (e.g., AWS ECS, Docker, Kubernetes)

---

## Repository-Specific Conventions

### Code Style Preferences

<!-- Override or extend universe coding standards -->

**Example**:
```markdown
- Always use async/await for I/O operations
- Prefer Pydantic models over dataclasses
- Use functional components in React (no class components)
- Database migrations must be reversible
```

### Architecture Patterns

<!-- Document architectural decisions specific to this repo -->

**Example**:
```markdown
- Follow hexagonal architecture (ports & adapters)
- Domain logic in `src/domain/`
- Infrastructure in `src/infrastructure/`
- API layer in `src/api/`
```

### Testing Requirements

<!-- Repository-specific test requirements -->

**Example**:
```markdown
- Minimum 85% code coverage required
- All API endpoints must have integration tests
- Use pytest fixtures defined in `tests/conftest.py`
- Mock external APIs using `responses` library
```

---

## Performance Requirements

<!-- Document performance expectations -->

**Example**:
```markdown
- API response time < 100ms for read operations
- API response time < 500ms for write operations
- Flag any O(n²) or worse algorithm complexity
- Database queries must use indexes (explain analyze required)
```

---

## Security Considerations

<!-- Repository-specific security requirements -->

**Example**:
```markdown
- All API endpoints require authentication (except `/health`)
- Use JWT tokens with 15-minute expiry
- PII data must be encrypted at rest
- Log all access to customer data
```

---

## Deployment & Operations

### Deployment Process

<!-- How code gets to production -->

**Example**:
```markdown
- Merge to `develop` → auto-deploy to staging
- Merge to `main` → manual approval → production
- Deployments happen during business hours only
- Rollback procedure: `kubectl rollout undo deployment/app`
```

### Configuration

<!-- How configuration is managed -->

**Example**:
```markdown
- Use AWS Systems Manager Parameter Store for secrets
- Environment variables loaded from `.env.local` (gitignored)
- Required environment variables documented in `.env.example`
```

---

## Custom Skills

<!-- Repository-specific skills not in master-claude -->

### `/local-deploy`

Deploy to local development environment.

**Location**: `.claude/skills/custom/local-deploy/`

**Usage**: `claude /local-deploy`

---

## Team Workflows

### Sprint Cadence

<!-- Document team processes -->

**Example**:
```markdown
- Sprint planning: Mondays 10am
- Code freeze: Thursdays 3pm
- Retrospective: Fridays 4pm
- On-call rotation: Weekly, starts Monday
```

### Code Review Process

<!-- Team-specific review requirements -->

**Example**:
```markdown
- Require 2 approvals for production code
- 1 approval for documentation/tests
- Senior engineer approval for architecture changes
- Security team review for auth/permissions changes
```

---

## Common Patterns

### Database Access

<!-- Document common patterns in this codebase -->

**Example**:
```python
# Use repository pattern for database access
from src.repositories import UserRepository

async def get_user_by_email(email: str):
    repo = UserRepository()
    return await repo.find_by_email(email)
```

### API Error Handling

**Example**:
```python
# Use custom exception handlers
from src.exceptions import BusinessError, NotFoundError

@app.post("/api/users")
async def create_user(data: UserCreate):
    if await user_exists(data.email):
        raise BusinessError("User already exists")
    # ...
```

---

## Dependencies

### Adding New Dependencies

<!-- Process for adding dependencies -->

**Example**:
```markdown
- Run security scan: `pip-audit` (Python) or `npm audit` (JS)
- Check license compatibility (MIT, Apache 2.0, BSD allowed)
- Document why dependency is needed in PR
- Update requirements.txt/package.json with pinned versions
```

### Dependency Update Policy

**Example**:
```markdown
- Security updates: Apply immediately
- Minor updates: Review and apply monthly
- Major updates: Plan during sprint planning
```

---

## Debugging & Troubleshooting

### Local Development

**Example**:
```bash
# Start local environment
docker-compose up -d

# Run migrations
python manage.py migrate

# Load test data
python manage.py loaddata fixtures/test_data.json

# Access logs
docker-compose logs -f app
```

### Common Issues

<!-- Document known issues and solutions -->

**Example**:
```markdown
**Issue**: Database connection timeout
**Solution**: Check VPN connection, restart docker-compose

**Issue**: Tests failing with "Port already in use"
**Solution**: Kill process on port 8000: `lsof -ti:8000 | xargs kill -9`
```

---

## Resources

### Documentation

- Architecture docs: `docs/architecture/`
- API documentation: `docs/api/` (generated from OpenAPI)
- Runbooks: `docs/runbooks/`

### Contacts

- **Tech Lead**: @tech-lead-name
- **Product Owner**: @product-owner-name
- **On-Call**: See PagerDuty schedule

### Related Repositories

- API Gateway: `universe/api-gateway`
- Shared libraries: `universe/common-lib`
- Infrastructure: `universe/infra-terraform`

---

## Notes

<!-- Any additional context or notes -->

**Last Updated**: {{CURRENT_DATE}}
**Maintained By**: {{TEAM_NAME}}
