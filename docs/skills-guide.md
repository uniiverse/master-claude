# Skills Development Guide

A comprehensive guide to creating, testing, and deploying skills for the master-claude template system.

## What is a Skill?

A **skill** is a reusable AI capability that can be invoked by name or description. Skills provide specialized instructions that modify Claude's behavior for specific tasks like code review, security scanning, or test generation.

## Skill Structure

Each skill consists of two files:

```
.claude/skills/my-skill/
├── skill.yaml          # Metadata and configuration
└── prompt.md           # The actual prompt/instructions
```

### skill.yaml

Defines metadata, triggers, parameters, and configuration.

```yaml
name: my-skill
version: 1.0.0
description: Brief description of what this skill does
author: Your Name / Team Name

# Patterns that trigger this skill
trigger_patterns:
  - "keyword phrase"
  - "/command"
  - "natural language trigger"

# Dependencies on other files/skills
dependencies:
  - CLAUDE.md
  - other-skill-name

# Parameters the skill accepts
parameters:
  - name: param_name
    type: string
    required: false
    default: "default_value"
    description: "What this parameter does"
    options:
      - option1
      - option2
      - option3

# Context files to load
context_files:
  - CLAUDE.md
  - path/to/relevant/file.md

# Model configuration (optional)
model:
  name: opus-4-6
  temperature: 0.2

# Categorization tags
tags:
  - category1
  - category2
```

### prompt.md

Contains the actual instructions for Claude.

```markdown
# My Skill Name

[Introduction explaining what this skill does]

## Parameters

**Parameter Name**: {{param_name | default: "default_value"}}

[Explanation of how to use the parameter]

## Instructions

[Detailed step-by-step instructions for Claude]

## Output Format

[Template or example of expected output]

## Examples

[Examples demonstrating skill usage]
```

## Parameter Interpolation

Use template syntax in prompt.md to reference parameters:

```markdown
{{parameter_name}}                    # Required parameter
{{parameter_name | default: "value"}} # Optional with default
```

## Creating a New Skill

### Step 1: Plan Your Skill

Answer these questions:

1. **Purpose**: What specific task does this skill perform?
2. **Trigger**: How will users invoke it?
3. **Input**: What parameters or context does it need?
4. **Output**: What should the result look like?
5. **Dependencies**: What other skills or context files are needed?

### Step 2: Create Directory Structure

```bash
mkdir -p .claude/skills/my-skill
cd .claude/skills/my-skill
```

### Step 3: Write skill.yaml

```bash
cat > skill.yaml <<'EOF'
name: my-skill
version: 1.0.0
description: Does something specific and useful
author: Engineering Team

trigger_patterns:
  - "do the thing"
  - "/my-skill"

parameters:
  - name: mode
    type: string
    required: false
    default: "standard"
    options: ["standard", "thorough", "quick"]

tags:
  - utility
EOF
```

### Step 4: Write prompt.md

```bash
cat > prompt.md <<'EOF'
# My Skill

This skill performs a specific task following uniiverse standards.

## Mode

**Mode**: {{mode | default: "standard"}}

- **standard**: Balanced approach
- **thorough**: Deep analysis (slower)
- **quick**: Fast overview

## Process

1. First step
2. Second step
3. Third step

## Output Format

Provide results in this format:

### Summary
[Brief overview]

### Details
[Detailed findings]

### Recommendations
[Actionable next steps]

Now proceed with the task.
EOF
```

### Step 5: Test Your Skill

```bash
# Invoke by command
claude /my-skill

# Invoke by description
claude "do the thing in thorough mode"

# With parameter
claude /my-skill mode=quick
```

### Step 6: Iterate and Refine

Based on testing:

1. Refine trigger patterns
2. Adjust instructions for clarity
3. Add examples
4. Improve error handling
5. Update documentation

## Best Practices

### Naming

- **Skill names**: Use kebab-case (my-skill-name)
- **Clear and descriptive**: Name should indicate purpose
- **Avoid conflicts**: Check existing skills first

### Trigger Patterns

- Include both command style (`/skill-name`) and natural language
- Be specific enough to avoid false positives
- Consider common variations and typos

### Instructions

- **Be specific**: Vague instructions lead to inconsistent results
- **Structure clearly**: Use headings, lists, and examples
- **Include examples**: Show what good output looks like
- **Define scope**: What should and shouldn't be done

### Parameters

- Keep parameters simple and focused
- Provide sensible defaults
- Document all options clearly
- Use enums for fixed choices

### Context Management

- Only include necessary context files
- Large context = slower performance
- Reference files by relative path from repo root

## Skill Templates

### Code Analysis Skill

```yaml
name: analyze-complexity
version: 1.0.0
description: Analyze code complexity and suggest simplifications
trigger_patterns:
  - "analyze complexity"
  - "/complexity"
parameters:
  - name: threshold
    type: number
    default: 10
tags:
  - code-quality
  - analysis
```

### Documentation Skill

```yaml
name: generate-docs
version: 1.0.0
description: Generate comprehensive documentation for code
trigger_patterns:
  - "generate documentation"
  - "/docs"
parameters:
  - name: format
    type: string
    default: "markdown"
    options: ["markdown", "rst", "html"]
tags:
  - documentation
```

### Testing Skill

```yaml
name: test-generator
version: 1.0.0
description: Generate test cases for functions and modules
trigger_patterns:
  - "generate tests"
  - "/test-gen"
parameters:
  - name: coverage_target
    type: number
    default: 80
  - name: framework
    type: string
    options: ["pytest", "jest", "junit"]
tags:
  - testing
```

## Sharing Skills

### Organization-Wide Skills

Place in master-claude repository:

```
templates/.claude/skills/your-skill/
```

Submit PR with:
- Skill implementation
- Tests/examples
- Documentation

### Repository-Specific Skills

Place in repository's custom skills:

```
.claude/skills/custom/your-skill/
```

Document in CLAUDE.local.md.

## Debugging Skills

### Skill Not Triggering

1. Check trigger_patterns match your invocation
2. Verify skill.yaml syntax is valid
3. Ensure skill directory is in .claude/skills/
4. Check for symlink issues

### Parameters Not Working

1. Verify parameter name matches in prompt.md
2. Check parameter syntax: `{{name | default: "value"}}`
3. Test with explicit parameter values

### Unexpected Behavior

1. Review prompt.md instructions for clarity
2. Add more specific examples
3. Reduce ambiguity in instructions
4. Test with different models/temperatures

## Examples

See the templates directory for complete examples:

- `/code-review`: Comprehensive code review
- `/security-scan`: Security vulnerability assessment
- `/test-generator`: Test case generation
- `/architecture-review`: System design review

## Getting Help

- **Documentation**: See main README.md
- **Issues**: GitHub Issues for bugs/features
- **Discussion**: #ai-tooling Slack channel

---

**Version**: 1.0.0
**Last Updated**: 2026-02-12
