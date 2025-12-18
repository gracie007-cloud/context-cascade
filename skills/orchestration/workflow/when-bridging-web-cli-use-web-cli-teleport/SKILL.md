---
name: when-bridging-web-cli-use-web-cli-teleport
description: Bridge web interfaces with CLI workflows for seamless bidirectional integration
version: 1.0.0
tags:
- web
- cli
- integration
- bridge
- teleport
category: workflow
agents:
- backend-dev
- system-architect
complexity: advanced
estimated_duration: 45-90 minutes
prerequisites:
- Claude Flow installed
- Web development experience
- CLI knowledge
outputs:
- Web-CLI bridge
- API endpoints
- CLI integration
- Bidirectional communication
author: ruv
---

## Orchestration Skill Guidelines

### When to Use This Skill
- **Multi-agent coordination** requiring centralized orchestration
- **Complex workflows** with multiple dependent tasks
- **Parallel execution** benefiting from concurrent agent spawning
- **Quality-controlled delivery** needing validation and consensus
- **Production workflows** requiring audit trails and state management

### When NOT to Use This Skill
- **Single-agent tasks** with no coordination requirements
- **Simple sequential work** completing in <30 minutes
- **Trivial operations** with no quality gates
- **Exploratory work** not needing formal orchestration

### Success Criteria
- **All agents complete successfully** with 100% task completion
- **Coordination overhead minimal** (<20% of total execution time)
- **No orphaned agents** - All spawned agents tracked and terminated
- **State fully recoverable** - Can resume from any failure point
- **Quality gates pass** - All validation checks successful

### Edge Cases to Handle
- **Agent failures** - Detect and replace failed agents automatically
- **Timeout scenarios** - Configure per-agent timeout with escalation
- **Resource exhaustion** - Limit concurrent agents, queue excess work
- **Conflicting results** - Implement conflict resolution strategy
- **Partial completion** - Support incremental progress with rollback

### Guardrails (NEVER Violate)
- **NEVER lose orchestration state** - Persist to memory after each phase
- **ALWAYS track all agents** - Maintain real-time agent registry
- **ALWAYS cleanup resources** - Terminate agents and free memory on completion
- **NEVER skip validation** - Run quality checks before marking complete
- **ALWAYS handle errors** - Every orchestration step needs error handling

### Evidence-Based Validation
- **Verify all agent outputs** - Check actual results vs expected contracts
- **Validate execution order** - Confirm dependencies respected
- **Measure performance** - Track execution time vs baseline
- **Check resource usage** - Monitor memory, CPU, network during execution
- **Audit state consistency** - Verify orchestration state matches reality


# Web-CLI Teleport SOP

## Overview

Bridge web interfaces with CLI workflows for seamless integration, enabling web applications to trigger CLI commands and CLI tools to display web interfaces.

## Agents & Responsibilities

### backend-dev
**Role:** Implement bridge API and integration logic
**Responsibilities:**
- Build REST API for CLI integration
- Implement WebSocket for real-time communication
- Handle authentication and security
- Manage state synchronization

### system-architect
**Role:** Design bridge architecture and patterns
**Responsibilities:**
- Design integration architecture
- Define communication protocols
- Plan security model
- Ensure scalability

## Phase 1: Design Bridge Architecture

### Objective
Design architecture for bidirectional web-CLI communication.

### Scripts

```bash
# Generate architecture diagram
npx claude-flow@alpha architect design \
  --type "web-cli-bridge" \
  --output bridge-architecture.json

# Define API specification
cat > api-spec.yaml <<EOF
openapi: 3.0.0
info:
  title: Web-CLI Bridge API
  version: 1.0.0
paths:
  /cli/execute:
    post:
      summary: Execute CLI command from web
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                command: { type: string }
                args: { type: array }
      responses:
        '200':
          description: Command output
  /web/render:
    post:
      summary: Render web UI from CLI
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                component: { type: string }
                data: { type: object }
EOF

# Store architecture
npx claude-flow@alpha memory store \
  --key "bridge/architecture" \
  --file bridge-architecture.json
```

### Architecture Patterns

**Web → CLI:**
```
Web UI → REST API → CLI Executor → Command → Output → API → Web UI
```

