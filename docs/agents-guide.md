# Agents Development Guide

A guide to creating specialized AI agents for the master-claude template system.

## What is an Agent?

An **agent** is a specialized AI configuration optimized for specific types of tasks. Unlike skills (which provide instructions for specific tasks), agents define persistent behavior, tool access, and expertise areas.

## Agents vs Skills

| Feature | Skills | Agents |
|---------|--------|--------|
| Purpose | Task-specific instructions | Specialized persistent behavior |
| Invocation | Explicit (`/skill-name`) | Context-based or explicit |
| Scope | Single task | Extended conversation |
| Configuration | Prompt template | Full AI configuration |
| State | Stateless | Can maintain context |
| Complexity | Simple instructions | Complex reasoning patterns |

**Use a Skill when**: You need specific instructions for a one-time task.

**Use an Agent when**: You need specialized expertise across multiple interactions.

## Agent Structure

```
.claude/agents/my-agent/
├── agent.yaml          # Configuration and metadata
└── instructions.md     # Behavioral instructions
```

### agent.yaml

```yaml
name: my-agent
version: 1.0.0
description: What this agent specializes in
author: Team Name

# Model configuration
model:
  name: opus-4-6      # or sonnet-4-5, haiku
  temperature: 0.2     # Lower = more focused

# Available tools
tools:
  - Read
  - Grep
  - Glob
  - Bash
  - WebFetch

# Context files automatically loaded
context_files:
  - CLAUDE.md
  - RELEVANT_DOMAIN_FILE.md

# Agent behavior
behavior:
  focus: domain-specific
  thoroughness: high
  approach: methodical

# Activation triggers
activation_triggers:
  - "keyword phrase"
  - "domain-specific request"

# Knowledge domains
knowledge_domains:
  - Domain Area 1
  - Domain Area 2
  - Specific Expertise

# Output characteristics
output_style:
  tone: professional
  detail_level: high
  include_references: true

tags:
  - category
  - domain
```

### instructions.md

```markdown
# Agent Name

[Define the agent's role and expertise]

## Your Role

[Detailed description of the agent's purpose and responsibilities]

## Core Principles

1. Principle 1
2. Principle 2
3. Principle 3

## Methodology

### Phase 1: Analysis
[How to approach analysis]

### Phase 2: Assessment
[How to evaluate findings]

### Phase 3: Recommendations
[How to provide recommendations]

## Output Format

[Template for consistent output]

## Domain Knowledge

[Specific expertise areas and how to apply them]

## Communication Style

[How to communicate findings]
```

## Creating a New Agent

### Step 1: Define Agent Scope

Identify:

1. **Domain**: What area of expertise?
2. **Purpose**: What problems does it solve?
3. **Differentiator**: What makes this agent unique?
4. **Tools Needed**: Which tools are essential?
5. **Output Style**: How should it communicate?

### Step 2: Create Agent Structure

```bash
mkdir -p .claude/agents/my-agent
cd .claude/agents/my-agent
```

### Step 3: Write agent.yaml

```yaml
name: performance-optimizer
version: 1.0.0
description: Performance analysis and optimization specialist
author: Engineering Team

model:
  name: opus-4-6
  temperature: 0.1

tools:
  - Read
  - Grep
  - Bash
  - WebFetch

context_files:
  - CLAUDE.md
  - PERFORMANCE_GUIDE.md

behavior:
  focus: performance-first
  thoroughness: very-high
  approach: data-driven

activation_triggers:
  - "performance issue"
  - "optimization"
  - "bottleneck"
  - "slow performance"

knowledge_domains:
  - Algorithm Complexity
  - Database Optimization
  - Caching Strategies
  - Profiling & Benchmarking

output_style:
  tone: analytical
  detail_level: high
  include_benchmarks: true
  include_references: true

tags:
  - performance
  - optimization
```

### Step 4: Write instructions.md

Focus on:

- **Role definition**: Clear identity and purpose
- **Methodology**: Step-by-step approach
- **Domain expertise**: Specific knowledge areas
- **Decision framework**: How to make recommendations
- **Communication style**: How to present findings

### Step 5: Test Agent

```bash
# Invoke explicitly
claude agent my-agent "analyze this code"

# Test automatic activation
claude "help me optimize this slow query"
```

## Agent Archetypes

### Specialist Agent

Focuses on deep expertise in one domain.

**Example**: Security Auditor
- Deep security knowledge
- Low risk tolerance
- Comprehensive analysis
- Strict adherence to standards

