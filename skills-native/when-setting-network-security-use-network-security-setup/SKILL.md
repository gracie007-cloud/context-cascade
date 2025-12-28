---
name: when-setting-network-security-use-network-security-setup
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

# Network Security Setup SOP

```yaml
metadata:
  skill_name: when-setting-network-security-use-network-security-setup
  version: 1.0.0
  category: specialized-tools
  difficulty: intermediate
  estimated_duration: 25-45 minutes
  trigger_patterns:
    - "network security"
    - "configure network isolation"
    - "trusted domains"
    - "firewall rules"
    - "network access control"
  dependencies:
    - Claude Code sandbox
    - Network configuration access
  agents:
    - security-manager
    - cicd-engineer
  success_criteria:
    - Trusted domains configured
    - Access policies implemented
    - Environment variables set
    - Network tests passing
    - Documentation complete
```

## Overview

Configure Claude Code sandbox network isolation with trusted domains, custom access policies, and environment variables for secure network communication.

## Agent Responsibilities

### security-manager
- Design network security architecture
- Define trusted domains and policies
- Validate security configurations
- Create security documentation

### cicd-engineer
- Implement network configurations
- Deploy firewall rules
- Setup environment variables
- Create monitoring tools

## Phase 1: Audit Network Requirements

Identify required network access, external dependencies, and security constraints.

```bash
mkdir -p network-security/{policies,config,tests,docs}

# Document network requirements
cat > network-security/docs/NETWORK-REQUIREMENTS.md << 'EOF'
# Network Access Requirements

## External Dependencies
- Anthropic API (api.anthropic.com)
- GitHub (github.com, *.github.com)
- NPM Registry (npmjs.org)
- PyPI (pypi.org)
- Docker Hub (docker.io)

## Required Ports
- Outbound: 80 (HTTP), 443 (HTTPS), 22 (SSH)
- Inbound: 3000, 5000, 8000, 8080 (Application)

## Protocols
- Allowed: HTTP/HTTPS, SSH, Git
- Blocked: FTP, Telnet, SMTP

## Rate Limits
- 100 requests/minute
- Burst: 150 requests
EOF
```

## Phase 2: Design Security Policies

Create comprehensive network security policies with allow/deny rules.

```bash
cat > network-security/policies/network-policy.json << 'EOF'
{
  "network_security": {
    "mode": "whitelist",
    "trusted_domains": [
      "*.anthropic.com",
      "api.openai.com", 
      "github.com",
      "*.github.com",
      "raw.githubusercontent.com",
      "npmjs.org",
      "registry.npmjs.org",
      "pypi.org",
      "files.pythonhosted.org",
      "docker.io",
      "registry-1.docker.io"
    ],
    "blocked_domains": [
      "*.malicious.com",
      "suspicious.net"
    ],
    "allowed_ports": {
      "outbound": [80, 443, 22],
      "inbound": [3000, 5000, 8000, 8080]
    },
    "rate_limiting": {
      "enabled": true,
      "requests_per_minute": 100,
      "burst": 150
    },
    "dns_filtering": {
      "enabled": true,
      "block_private_ips": true,
      "block_localhost_bypass": true
    }
  }
}
EOF
```

## Phase 3: Implement Network Isolation

Deploy firewall rules, DNS filtering, and access controls.

```bash
cat > network-security/config/configure-network.sh << 'EOF'
#!/bin/bash
set -e

echo "Configuring network security..."

# Configure firewall (iptables)
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT

# DNS filtering
cat >> /etc/hosts << 'HOSTS'
127.0.0.1 malicious.com
127.0.0.1 suspicious.net
HOSTS

# Environment variables
cat > /etc/environment.d/network-security.conf << 'ENV'
HTTPS_PROXY=""
NO_PROXY="localhost,127.0.0.1"
TRUSTED_DOMAINS="anthropic.com,github.com,npmjs.org,pypi.org,docker.io"
ENV

echo "Network security configured"
EOF

chmod +x network-security/config/configure-network.sh
```

## Phase 4: Test Access Controls

Validate network policies through comprehensive testing.

```bash
cat > network-security/tests/network-tests.sh << 'EOF'
#!/bin/bash

echo "Testing Network Security..."

# Test trusted domain access
curl -s --max-time 5 https://api.anthropic.com && echo "✓ Trusted domain accessible"

# Test blocked domain
! curl -s --max-time 5 https://malicious.com && echo "✓ Blocked domain inaccessible"

# Test allowed ports
nc -zv localhost 3000 && echo "✓ Port 3000 accessible"

echo "Network tests complete"
EOF

chmod +x network-security/tests/network-tests.sh
```

## Phase 5: Document Configuration

Create comprehensive documentation for network security setup.

```bash
cat > network-security/docs/DEPLOYMENT.md << 'EOF'
# Network Security Deployment

## Quick Start
1. Review requirements
2. Deploy configuration: `./network-security/config/configure-network.sh`
3. Test policies: `./network-security/tests/network-tests.sh`
4. Monitor: Check logs for violations

## Trusted Domains
- Anthropic API
- GitHub
- NPM/PyPI
- Docker Hub

## Monitoring
- Connection logs: `/var/log/connections.log`
- Firewall logs: `/var/log/firewall.log`
- DNS queries: `/var/log/dns.log`

## Maintenance
- Review monthly
- Update trusted domains as needed
- Audit logs weekly
EOF
```

