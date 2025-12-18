---
name: security
version: 2.1.0
description: Security specialists hub for application security, vulnerability assessment, and secure coding. Routes to specialists for OWASP, penetration testing, and security hardening. Use for security audits, vulnerability fixes, and secure architecture.
---

# Security

Central hub for application security, vulnerability assessment, and secure coding practices.

## Phase 0: Expertise Loading

```yaml
expertise_check:
  domain: security
  file: .claude/expertise/security.yaml

  if_exists:
    - Load vulnerability patterns
    - Load OWASP guidelines
    - Apply security baselines

  if_not_exists:
    - Flag discovery mode
    - Document patterns learned
```

## When to Use This Skill

Use security when:
- Auditing code for vulnerabilities
- Fixing security issues
- Implementing authentication/authorization
- Hardening infrastructure
- Security code review

## Security Domains

| Domain | Focus |
|--------|-------|
| AppSec | OWASP Top 10, secure coding |
| AuthN/AuthZ | OAuth, JWT, RBAC |
| Cryptography | Encryption, hashing, keys |
| Infrastructure | Hardening, firewalls, secrets |

## OWASP Top 10

```yaml
vulnerabilities:
  - A01: Broken Access Control
  - A02: Cryptographic Failures
  - A03: Injection
  - A04: Insecure Design
  - A05: Security Misconfiguration
  - A06: Vulnerable Components
  - A07: Auth Failures
  - A08: Data Integrity Failures
  - A09: Logging Failures
  - A10: SSRF
```

## Secure Coding Patterns

### Input Validation
```yaml
pattern: input_validation
rules:
  - Validate all inputs
  - Use allowlists
  - Parameterize queries
  - Encode outputs
```

### Authentication
```yaml
pattern: authentication
rules:
  - Use strong hashing (bcrypt/argon2)
  - Implement MFA
  - Secure session management
  - Rate limit attempts
```

## MCP Requirements

- **claude-flow**: For orchestration
- **Bash**: For security tools

## Recursive Improvement Integration (v2.1)

### Eval Harness Integration

```yaml
benchmark: security-benchmark-v1
  tests:
    - sec-001: Vulnerability detection
    - sec-002: Fix effectiveness
  minimum_scores:
    detection_rate: 0.90
    fix_quality: 0.95
```

### Memory Namespace

```yaml
namespaces:
  - security/audits/{id}: Security audits
  - security/vulnerabilities: Known patterns
  - improvement/audits/security: Skill audits
```

### Uncertainty Handling

```yaml
confidence_check:
  if confidence >= 0.8:
    - Proceed with fix
  if confidence 0.5-0.8:
    - Flag for review
  if confidence < 0.5:
    - Escalate to security expert
```

### Cross-Skill Coordination

Works with: **code-review-assistant**, **compliance**, **deployment-readiness**

---

## !! SKILL COMPLETION VERIFICATION (MANDATORY) !!

- [ ] **Agent Spawning**: Spawned agent via Task()
- [ ] **Agent Registry Validation**: Agent from registry
- [ ] **TodoWrite Called**: Called with 5+ todos
- [ ] **Work Delegation**: Delegated to agents

**Remember: Skill() -> Task() -> TodoWrite() - ALWAYS**

---

## Core Principles

### 1. Defense in Depth
Security is never a single layer. Multiple independent security controls create redundancy that protects even when individual layers fail.

**In practice:**
- Combine input validation, parameterized queries, AND least-privilege database access for SQL injection defense
- Use authentication, authorization, AND audit logging for access control
- Layer network firewalls, application-level access controls, AND resource-level permissions
- Assume every layer can be compromised and design accordingly

### 2. Least Privilege
Grant only the minimum permissions required for functionality. Excessive permissions create unnecessary attack surface.

**In practice:**
- Database connections use read-only accounts unless write operations are explicitly required
- API keys have scoped permissions limited to specific resources and operations
- Service accounts cannot access user data or perform administrative actions
- Default to deny, explicitly allow only what is necessary

### 3. Security by Design, Not Afterthought
Security controls integrated during design are more effective and less costly than retrofitted protections.

**In practice:**
- Threat modeling happens in planning phase, not after implementation
- Security requirements are defined alongside functional requirements
- Code reviews include security checks before merge
- Automated security testing runs in CI/CD pipeline before deployment
- Security is a success criterion, not a post-launch audit

---

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Trusting user input** (using unsanitized data in queries, commands, or eval) | Enables injection attacks (SQL, XSS, command injection). User input is adversarial by default. | Validate all inputs against allowlists, parameterize queries, encode outputs, never use eval or dynamic code execution with user data. |
| **Hardcoded secrets** (API keys, passwords in source code) | Secrets in version control are public. Anyone with repo access gains credentials. | Use environment variables, secret management systems (HashiCorp Vault, AWS Secrets Manager), never commit secrets. |
| **Weak cryptography** (MD5, SHA1, DES, custom algorithms) | Broken algorithms provide false sense of security. Data appears protected but is trivially compromised. | Use modern algorithms: bcrypt/argon2 for passwords, AES-256-GCM for encryption, SHA-256+ for hashing. |
| **Security through obscurity** (hiding endpoints, relying on non-public URLs) | Obscurity is not security. Attackers find hidden resources through enumeration, logs, referrers. | Implement proper authentication and authorization. Assume all endpoints are discoverable. |
| **Ignoring dependency vulnerabilities** (never updating packages, ignoring npm audit warnings) | Known CVEs in dependencies are low-hanging fruit for attackers. Exploits are public and automated. | Regular dependency updates, automated vulnerability scanning (npm audit, Snyk, Dependabot), patch critical CVEs immediately. |
| **Overly broad CORS policies** (`Access-Control-Allow-Origin: *`) | Allows any website to make authenticated requests to your API, enabling CSRF and data exfiltration. | Use specific origin allowlists, never use wildcard with credentials, validate Origin header. |

---


## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Trusting user input** (using unsanitized data in queries, commands, or eval) | Enables injection attacks (SQL, XSS, command injection). User input is adversarial by default. | Validate all inputs against allowlists, parameterize queries, encode outputs, never use eval or dynamic code execution with user data. |
| **Hardcoded secrets** (API keys, passwords in source code) | Secrets in version control are public. Anyone with repo access gains credentials. | Use environment variables, secret management systems (HashiCorp Vault, AWS Secrets Manager), never commit secrets. |
| **Weak cryptography** (MD5, SHA1, DES, custom algorithms) | Broken algorithms provide false sense of security. Data appears protected but is trivially compromised. | Use modern algorithms: bcrypt/argon2 for passwords, AES-256-GCM for encryption, SHA-256+ for hashing. |

---

## Conclusion

Application security is a continuous practice, not a one-time implementation. The security landscape evolves constantly as new vulnerabilities emerge, attack techniques advance, and systems grow in complexity. The principles of defense in depth, least privilege, and security by design provide a foundation that remains effective regardless of specific threats.

Security is fundamentally about reducing risk, not eliminating it. Perfect security is impossible - the goal is to make successful attacks so costly and time-consuming that attackers move to softer targets. Each security control raises the bar incrementally. A well-designed security posture combines technical controls, process discipline, and human awareness to create layered defenses that degrade gracefully under attack.

The skills and tools outlined in this document provide a starting point for building secure systems. However, security expertise is specialized and deep. When facing complex security challenges, high-value systems, or compliance requirements, consult security specialists. The cost of security incidents - in reputation, customer trust, legal liability, and recovery effort - vastly exceeds the investment in proper security architecture and implementation.