### Advisor Agent

Provides strategic guidance and recommendations.

**Example**: Tech Lead
- Architecture perspective
- Balances tradeoffs
- Considers long-term implications
- Focuses on design patterns

### Analyst Agent

Examines and interprets complex information.

**Example**: Code Archaeologist
- Historical context analysis
- Pattern recognition
- Documentation focus
- Legacy system expertise

### Optimizer Agent

Improves efficiency and performance.

**Example**: Performance Expert
- Metrics-driven
- Benchmarking focus
- Algorithm analysis
- Resource optimization

## Best Practices

### Model Selection

- **Opus**: Complex reasoning, strategic decisions, comprehensive analysis
- **Sonnet**: Balanced performance, most use cases
- **Haiku**: Quick tasks, simple checks (rarely used for agents)

### Temperature Settings

- **0.0-0.2**: Highly focused, deterministic (security, compliance)
- **0.3-0.5**: Balanced creativity and consistency (most agents)
- **0.6-1.0**: Creative, exploratory (architecture, brainstorming)

### Tool Selection

Only include tools the agent needs:

- **Read**: Always needed for code analysis
- **Grep/Glob**: For codebase exploration
- **Bash**: For running tests, profiling, etc.
- **WebFetch**: For external references
- **Edit/Write**: Only if agent should modify code

### Context Files

- Keep focused on relevant domain
- Avoid loading unnecessary context
- Large context = slower responses

### Instructions Quality

- **Be specific**: Vague instructions = inconsistent behavior
- **Provide framework**: Step-by-step methodology
- **Include examples**: Show expected output format
- **Define boundaries**: What agent should/shouldn't do

## Agent Examples

### Security Auditor

```yaml
name: security-auditor
model:
  name: opus-4-6
  temperature: 0.1
behavior:
  focus: security-first
  thoroughness: very-high
  risk_tolerance: none
```

Specializes in finding vulnerabilities, threat modeling, security best practices.

### Tech Lead

```yaml
name: tech-lead
model:
  name: opus-4-6
  temperature: 0.4
behavior:
  focus: architecture-first
  thoroughness: high
  approach: pragmatic
```

Provides architectural guidance, design patterns, technical strategy.

### Performance Expert

```yaml
name: performance-expert
model:
  name: opus-4-6
  temperature: 0.2
behavior:
  focus: performance-first
  thoroughness: high
  approach: data-driven
```

Analyzes bottlenecks, optimizes algorithms, improves efficiency.

### Code Archaeologist

```yaml
name: code-archaeologist
model:
  name: sonnet-4-5
  temperature: 0.3
behavior:
  focus: understanding-first
  thoroughness: medium
  approach: exploratory
```

Explores legacy code, documents systems, finds patterns.

## Testing Agents

### Unit Testing

Test individual agent behaviors:

```bash
# Test specific analysis
echo "Test code" > test.py
claude agent security-auditor "review test.py"

# Verify output format
# Check for expected sections
# Validate recommendations
```

### Integration Testing

Test agent in realistic scenarios:

```bash
# Full codebase analysis
claude agent performance-expert "analyze API performance"

# Multi-file review
claude agent tech-lead "review new microservice architecture"
```

### Regression Testing

Maintain test cases for consistent behavior:

```
tests/agents/security-auditor/
├── test-sql-injection.py
├── test-auth-bypass.py
└── expected-output.md
```

## Debugging Agents

### Agent Not Activating

1. Check activation_triggers patterns
2. Verify agent.yaml syntax
3. Test explicit invocation first
4. Check agent directory location

### Incorrect Behavior

1. Review instructions.md clarity
2. Adjust temperature setting
3. Add more specific examples
4. Refine methodology section

### Performance Issues

1. Reduce context_files
2. Limit tool set
3. Consider using Sonnet instead of Opus
4. Break complex tasks into phases

## Contributing Agents

### To master-claude

Submit PR with:

```
templates/.claude/agents/your-agent/
├── agent.yaml
├── instructions.md
└── README.md          # Usage examples
```

Include:
- Clear use case description
- Example invocations
- Test cases
- Documentation

### Repository-Specific

Place in:

```
.claude/agents/custom/your-agent/
```

Document in CLAUDE.local.md.

## Resources

- **Examples**: See templates/.claude/agents/
- **Issues**: GitHub Issues for bugs
- **Discussion**: #ai-tooling Slack

---

**Version**: 1.0.0
**Last Updated**: 2026-02-12