**CLI → Web:**
```
CLI Tool → WebSocket → Web Server → Browser → UI Render
```

**Bidirectional:**
```
Web UI ←→ WebSocket ←→ Bridge Server ←→ CLI Tools
```

## Phase 2: Implement Web Interface

### Objective
Build web interface that can trigger and monitor CLI commands.

### Scripts

```bash
# Create web application
npx create-react-app web-cli-bridge
cd web-cli-bridge

# Install dependencies
npm install axios socket.io-client

# Generate web components
npx claude-flow@alpha generate component \
  --name "CLIExecutor" \
  --type "react" \
  --output src/components/CLIExecutor.jsx

# Build web interface
npm run build

# Deploy web app
npx claude-flow@alpha deploy web \
  --source ./build \
  --target ./deploy/web
```

### Web Component Example

```javascript
// src/components/CLIExecutor.jsx
import React, { useState, useEffect } from 'react';
import axios from 'axios';
import io from 'socket.io-client';

function CLIExecutor() {
  const [command, setCommand] = useState('');
  const [output, setOutput] = useState('');
  const [socket, setSocket] = useState(null);

  useEffect(() => {
    const newSocket = io('http://localhost:3001');
    setSocket(newSocket);

    newSocket.on('cli-output', (data) => {
      setOutput(prev => prev + data + '\n');
    });

    return () => newSocket.close();
  }, []);

  const executeCommand = async () => {
    try {
      const response = await axios.post('/api/cli/execute', {
        command,
        args: command.split(' ').slice(1)
      });
      setOutput(response.data.output);
    } catch (error) {
      setOutput(`Error: ${error.message}`);
    }
  };

  return (
    <div className="cli-executor">
      <input
        type="text"
        value={command}
        onChange={(e) => setCommand(e.target.value)}
        placeholder="Enter CLI command..."
      />
      <button onClick={executeCommand}>Execute</button>
      <pre className="output">{output}</pre>
    </div>
  );
}

export default CLIExecutor;
```

## Phase 3: Implement CLI Bridge

### Objective
Build CLI-side bridge that connects to web interface.

### Scripts

```bash
# Create bridge server
mkdir cli-bridge
cd cli-bridge
npm init -y
npm install express socket.io cors child_process

# Generate bridge server
npx claude-flow@alpha generate server \
  --type "bridge" \
  --output server.js

# Start bridge server
node server.js &

# Test connection
curl -X POST http://localhost:3001/api/cli/execute \
  -H "Content-Type: application/json" \
  -d '{"command": "ls", "args": ["-la"]}'
```

### Bridge Server Implementation

```javascript
// server.js
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const { exec } = require('child_process');
const cors = require('cors');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, { cors: { origin: '*' } });

app.use(cors());
app.use(express.json());

// Execute CLI command from web
app.post('/api/cli/execute', (req, res) => {
  const { command, args = [] } = req.body;
  const fullCommand = `${command} ${args.join(' ')}`;

  exec(fullCommand, (error, stdout, stderr) => {
    if (error) {
      return res.status(500).json({
        error: error.message,
        stderr
      });
    }

    res.json({
      output: stdout,
      stderr
    });

    // Broadcast to all connected clients
    io.emit('cli-output', stdout);
  });
});

// Render web UI from CLI
app.post('/api/web/render', (req, res) => {
  const { component, data } = req.body;

  io.emit('render-component', {
    component,
    data
  });

  res.json({ success: true });
});

// WebSocket connection
io.on('connection', (socket) => {
  console.log('Client connected');

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

server.listen(3001, () => {
  console.log('Bridge server running on port 3001');
});
```

### CLI Tool Integration

```bash
#!/bin/bash
# cli-tool-with-web.sh

# Function to render web UI from CLI
render_web_ui() {
  local component=$1
  local data=$2

  curl -X POST http://localhost:3001/api/web/render \
    -H "Content-Type: application/json" \
    -d "{\"component\": \"$component\", \"data\": $data}"
}

# Example: Show analysis results in web UI
analyze_code() {
  local path=$1
  local results=$(npx claude-flow@alpha analyze "$path" --format json)

  # Send results to web interface
  render_web_ui "AnalysisResults" "$results"

  echo "Results sent to web interface"
}

analyze_code ./src
```