## Workflow Summary

**Duration:** 25-45 minutes

**Deliverables:**
- Network security policies
- Firewall configuration
- DNS filtering
- Test suite
- Documentation

## Best Practices

1. **Whitelist Approach**: Deny by default
2. **Least Privilege**: Minimal access
3. **Regular Testing**: Weekly validation
4. **Continuous Monitoring**: Real-time logs
5. **Documentation**: Keep updated


---

## Core Principles

### 1. Default Deny, Explicit Allow
Network security begins with blocking all traffic by default, then explicitly allowing only necessary communications.

**In practice:**
- Firewall rules start with DROP policies for INPUT, OUTPUT, and FORWARD chains
- Trusted domains are enumerated in whitelists, not inferred from patterns
- Every allowed domain requires documented justification for why it is trusted
- Periodic review removes domains no longer required (domain allowlists grow stale)

### 2. Network Segmentation Limits Blast Radius
Isolating network traffic by function prevents lateral movement when perimeters are breached.

**In practice:**
- Sandbox networks cannot access internal corporate networks (separate VLANs or namespaces)
- Development sandboxes isolated from production environments
- Outbound connections restricted to specific external services (APIs, package registries)
- Inbound connections limited to localhost and explicitly approved sources

### 3. Trust but Verify Through Continuous Validation
Network policies degrade as environments change. Continuous testing ensures controls remain effective.

**In practice:**
- Automated tests verify approved domains remain accessible (npm install, git clone succeed)
- Negative tests confirm blocked domains are actually blocked (curl to untrusted sites fails)
- Proxy validation tests confirm traffic routes correctly through corporate infrastructure
- Penetration testing attempts data exfiltration to verify isolation holds under adversarial conditions

---

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Wildcard domain patterns without justification** (*.com, *.cloudfront.net) | Massively expands attack surface. *.com allows millions of domains. CDN wildcards trust all customers of that CDN. | Use specific domain lists. Wildcard only subdomains you control (*.mycompany.com). Document justification for every wildcard. |
| **Storing proxy credentials in config files** (http_proxy=http://user:password@proxy) | Credentials in plaintext expose proxy authentication to anyone reading config files or environment variables. | Use credential helpers, Kerberos/NTLM authentication, or secret management systems. Never plaintext passwords. |
| **Skipping negative testing** (only testing that npm install works) | Confirms allowlist but not blocklist. Attackers exploit what you did not test - blocked domains might be accessible. | Always test that untrusted domains are blocked. Attempt connections to random domains, verify they fail. |
| **Allowing localhost bypass** (localhost can access all domains) | Attackers tunnel traffic through localhost to bypass network restrictions. Localhost becomes universal proxy. | Enforce network policies on localhost traffic. No special exemptions for local connections. |
| **DNS resolution without validation** (trusting DNS responses implicitly) | DNS poisoning redirects trusted domains to attacker-controlled IPs. Sandbox connects to malicious servers thinking they are legitimate. | Use DNSSEC where available, validate certificate chains (HTTPS only), implement DNS filtering, monitor DNS responses for anomalies. |
| **One-time configuration without monitoring** (deploy policies and forget) | Network policies drift as requirements change. Approved domains become compromised. Configuration errors go undetected. | Continuous monitoring of network connections, periodic policy reviews, alerts on policy violations, audit trails of all changes. |

---


## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Wildcard domain patterns without justification** (*.com, *.cloudfront.net) | Massively expands attack surface. *.com allows millions of domains. CDN wildcards trust all customers of that CDN. | Use specific domain lists. Wildcard only subdomains you control (*.mycompany.com). Document justification for every wildcard. |
| **Storing proxy credentials in config files** (http_proxy=http://user:password@proxy) | Credentials in plaintext expose proxy authentication to anyone reading config files or environment variables. | Use credential helpers, Kerberos/NTLM authentication, or secret management systems. Never plaintext passwords. |
| **Skipping negative testing** (only testing that npm install works) | Confirms allowlist but not blocklist. Attackers exploit what you did not test - blocked domains might be accessible. | Always test that untrusted domains are blocked. Attempt connections to random domains, verify they fail. |

---

## Conclusion

Network security for sandbox environments requires balancing isolation with functionality. The challenge is creating boundaries restrictive enough to prevent data exfiltration and malicious communications while permissive enough to allow legitimate development workflows. The whitelist approach outlined in this skill provides a systematic method for defining trusted domains, implementing access controls, and validating policies through comprehensive testing.

The five-phase workflow (audit requirements, design policies, implement isolation, test controls, document configuration) ensures that network security is designed intentionally rather than configured reactively. Understanding what network access is actually required before defining policies prevents both over-restriction (breaking legitimate workflows) and under-restriction (leaving attack vectors open). Validation through positive and negative testing proves that policies work as intended.

Network security is never complete. Attack techniques evolve, trusted domains become compromised, and system requirements change. The monitoring and maintenance practices outlined in this skill create continuous validation that network policies remain effective over time. Security is not a deployment milestone but an operational discipline requiring ongoing attention, periodic reviews, and rapid response to emerging threats. Treat network security as a living system that adapts to changing conditions while maintaining core isolation principles.