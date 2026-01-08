#!/usr/bin/env bash
# EnvVar Spill Detector - Because your secrets deserve better than GitHub fame
# The digital equivalent of checking your fly before leaving the bathroom

# Colors for dramatic effect (because security breaches are dramatic)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color (like your face when you realize what you committed)

# Common patterns that scream "I'm a secret!"
PATTERNS=(
    "API_KEY"
    "APIKEY"
    "SECRET"
    "PASSWORD"
    "TOKEN"
    "PRIVATE_KEY"
    "AWS_ACCESS"
    "AWS_SECRET"
    "DATABASE_URL"
    "CREDENTIAL"
)

# The main event: hunting for digital skeletons in your code closet
check_files() {
    local found_secrets=false
    
    echo -e "${YELLOW}🔍 Scanning for accidental secret confessions...${NC}"
    echo -e "${YELLOW}📝 (Checking files with common extensions)${NC}"
    echo
    
    # Look in files that might contain code/config (not binary files)
    for file in $(find . -type f \( -name "*.py" -o -name "*.js" -o -name "*.json" -o -name "*.yml" -o -name "*.yaml" -o -name "*.env" -o -name "*.sh" \) 2>/dev/null); do
        for pattern in "${PATTERNS[@]}"; do
            # Case-insensitive search for our naughty patterns
            if grep -qi "${pattern}" "${file}"; then
                if [ "$found_secrets" = false ]; then
                    found_secrets=true
                    echo -e "${RED}🚨 POSSIBLE SECRET SPILL DETECTED!${NC}"
                    echo -e "${RED}=================================${NC}"
                fi
                
                echo -e "${YELLOW}📄 File:${NC} ${file}"
                echo -e "${RED}⚠️  Contains pattern:${NC} ${pattern}"
                
                # Show the offending line (because shame is a great teacher)
                grep -i "${pattern}" "${file}" | head -3 | while read line; do
                    echo -e "   ${YELLOW}Line:${NC} ${line:0:100}"
                done
                echo
            fi
        done
    done
    
    if [ "$found_secrets" = false ]; then
        echo -e "${GREEN}✅ No obvious secrets found!${NC}"
        echo -e "${GREEN}   (But remember: absence of evidence is not evidence of absence)${NC}"
    else
        echo -e "${RED}💀 ACTION REQUIRED:${NC} Review above files before committing!"
        echo -e "${RED}   Your future self (and security team) will thank you.${NC}"
        exit 1
    fi
}

# Help text for the forgetful (we've all been there)
show_help() {
    echo "Usage: $0 [OPTION]"
    echo "Detect potential environment variable spills in your codebase."
    echo
    echo "Options:"
    echo "  --help     Show this help message (you're using it now)"
    echo "  --check    Scan for secrets (default action)"
    echo
    echo "Example:"
    echo "  $0 --check    # Look for accidental secret sharing"
}

# Main logic - simpler than your average password
case "${1}" in
    "--help"|"-h"|"")
        show_help
        ;;
    "--check"|*)
        check_files
        ;;
esac