## Phase 4: Test Integration

### Objective
Validate bidirectional communication and error handling.

### Scripts

```bash
# Test web → CLI
curl -X POST http://localhost:3001/api/cli/execute \
  -H "Content-Type: application/json" \
  -d '{"command": "npx", "args": ["claude-flow@alpha", "swarm", "status"]}'

# Test CLI → web
bash cli-tool-with-web.sh

# Test WebSocket connection
node test-websocket.js

# Run integration tests
npm test -- --testPathPattern=integration

# Load testing
npx artillery quick --count 10 -n 20 http://localhost:3001/api/cli/execute
```

### Integration Tests

```javascript
// tests/integration.test.js
const request = require('supertest');
const io = require('socket.io-client');
const app = require('../server');

describe('Web-CLI Bridge Integration', () => {
  let socket;

  beforeAll((done) => {
    socket = io('http://localhost:3001');
    socket.on('connect', done);
  });

  afterAll(() => {
    socket.close();
  });

  it('should execute CLI command from web', async () => {
    const response = await request(app)
      .post('/api/cli/execute')
      .send({ command: 'echo', args: ['test'] });

    expect(response.status).toBe(200);
    expect(response.body.output).toContain('test');
  });

  it('should broadcast CLI output via WebSocket', (done) => {
    socket.on('cli-output', (data) => {
      expect(data).toBeDefined();
      done();
    });

    request(app)
      .post('/api/cli/execute')
      .send({ command: 'echo', args: ['websocket test'] });
  });

  it('should render web UI from CLI', async () => {
    const response = await request(app)
      .post('/api/web/render')
      .send({
        component: 'TestComponent',
        data: { test: true }
      });

    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
  });
});
```

## Phase 5: Deploy and Monitor

### Objective
Deploy bridge to production and monitor performance.

### Scripts

```bash
# Build for production
npm run build:web
npm run build:server

# Deploy with Docker
cat > Dockerfile <<EOF
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY . .
EXPOSE 3001
CMD ["node", "server.js"]
EOF

docker build -t web-cli-bridge .
docker run -d -p 3001:3001 web-cli-bridge

# Monitor with Prometheus
cat > prometheus.yml <<EOF
scrape_configs:
  - job_name: 'bridge'
    static_configs:
      - targets: ['localhost:3001']
EOF

# Setup logging
mkdir logs
node server.js > logs/bridge.log 2>&1 &

# Monitor logs
tail -f logs/bridge.log

# Health check
curl http://localhost:3001/health
```

## Success Criteria

- [ ] Bridge architecture designed
- [ ] Web interface functional
- [ ] CLI bridge operational
- [ ] Integration tested
- [ ] Deployed and monitored

### Performance Targets
- API response time: <200ms
- WebSocket latency: <50ms
- Command execution: <5s
- Uptime: >99.9%

## Best Practices

1. **Security:** Implement authentication and authorization
2. **Error Handling:** Graceful error handling on both sides
3. **Logging:** Comprehensive logging for debugging
4. **Rate Limiting:** Prevent abuse
5. **Validation:** Validate all inputs
6. **Monitoring:** Track performance metrics
7. **Documentation:** Document API and protocols
8. **Testing:** Comprehensive integration tests

## Common Issues & Solutions

### Issue: Command Execution Timeout
**Symptoms:** Long-running commands hang
**Solution:** Implement timeout mechanism, use async execution

### Issue: WebSocket Disconnections
**Symptoms:** Frequent disconnections
**Solution:** Implement reconnection logic, use heartbeat

### Issue: Security Vulnerabilities
**Symptoms:** Unauthorized command execution
**Solution:** Implement authentication, whitelist commands

## Integration Points

- **swarm-orchestration:** Execute orchestration from web
- **performance-analysis:** Display metrics in web UI
- **slash-commands:** Expose commands via web

## References

- WebSocket Protocol
- REST API Design
- CLI Integration Patterns
- Security Best Practices
## Core Principles

### 1. Bidirectional Communication as First-Class Citizen
The bridge must treat both directions (Web -> CLI and CLI -> Web) with equal importance and reliability.

**In practice:**
- Design symmetrical error handling for both directions
- Implement connection resilience with automatic reconnection for WebSocket channels
- Maintain state synchronization across both interfaces using shared memory or distributed cache
- Test both directions equally in integration test suites

