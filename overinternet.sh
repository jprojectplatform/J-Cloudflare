#!/bin/bash

###############################################################################
# overinternet.sh - Cloudflare Tunnel Script
# 
# Created by: jh4ck3r from J Project Platform
# Website: https://jprojectplatform.com/
# 
# Description: This script creates a Cloudflare Tunnel to expose your localhost
#              application over the internet with a fresh random URL each time.
###############################################################################

# Configuration
PORT=5000  # Change this port if your app runs on a different port
LOG_FILE="cloudflared.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Display script header
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                   overinternet.sh                            ║"
echo "║         Cloudflare Tunnel Automation Script                 ║"
echo "║     Created by jh4ck3r - J Project Platform                 ║"
echo "║           https://jprojectplatform.com/                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Display usage information
echo -e "${YELLOW}📖 USAGE INSTRUCTIONS:${NC}"
echo -e "${CYAN}• This script exposes your localhost:${PORT} over the internet"
echo -e "• Each run generates a new random URL"
echo -e "• Perfect for testing, demos, and temporary access"
echo -e "• Press Ctrl+C to stop the tunnel and close access"
echo -e ""
echo -e "${YELLOW}🔧 CONFIGURATION:${NC}"
echo -e "${CYAN}• Change PORT variable above if your app uses different port"
echo -e "• Default port: ${PORT} (edit line 15 to change)"
echo -e "• Make sure cloudflared is installed in current directory"
echo -e "• Ensure your application is running before starting tunnel"
echo -e ""

# Function to show help
show_help() {
    echo -e "${GREEN}🚀 QUICK START:${NC}"
    echo -e "1. Start your application on port ${PORT}"
    echo -e "2. Run: ./overinternet.sh"
    echo -e "3. Share the generated URL with anyone"
    echo -e "4. Press Ctrl+C when done to close tunnel"
    echo -e ""
    echo -e "${YELLOW}📝 PORT CHANGE EXAMPLE:${NC}"
    echo -e "If your app runs on port 3000, edit line 15 to:"
    echo -e "PORT=3000"
    echo -e ""
    echo -e "${CYAN}🔍 PREREQUISITES:${NC}"
    echo -e "• cloudflared binary in current directory"
    echo -e "• Application running on localhost:${PORT}"
    echo -e "• Internet connection"
    echo -e "----------------------------------------${NC}"
    echo -e ""
}

# Check if help requested
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_help
    exit 0
fi

# Function to cleanup
cleanup() {
    echo -e "\n${YELLOW}🛑 Stopping tunnel...${NC}"
    pkill cloudflared 2>/dev/null
    rm -f $LOG_FILE
    echo -e "${GREEN}✅ Cleanup complete${NC}"
    echo -e "${CYAN}💡 Tunnel URL is no longer accessible${NC}"
    exit 0
}

# Set trap for Ctrl+C
trap cleanup INT

# Check if cloudflared exists
if [ ! -f "./cloudflared" ]; then
    echo -e "${RED}❌ cloudflared binary not found in current directory${NC}"
    echo -e "${YELLOW}💡 Download it from:${NC}"
    echo -e "https://github.com/cloudflare/cloudflared/releases/latest"
    echo -e "${YELLOW}💡 Or install with:${NC}"
    echo -e "curl -L --output cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
    echo -e "chmod +x cloudflared"
    exit 1
fi

# Make cloudflared executable
chmod +x ./cloudflared 2>/dev/null

# Kill existing tunnels
echo -e "${YELLOW}🔍 Checking for existing tunnels...${NC}"
pkill cloudflared 2>/dev/null && echo -e "${GREEN}✅ Stopped existing tunnel${NC}"
sleep 2

# Check if port is serving
echo -e "${YELLOW}🔍 Checking localhost:${PORT}...${NC}"
if curl -s http://localhost:$PORT >/dev/null 2>&1; then
    echo -e "${GREEN}✅ localhost:${PORT} is accessible${NC}"
else
    echo -e "${RED}❌ localhost:${PORT} is not responding${NC}"
    echo -e "${YELLOW}💡 Make sure your application is running on port ${PORT}${NC}"
    echo -e "${YELLOW}💡 If your app uses a different port, edit the PORT variable in this script${NC}"
    echo -e "${YELLOW}💡 Current port setting: ${PORT} (change line 15 if needed)${NC}"
    echo -e ""
    echo -e "${CYAN}🔧 TROUBLESHOOTING:${NC}"
    echo -e "• Run your app first: python3 app.py OR node app.js OR ./your_app"
    echo -e "• Check if port is in use: netstat -tulpn | grep :${PORT}"
    echo -e "• Verify your app is bound to 0.0.0.0 or localhost"
    exit 1
fi

# Start cloudflared in background and capture output
echo -e "${CYAN}🌐 Starting new Cloudflare Tunnel...${NC}"
./cloudflared tunnel --url http://localhost:$PORT > $LOG_FILE 2>&1 &

# Wait for tunnel to establish
echo -e "${YELLOW}⏳ Waiting for tunnel URL...${NC}"
sleep 8

# Extract URL from logs
TUNNEL_URL=$(grep -o 'https://[a-zA-Z0-9.-]*\.trycloudflare\.com' $LOG_FILE | head -1)

if [ -n "$TUNNEL_URL" ]; then
    echo -e "\n${GREEN}🎯 FRESH TUNNEL URL CREATED!${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${TUNNEL_URL}${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📋 This URL will work until you stop this script${NC}"
    echo -e "${YELLOW}⏹️  Press Ctrl+C to stop the tunnel${NC}"
    echo -e ""
    echo -e "${CYAN}🌍 NOW ACCESSIBLE FROM:${NC}"
    echo -e "• Anywhere on the internet"
    echo -e "• Mobile devices"
    echo -e "• Other computers"
    echo -e "• Share with teammates/clients"
    
    # Save URL to file for easy access
    echo $TUNNEL_URL > latest_tunnel_url.txt
    echo -e "${GREEN}💾 URL saved to latest_tunnel_url.txt${NC}"
else
    echo -e "${RED}❌ Failed to get tunnel URL${NC}"
    echo -e "${YELLOW}📋 Check the log file: $LOG_FILE${NC}"
    echo -e "${YELLOW}💡 Try running cloudflared manually to debug:${NC}"
    echo -e "./cloudflared tunnel --url http://localhost:$PORT"
    cleanup
    exit 1
fi

# Keep script running and show traffic
echo -e "\n${CYAN}📊 Tunnel is active. Monitoring traffic...${NC}"
echo -e "${YELLOW}💡 New connections will appear below:${NC}"
tail -f $LOG_FILE | while read line; do
    if echo "$line" | grep -q "cf-ray"; then
        echo -e "${GREEN}📡 New connection: $(echo "$line" | grep -o 'cf-ray=[^ ]*')${NC}"
    fi
    # Also show errors in red
    if echo "$line" | grep -qi "error\|failed"; then
        echo -e "${RED}⚠️  Error: $line${NC}"
    fi
done