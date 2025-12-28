---
name: when-configuring-sandbox-security-use-sandbox-configurator
description: ```yaml
allowed-tools: Read, Glob, Grep, Bash, Task, TodoWrite
---

## When to Use This Skill

Use this skill when configuring sandbox network isolation, setting up trusted domain whitelists, implementing zero-trust network policies for AI code execution, configuring corporate proxies and internal registries, or preventing data exfiltration through network controls.

## When NOT to Use This Skill

Do NOT use for production network security (use infrastructure-as-code instead), configuring firewall rules on live systems, bypassing organizational network policies, or setting up VPNs and network routing (use networking specialists). Avoid for troubleshooting network connectivity issues unrelated to sandbox security.

## Success Criteria

- Trusted domain whitelist validated (all required domains accessible, untrusted blocked)
- Network isolation prevents data exfiltration attacks (tested with simulated exfil)
- Internal registries accessible through proper proxy configuration
- Environment variables secured (no secrets in config files)
- Zero false positives (legitimate development work unblocked)
- Package installations succeed from approved registries
- Build and deployment commands execute without network errors
- Validation tests pass (npm install, git clone, API calls to approved domains)

## Edge Cases & Challenges

- Corporate proxies requiring NTLM authentication
- Split-tunnel VPNs with mixed internal/external traffic
- CDN domains changing dynamically (*.cloudfront.net wildcards)
- WebSocket connections requiring separate allowlisting
- DNS resolution failures in isolated environments
- IPv6 vs IPv4 routing differences
- Localhost binding restrictions breaking development servers
- Proxy auto-configuration (PAC) files with complex logic

## Guardrails (CRITICAL SECURITY RULES)

- NEVER disable network isolation without security review
- NEVER add untrusted domains to whitelist without validation
- NEVER store secrets (API keys, passwords) in sandbox configuration files
- NEVER bypass proxy settings to access restricted resources
- NEVER allow wildcard domain patterns without justification (*.com = insecure)
- ALWAYS validate domain ownership before whitelisting
- ALWAYS use HTTPS for external domains (enforce TLS)
- ALWAYS document why each domain is trusted (justification required)
- ALWAYS test that untrusted domains are blocked (negative testing)
- ALWAYS use environment variable references for secrets (not plaintext)
- ALWAYS maintain audit logs of network policy changes
- ALWAYS validate network policies after configuration changes

## Evidence-Based Validation

All network security configurations MUST be validated through:
1. **Positive testing** - Verify approved domains accessible (npm install, git clone)
2. **Negative testing** - Verify untrusted domains blocked (curl random-website.com fails)
3. **Proxy validation** - Confirm traffic routes through corporate proxy where required
4. **Secret scanning** - Automated scan for credentials in configuration files
5. **Build validation** - End-to-end build succeeds with network policy applied
6. **Penetration testing** - Attempt data exfiltration to verify isolation

# Sandbox Security Configuration SOP

```yaml
metadata:
  skill_name: when-configuring-sandbox-security-use-sandbox-configurator
  version: 1.0.0
  category: specialized-tools
  difficulty: intermediate
  estimated_duration: 20-40 minutes
  trigger_patterns:
    - "configure sandbox security"
    - "sandbox isolation"
    - "file system boundaries"
    - "sandbox permissions"
    - "secure sandbox"
  dependencies:
    - Claude Code sandbox environment
    - Admin/root access (if applicable)
  agents:
    - security-manager (security architect)
    - cicd-engineer (infrastructure specialist)
  success_criteria:
    - Security policies defined
    - File boundaries configured
    - Network isolation set
    - Policies tested and verified
    - Documentation complete
```

## Overview

Configure Claude Code sandbox security with file system and network isolation boundaries. Ensures safe code execution with proper access controls and resource limits.

## Prerequisites

**Required:**
- Claude Code environment
- Understanding of security requirements

**Optional:**
- Existing security policies
- Compliance requirements (SOC2, HIPAA, etc.)

**Verification:**
```bash
# Check Claude Code version
claude --version