### 2. Security Through Layered Defense
Never trust input from either side of the bridge without validation, authentication, and authorization.

**In practice:**
- Whitelist allowed CLI commands rather than blacklisting dangerous ones
- Implement JWT or API key authentication for web interface access
- Use command injection prevention by validating arguments before shell execution
- Apply rate limiting to prevent abuse from automated web clients
- Sandbox CLI execution using Docker containers or restricted user contexts

### 3. Observability and Debugging First
Bridge failures are inherently complex - make them easy to diagnose.

**In practice:**
- Log all bridge communications with correlation IDs for request tracing
- Expose health check endpoints for both web and CLI components
- Track performance metrics (latency, throughput, error rates) per endpoint
- Implement structured logging with JSON format for machine parsing
- Provide real-time monitoring dashboard showing active connections and command history

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Executing arbitrary CLI commands without validation** | Allows command injection attacks, system compromise, and data exfiltration | Implement strict command whitelisting, validate all arguments against schemas, use parameterized execution instead of shell string concatenation |
| **Long-polling instead of WebSocket for real-time updates** | Creates high latency, wastes server resources with constant HTTP overhead, poor user experience for streaming output | Use WebSocket for bidirectional streaming, implement heartbeat mechanism, fall back to SSE (Server-Sent Events) if WebSocket unavailable |
| **Storing secrets in client-side code** | Exposes API keys, database credentials, and authentication tokens to anyone inspecting web code | Store secrets server-side only, use environment variables, implement token rotation, never embed credentials in JavaScript bundles |
| **Blocking CLI operations without timeout** | Single long-running command can freeze entire bridge, resource exhaustion, poor error handling | Implement per-command timeout (default 30s, configurable), use asynchronous execution with progress callbacks, provide cancellation mechanism |
| **No authentication between web and bridge** | Anyone with network access can execute commands, potential for malicious automation, data breaches | Require JWT tokens for all API calls, implement OAuth2 for user authentication, use mTLS for bridge-to-CLI communication |

## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Executing Arbitrary Commands** | Allows command injection attacks, system compromise, and data exfiltration by passing unvalidated user input directly to shell execution. | Implement strict command whitelisting with approved commands list. Validate all arguments against schemas before execution. Use parameterized execution instead of shell string concatenation. Never trust user input. |
| **Long-Polling Instead of WebSocket** | Creates high latency, wastes server resources with constant HTTP overhead, poor user experience for streaming command output in real-time. | Use WebSocket for bidirectional streaming communication. Implement heartbeat mechanism to detect disconnections. Fall back to SSE (Server-Sent Events) if WebSocket unavailable in client environment. |
| **No Authentication Between Web/Bridge** | Anyone with network access can execute commands remotely, potential for malicious automation attacks, complete system compromise through unauthorized access. | Require JWT tokens for all API calls with expiration and rotation. Implement OAuth2 for user authentication flows. Use mTLS (mutual TLS) for bridge-to-CLI communication security. Rate limit unauthenticated requests aggressively. |

## Conclusion

The Web-CLI Teleport pattern represents a powerful integration strategy for bridging user interfaces with command-line workflows, but its power comes with significant responsibility. The bidirectional nature of this bridge creates a critical attack surface that must be secured through layered defense mechanisms - from command whitelisting and input validation to authentication, authorization, and rate limiting. When implemented correctly, this pattern enables seamless workflow automation, allowing web applications to leverage the full power of CLI tools while providing real-time feedback through WebSocket connections.

The key to success lies in treating security and observability as core design requirements rather than afterthoughts. By implementing structured logging, health checks, and performance monitoring from day one, teams can diagnose issues quickly and maintain high reliability. The anti-patterns highlighted above - particularly arbitrary command execution and lack of authentication - represent common pitfalls that can turn a useful integration tool into a critical vulnerability.

As you implement this pattern, remember that the bridge is not just a technical component but a trust boundary between user interfaces and system operations. Every command executed through the bridge should be logged, validated, and monitored. By following the core principles of bidirectional communication, layered security, and observability-first design, you can build a robust integration that enhances developer productivity while maintaining system integrity and security.
