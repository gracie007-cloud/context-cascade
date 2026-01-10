# Pre-Task Hook: Memory MCP Triple-Tier Query Reminder
# Fires before Task() to remind agents to check memory
# Updated: 2026-01-09 for triple-tier architecture

$ErrorActionPreference = "SilentlyContinue"

Write-Host @"
!! MEMORY-MCP: PRE-TASK CHECK !!

TRIPLE-TIER QUERY before starting task:

1. VECTOR RAG TIER (40% weight):
   - Semantic search for similar past work
   - Query by PROJECT filter for relevant context
   - Check prior findings in same domain

2. HIPPORAG TIER (40% weight):
   - Multi-hop graph traversal for related concepts
   - Find connected entities via graph relationships
   - Check relationship chains: pattern -> implementation -> fix

3. BAYESIAN TIER (20% weight):
   - Probabilistic ranking by confidence
   - Filter by confidence > 0.7 for high-quality results
   - Consider decay score for temporal relevance

QUERY PATTERNS:
   "What was done before?"     -> Vector: PROJECT filter
   "Are there related issues?" -> HippoRAG: graph traversal
   "What patterns worked?"     -> Bayesian: high confidence filter

REMEMBER: Check existing before implementing new!

"@

exit 0