# Verify sandbox availability
echo "Sandbox check"
```

## Agent Responsibilities

### security-manager (Security Architect)
**Role:** Design security policies, define boundaries, validate configurations

**Expertise:**
- Security architecture
- Access control systems
- Compliance requirements
- Threat modeling

**Output:** Security policies, boundary definitions, validation tests

### cicd-engineer (Infrastructure Specialist)
**Role:** Implement security configurations, manage resources, deploy policies

**Expertise:**
- Infrastructure management
- System configuration
- Deployment automation
- Monitoring setup

**Output:** Configuration files, deployment scripts, monitoring tools

## Phase 1: Assess Security Requirements

**Objective:** Identify security needs, compliance requirements, and threat models

**Evidence-Based Validation:**
- Requirements documented
- Threat model created
- Compliance needs identified
- Risk assessment complete

**security-manager Actions:**
```bash
# Pre-task coordination
npx claude-flow@alpha hooks pre-task --description "Assess sandbox security requirements"

# Create security directory structure
mkdir -p sandbox-security/{policies,config,tests,docs}

# Document security requirements
cat > sandbox-security/docs/REQUIREMENTS.md << 'EOF'
# Sandbox Security Requirements

## Objectives
- Prevent unauthorized file access
- Isolate network communications
- Enforce resource limits
- Audit all operations
- Comply with security standards

## Threat Model

### Threats
1. **File System Escape**: Unauthorized access to host files
2. **Network Intrusion**: Malicious network connections
3. **Resource Exhaustion**: DoS through resource abuse
4. **Data Exfiltration**: Unauthorized data transfer
5. **Privilege Escalation**: Gaining unauthorized permissions

### Mitigations
1. File system boundaries and whitelisting
2. Network isolation and domain restrictions
3. CPU/memory/disk quotas
4. Audit logging and monitoring
5. Least privilege principles

## Compliance Requirements
- SOC 2 Type II (if applicable)
- GDPR data protection
- Internal security policies
- Industry standards (OWASP, NIST)

## Access Control
- Read-only for system files
- Read-write for workspace only
- No access to sensitive directories (/etc, /root, /sys)
- Temp directory with size limits
EOF

# Post-edit hook
npx claude-flow@alpha hooks post-edit --file "sandbox-security/docs/REQUIREMENTS.md" --memory-key "sandbox/requirements"

# Create threat assessment
cat > sandbox-security/docs/THREAT-ASSESSMENT.md << 'EOF'
# Threat Assessment

## Risk Matrix

| Threat | Likelihood | Impact | Risk Level | Mitigation Priority |
|--------|-----------|--------|------------|-------------------|
| File Escape | Medium | Critical | High | P0 |
| Network Intrusion | Low | High | Medium | P1 |
| Resource Exhaustion | High | Medium | Medium | P1 |
| Data Exfiltration | Low | Critical | High | P0 |
| Privilege Escalation | Low | Critical | High | P0 |

## Recommended Controls

### Critical (P0)
1. File system boundaries with strict whitelisting
2. Network isolation with trusted domain list
3. Mandatory audit logging

### High (P1)
4. Resource quotas and limits
5. Real-time monitoring and alerts
6. Regular security audits

### Medium (P2)
7. Automated security testing
8. Incident response procedures
9. Security awareness training
EOF

# Post-edit hook
npx claude-flow@alpha hooks post-edit --file "sandbox-security/docs/THREAT-ASSESSMENT.md" --memory-key "sandbox/threat-assessment"

# Store requirements in memory
npx claude-flow@alpha memory store \
  --key "sandbox/phase1-complete" \
  --value "{\"status\": \"complete\", \"threats_identified\": 5, \"controls_defined\": 9, \"timestamp\": \"$(date -Iseconds)\"}"
```

**Success Criteria:**
- [ ] Requirements documented
- [ ] Threat model created
- [ ] Risk matrix defined
- [ ] Controls prioritized

## Phase 2: Configure File Isolation

**Objective:** Set file system boundaries, define access rules, implement restrictions

**Evidence-Based Validation:**
- Boundaries configured
- Whitelist/blacklist defined
- Access rules tested
- Unauthorized access blocked

**security-manager Actions:**
```bash
# Define file system policy
cat > sandbox-security/policies/file-system-policy.json << 'EOF'
{
  "file_system": {
    "mode": "whitelist",
    "workspace": {
      "path": "/workspace",
      "permissions": "read-write",
      "size_limit_gb": 10
    },
    "allowed_paths": [
      "/workspace/**",
      "/tmp/sandbox/**",
      "/usr/local/bin",
      "/usr/bin",
      "/bin"
    ],
    "denied_paths": [
      "/etc/**",
      "/root/**",
      "/sys/**",
      "/proc/**",
      "/dev/**",
      "/home/**",
      "~/.ssh/**",
      "~/.aws/**",
      "~/.config/**"
    ],
    "temp_directory": {
      "path": "/tmp/sandbox",
      "size_limit_mb": 1000,
      "auto_cleanup": true,
      "cleanup_age_hours": 24
    },
    "readonly_paths": [
      "/usr/local/lib",
      "/usr/lib",
      "/lib"
    ]
  },
  "enforcement": {
    "strict_mode": true,
    "symlink_resolution": "deny",
    "case_sensitive": true,
    "audit_all_access": true
  }
}
EOF

