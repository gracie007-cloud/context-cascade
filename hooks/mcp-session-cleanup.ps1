# MCP-Session-Cleanup.ps1
# Reminder script for cleaning up situational MCPs after session

Write-Host "=================================================="
Write-Host "!! SESSION ENDING - MCP CLEANUP REMINDER !!"
Write-Host "=================================================="
Write-Host ""
Write-Host "If you activated situational MCPs during this session,"
Write-Host "consider deactivating them to reduce startup time:"
Write-Host ""
Write-Host "  # Remove all situational MCPs"
Write-Host "  powershell -File C:\Users\17175\REMOVE-MCP.ps1 all-situational"
Write-Host ""
Write-Host "  # Or remove specific categories:"
Write-Host "  powershell -File C:\Users\17175\REMOVE-MCP.ps1 code-quality"
Write-Host "  powershell -File C:\Users\17175\REMOVE-MCP.ps1 automation"
Write-Host ""
Write-Host "Remember to restart Claude Desktop after changes."
Write-Host "=================================================="