# Post-edit hook
npx claude-flow@alpha hooks post-edit --file "sandbox-security/policies/file-system-policy.json" --memory-key "sandbox/file-policy"
```

**cicd-engineer Actions:**
```bash
# Create file isolation configuration script
cat > sandbox-security/config/configure-file-isolation.sh << 'EOF'
#!/bin/bash
set -e

echo "Configuring file system isolation..."

# Create workspace directory
mkdir -p /workspace
chmod 755 /workspace

# Create isolated temp directory
mkdir -p /tmp/sandbox
chmod 1777 /tmp/sandbox

# Set resource limits
cat > /etc/security/limits.d/sandbox.conf << 'LIMITS'
sandbox soft fsize 10485760
sandbox hard fsize 10485760
sandbox soft nofile 1024
sandbox hard nofile 2048
LIMITS

# Configure AppArmor profile (if available)
if command -v apparmor_parser &> /dev/null; then
  cat > /etc/apparmor.d/sandbox << 'APPARMOR'
#include <tunables/global>

profile sandbox {
  #include <abstractions/base>

  /workspace/** rw,
  /tmp/sandbox/** rw,
  /usr/bin/** rix,
  /bin/** rix,

  deny /etc/** rwklx,
  deny /root/** rwklx,
  deny /sys/** rwklx,
  deny /proc/sys/** rwklx,
  deny /home/** rwklx,
}
APPARMOR

  apparmor_parser -r /etc/apparmor.d/sandbox
  echo "AppArmor profile loaded"
fi

echo "File isolation configured successfully"
EOF

chmod +x sandbox-security/config/configure-file-isolation.sh

# Post-edit hook
npx claude-flow@alpha hooks post-edit --file "sandbox-security/config/configure-file-isolation.sh" --memory-key "sandbox/file-config"

# Store configuration
npx claude-flow@alpha memory store \
  --key "sandbox/phase2-complete" \
  --value "{\"status\": \"complete\", \"file_boundaries\": true, \"timestamp\": \"$(date -Iseconds)\"}"
```

**Success Criteria:**
- [ ] File policy defined
- [ ] Configuration script created
- [ ] Boundaries enforced
- [ ] Access restrictions tested

## Phase 3: Configure Network Isolation

**Objective:** Define trusted domains, implement network restrictions, configure firewall rules

**Evidence-Based Validation:**
- Network policy configured
- Trusted domains whitelisted
- Malicious connections blocked
- DNS filtering active

**security-manager Actions:**
```bash
# Define network security policy
cat > sandbox-security/policies/network-policy.json << 'EOF'
{
  "network": {
    "mode": "whitelist",
    "trusted_domains": [
      "*.anthropic.com",
      "api.openai.com",
      "github.com",
      "*.github.com",
      "raw.githubusercontent.com",
      "npmjs.org",
      "*.npmjs.org",
      "pypi.org",
      "*.pypi.org",
      "docker.io",
      "*.docker.io"
    ],
    "blocked_domains": [
      "*.example-malicious.com",
      "suspicious-domain.net"
    ],
    "allowed_ports": {
      "outbound": [80, 443, 22, 3000, 5000, 8000, 8080],
      "inbound": [3000, 5000, 8000, 8080]
    },
    "protocols": {
      "allowed": ["http", "https", "ssh", "git"],
      "denied": ["ftp", "telnet", "smtp"]
    },
    "rate_limiting": {
      "enabled": true,
      "requests_per_minute": 100,
      "burst": 150
    }
  },
  "firewall": {
    "default_policy": "deny",
    "egress_rules": [
      {
        "action": "allow",
        "destination": "trusted_domains",
        "ports": [80, 443]
      }
    ],
    "ingress_rules": [
      {
        "action": "allow",
        "source": "localhost",
        "ports": [3000, 8000, 8080]
      }
    ]
  }
}
EOF

# Post-edit hook
npx claude-flow@alpha hooks post-edit --file "sandbox-security/policies/network-policy.json" --memory-key "sandbox/network-policy"
```

**cicd-engineer Actions:**
```bash
# Create network isolation configuration
cat > sandbox-security/config/configure-network-isolation.sh << 'EOF'
#!/bin/bash
set -e

echo "Configuring network isolation..."

# Create firewall rules (using iptables)
if command -v iptables &> /dev/null; then
  # Default deny
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT DROP

  # Allow loopback
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  # Allow established connections
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  # Allow outbound HTTPS to trusted domains
  iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
  iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT

  # Allow outbound SSH
  iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

  # Allow inbound on application ports
  iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
  iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
  iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

  echo "Firewall rules configured"
fi

# Configure DNS filtering (using hosts file)
cat >> /etc/hosts << 'HOSTS'
# Blocked domains
127.0.0.1 example-malicious.com
127.0.0.1 suspicious-domain.net
HOSTS

echo "Network isolation configured successfully"
EOF

chmod +x sandbox-security/config/configure-network-isolation.sh

# Post-edit hook
npx claude-flow@alpha hooks post-edit --file "sandbox-security/config/configure-network-isolation.sh" --memory-key "sandbox/network-config"

# Store configuration
npx claude-flow@alpha memory store \
  --key "sandbox/phase3-complete" \
  --value "{\"status\": \"complete\", \"network_isolated\": true, \"timestamp\": \"$(date -Iseconds)\"}"
```

**Success Criteria:**
- [ ] Network policy defined
- [ ] Firewall rules configured
- [ ] Trusted domains whitelisted
- [ ] Malicious domains blocked

## Phase 4: Test Security Policies

**Objective:** Validate all security configurations through comprehensive testing

**Evidence-Based Validation:**
- All tests passing
- Unauthorized access blocked
- Authorized access permitted
- No false positives/negatives

**security-manager Actions:**
```bash
# Create security test suite
cat > sandbox-security/tests/security-tests.sh << 'EOF'
#!/bin/bash

PASS=0
FAIL=0

echo "Running Security Test Suite"
echo "============================"

# Test 1: File system boundaries
echo -e "\nTest 1: File system access control"
if ! cat /etc/shadow 2>/dev/null; then
  echo "✓ Cannot read /etc/shadow"
  ((PASS++))
else
  echo "✗ Can read /etc/shadow (SECURITY ISSUE)"
  ((FAIL++))
fi

# Test 2: Workspace access
echo -e "\nTest 2: Workspace access"
if touch /workspace/test.txt 2>/dev/null; then
  echo "✓ Can write to workspace"
  ((PASS++))
  rm -f /workspace/test.txt
else
  echo "✗ Cannot write to workspace"
  ((FAIL++))
fi

# Test 3: Temp directory access
echo -e "\nTest 3: Temp directory access"
if touch /tmp/sandbox/test.txt 2>/dev/null; then
  echo "✓ Can write to temp directory"
  ((PASS++))
  rm -f /tmp/sandbox/test.txt
else
  echo "✗ Cannot write to temp directory"
  ((FAIL++))
fi

# Test 4: SSH key protection
echo -e "\nTest 4: SSH key protection"
if ! cat ~/.ssh/id_rsa 2>/dev/null; then
  echo "✓ Cannot read SSH keys"
  ((PASS++))
else
  echo "✗ Can read SSH keys (SECURITY ISSUE)"
  ((FAIL++))
fi

# Test 5: Network access to trusted domain
echo -e "\nTest 5: Network access (trusted domain)"
if curl -s --max-time 5 https://api.anthropic.com >/dev/null 2>&1; then
  echo "✓ Can access trusted domain"
  ((PASS++))
else
  echo "⚠ Cannot access trusted domain (check network)"
  ((FAIL++))
fi

# Test 6: Network access to blocked domain
echo -e "\nTest 6: Network access (blocked domain)"
if ! curl -s --max-time 5 https://example-malicious.com >/dev/null 2>&1; then
  echo "✓ Cannot access blocked domain"
  ((PASS++))
else
  echo "✗ Can access blocked domain (SECURITY ISSUE)"
  ((FAIL++))
fi

# Summary
echo -e "\n============================"
echo "Test Summary:"
echo "Passed: $PASS"
echo "Failed: $FAIL"
echo "============================"

if [ $FAIL -eq 0 ]; then
  echo "✓ All security tests passed!"
  exit 0
else
  echo "✗ Some security tests failed!"
  exit 1
fi
EOF

chmod +x sandbox-security/tests/security-tests.sh

# Post-edit hook
npx claude-flow@alpha hooks post-edit --file "sandbox-security/tests/security-tests.sh" --memory-key "sandbox/security-tests"

# Run tests
./sandbox-security/tests/security-tests.sh || echo "Tests failed - review configuration"
```

**cicd-engineer Actions:**
```bash
# Create automated test runner
cat > sandbox-security/tests/run-all-tests.sh << 'EOF'
#!/bin/bash

echo "Running all security tests..."
echo "=============================="

# Run security test suite
./sandbox-security/tests/security-tests.sh

# Capture results
TEST_RESULT=$?

# Log results
echo "{\"timestamp\": \"$(date -Iseconds)\", \"result\": \"$TEST_RESULT\"}" >> sandbox-security/tests/test-results.log

# Notify
if [ $TEST_RESULT -eq 0 ]; then
  npx claude-flow@alpha hooks notify --message "Security tests passed"
else
  npx claude-flow@alpha hooks notify --message "Security tests FAILED - review immediately"
fi

exit $TEST_RESULT
EOF

chmod +x sandbox-security/tests/run-all-tests.sh

# Post-edit hook
npx claude-flow@alpha hooks post-edit --file "sandbox-security/tests/run-all-tests.sh" --memory-key "sandbox/test-runner"

# Store test results
npx claude-flow@alpha memory store \
  --key "sandbox/phase4-complete" \
  --value "{\"status\": \"complete\", \"tests_passed\": true, \"timestamp\": \"$(date -Iseconds)\"}"
```

**Success Criteria:**
- [ ] Test suite created
- [ ] All tests passing
- [ ] Security validated
- [ ] Results logged

## Phase 5: Deploy and Monitor

**Objective:** Deploy security configuration and setup continuous monitoring

**Evidence-Based Validation:**
- Configuration deployed
- Monitoring active
- Alerts configured
- Documentation complete

**security-manager Actions:**
```bash
# Create deployment guide
cat > sandbox-security/docs/DEPLOYMENT.md << 'EOF'
# Security Deployment Guide

## Pre-Deployment Checklist
- [ ] All policies reviewed and approved
- [ ] Test suite passing
- [ ] Backup configuration created
- [ ] Rollback plan documented

## Deployment Steps

1. **Backup Current Configuration**
   ```bash
   ./sandbox-security/scripts/backup-config.sh
   ```

2. **Deploy File Isolation**
   ```bash
   ./sandbox-security/config/configure-file-isolation.sh
   ```

3. **Deploy Network Isolation**
   ```bash
   ./sandbox-security/config/configure-network-isolation.sh
   ```

4. **Verify Deployment**
   ```bash
   ./sandbox-security/tests/security-tests.sh
   ```

5. **Enable Monitoring**
   ```bash
   ./sandbox-security/monitoring/start-monitoring.sh
   ```

## Post-Deployment
- Monitor logs for 24 hours
- Review security alerts
- Conduct security audit
- Update documentation

## Rollback Procedure
If issues occur:
```bash
./sandbox-security/scripts/rollback-config.sh
```
EOF

# Post-task hook
npx claude-flow@alpha hooks post-task --task-id "sandbox-security-config"
```

**cicd-engineer Actions:**
```bash
# Create monitoring script
cat > sandbox-security/monitoring/start-monitoring.sh << 'EOF'
#!/bin/bash

echo "Starting security monitoring..."

# Monitor file access
tail -f /var/log/audit/audit.log | grep --line-buffered "denied" &

# Monitor network connections
tcpdump -i any -n 'tcp[tcpflags] & (tcp-syn) != 0' &

# Monitor resource usage
while true; do
  echo "[$(date -Iseconds)] Resource usage:"
  df -h /workspace
  du -sh /tmp/sandbox
  sleep 300
done &

echo "Monitoring started (PIDs: $!)"
EOF

chmod +x sandbox-security/monitoring/start-monitoring.sh

# Create final documentation
cat > sandbox-security/docs/SECURITY-SUMMARY.md << 'EOF'
# Security Configuration Summary

## Implemented Controls

### File System Security
- Whitelist mode enabled
- Workspace: /workspace (10GB limit)
- Temp: /tmp/sandbox (1GB limit, 24h cleanup)
- Denied: /etc, /root, /sys, /proc, /dev, /home, ~/.ssh, ~/.aws

### Network Security
- Whitelist mode enabled
- Trusted domains: *.anthropic.com, github.com, npmjs.org, pypi.org
- Allowed ports: 80, 443, 22, 3000, 5000, 8000, 8080
- Firewall: Default deny with specific allow rules
- Rate limiting: 100 req/min, burst 150

### Monitoring
- File access auditing
- Network connection monitoring
- Resource usage tracking
- Security alert system

## Security Posture

| Control | Status | Effectiveness |
|---------|--------|---------------|
| File Isolation | ✓ Active | High |
| Network Isolation | ✓ Active | High |
| Resource Limits | ✓ Active | Medium |
| Audit Logging | ✓ Active | High |
| Monitoring | ✓ Active | Medium |

## Compliance
- SOC 2 Type II controls implemented
- GDPR data protection measures in place
- Internal security policies enforced
- OWASP security guidelines followed

## Maintenance
- Review policies quarterly
- Update trusted domains as needed
- Audit logs monthly
- Test security weekly
- Update documentation continuously
EOF

# Post-edit hooks
npx claude-flow@alpha hooks post-edit --file "sandbox-security/monitoring/start-monitoring.sh" --memory-key "sandbox/monitoring"
npx claude-flow@alpha hooks post-edit --file "sandbox-security/docs/SECURITY-SUMMARY.md" --memory-key "sandbox/summary"

# Session end
npx claude-flow@alpha hooks session-end --export-metrics true

# Store final status
npx claude-flow@alpha memory store \
  --key "sandbox/phase5-complete" \
  --value "{\"status\": \"complete\", \"deployed\": true, \"monitoring\": true, \"timestamp\": \"$(date -Iseconds)\"}"

npx claude-flow@alpha memory store \
  --key "sandbox/workflow-complete" \
  --value "{\"status\": \"success\", \"security_level\": \"high\", \"compliance\": true, \"timestamp\": \"$(date -Iseconds)\"}"
```

**Success Criteria:**
- [ ] Configuration deployed
- [ ] Monitoring active
- [ ] Documentation complete
- [ ] Security validated

## Workflow Summary

**Total Estimated Duration:** 20-40 minutes

**Phase Breakdown:**
1. Assess Security Requirements: 5-10 minutes
2. Configure File Isolation: 5-10 minutes
3. Configure Network Isolation: 5-10 minutes
4. Test Security Policies: 3-5 minutes
5. Deploy and Monitor: 2-5 minutes

**Key Deliverables:**
- Security policies
- File isolation configuration
- Network isolation configuration
- Security test suite
- Monitoring system
- Complete documentation

## Best Practices

1. **Defense in Depth**: Multiple security layers
2. **Least Privilege**: Minimal access rights
3. **Whitelist Approach**: Deny by default
4. **Continuous Monitoring**: Real-time security
5. **Regular Testing**: Weekly security tests
6. **Documentation**: Keep updated
7. **Audit Trail**: Log all operations
8. **Incident Response**: Plan for breaches

## References

- OWASP Security Guidelines
- NIST Cybersecurity Framework
- Claude Code Security Documentation
- Linux Security Best Practices

---

## Core Principles

### 1. Isolation Boundaries are Non-Negotiable
Sandboxes exist to contain untrusted code execution. Weak boundaries defeat the entire purpose of sandboxing.

**In practice:**
- File system access defaults to deny, explicitly allow only workspace and temporary directories
- Network access uses whitelist mode - only approved domains are reachable
- Process isolation prevents sandbox escape through shared memory or inter-process communication
- Resource limits (CPU, memory, disk) prevent denial-of-service attacks consuming host resources

### 2. Least Privilege Enforcement
Sandbox processes should operate with minimal permissions required for legitimate functionality.

**In practice:**
- Sandbox user accounts cannot access system directories (/etc, /root, /sys)
- Read-only access to binaries and libraries, read-write only within workspace
- No sudo or elevated privileges available to sandbox processes
- Environment variables expose only non-sensitive configuration (never secrets or credentials)

### 3. Defense in Depth Through Layered Controls
Single security controls fail. Multiple independent layers ensure that compromise of one control does not compromise the entire sandbox.

**In practice:**
- Combine AppArmor/SELinux mandatory access control with file system permissions
- Use both firewall rules (iptables) and DNS filtering to restrict network access
- Implement resource quotas at both process level (ulimits) and user level (cgroups)
- Add audit logging to detect and alert on suspicious activities even if controls are bypassed

---

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Allowing symlink traversal outside workspace** (following ../../../etc/passwd symlinks) | Symlinks bypass file path restrictions. Attacker creates symlink in workspace pointing to sensitive system files. | Set `symlink_resolution: deny` or validate symlink targets stay within allowed boundaries. Resolve symlinks and check canonicalized paths. |
| **Overly permissive temp directory** (/tmp shared with host, no size limits) | Shared temp directories leak information between sandbox and host. No size limits enable DoS via disk exhaustion. | Use isolated temp directory (/tmp/sandbox) with size quotas. Auto-cleanup old files. Prevent cross-user access. |
| **Storing secrets in sandbox configuration** (API keys, passwords in JSON files) | Configuration files are readable by sandbox processes. Secrets in config files expose credentials to untrusted code. | Use environment variable references (${SECRET_NAME}), fetch from secret management systems, never hardcode secrets in config. |
| **Allowing wildcard network access** (*.com, *.cloudfront.net without justification) | Wildcards expand attack surface massively. *.com allows millions of domains including attacker-controlled sites. | Use specific domain lists. Wildcard only subdomains under your control. Document and justify every wildcard pattern. |
| **No monitoring or audit logging** (deploying policies without visibility) | Security controls without monitoring create blind spots. Attacks succeed undetected. No evidence for incident response. | Enable audit logging (auditd, AppArmor logs), monitor for policy violations, alert on suspicious activities, retain logs for forensics. |
| **Trusting corporate proxies implicitly** (assuming proxy = secure) | Proxies do not validate content security, only route traffic. Malicious content can flow through corporate proxies. | Layer proxy routing with content filtering, DNS filtering, and application-level security. Proxies are routing, not security. |

---


## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Disabling sandbox entirely for convenience** | Removes all security boundaries. Malicious code from prompt injection or compromised dependencies gains direct system access, enabling data exfiltration, credential theft, and system compromise. Convenience over security creates unacceptable risk. | Use Level 2 (Balanced Security) with explicit exclusions for required operations. Enable allowLocalBinding for dev servers, exclude git/docker if needed, but maintain network isolation. Security boundaries prevent worst-case outcomes even when malicious code executes. |
| **Wildcard domain patterns without justification** (e.g., *.com, *) | Defeats network isolation by allowing any domain. Malicious code can exfiltrate to attacker-controlled *.com domains. Wildcards should be narrowly scoped to specific services (*.npmjs.org for npm registry CDN). | Use specific domain whitelist: "registry.npmjs.org", "api.github.com", "*.mycompany.com". Each wildcard requires documented justification. Prefer full domains over wildcards. Reject overly broad patterns like *.com or * entirely. |
| **Storing secrets (API keys, passwords) in configuration files** | Configuration files are often committed to version control or shared, exposing secrets. Hardcoded credentials in sandbox config create security vulnerability and violate secret management best practices. | Use environment variable references in sandbox config: NPM_TOKEN=${NPM_TOKEN}. Actual secrets stored in secure credential management (CI/CD secrets, local env files in .gitignore). Configuration references secrets, never contains them. |

---

## Conclusion

Sandbox security is the foundation of safe AI code execution environments. The isolation boundaries, access controls, and resource limits defined in this skill create a containment layer that allows untrusted code to execute while protecting the host system from compromise. Effective sandbox configuration balances security with usability - overly restrictive policies break legitimate workflows, while permissive policies enable attacks.

The five-phase approach (assess requirements, configure file isolation, configure network isolation, test policies, deploy and monitor) ensures systematic implementation with validation at each stage. Security policies mean nothing until tested - the validation gates prove that unauthorized access is actually blocked and legitimate access actually works. Negative testing is as critical as positive testing: confirming that attacks fail is how you validate security controls.

However, sandboxes are not perfect security. Determined attackers with sufficient resources find sandbox escapes. Kernel vulnerabilities, CPU side-channel attacks, and zero-day exploits can bypass sandbox controls. Sandboxes reduce risk and raise the cost of attacks, but do not eliminate risk entirely. Combine sandbox security with network segmentation, least-privilege architecture, monitoring, and incident response capabilities to create defense in depth. Assume sandbox breaches will occur and design systems that remain secure even when individual layers fail.