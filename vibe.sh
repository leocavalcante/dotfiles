#!/usr/bin/env bash
#
# VIBE - AI-Powered Code Assistant
# ================================
# This tool enables seamless integration of AI assistance into your development workflow.
# It can modify files based on natural language instructions or provide answers directly
# to your terminal.
#
# IMPORTANT: This file was generated using the Vibe Coding process.
# Only modify for prompt improvements or critical fixes.

vibe() {
  # Define terminal colors for better UI
  local BLUE="\033[1;34m"
  local GREEN="\033[1;32m"
  local YELLOW="\033[1;33m"
  local RED="\033[1;31m"
  local CYAN="\033[1;36m"
  local RESET="\033[0m"
  local BOLD="\033[1m"

  # Command flags
  local backup_flag=0
  local push_flag=0
  local pr_flag=0

  # AI system prompt - significantly enhanced for better file handling and clear responses
  local VIBE_SYSTEM_PROMPT="You are an expert programming assistant focused on providing precise, concise solutions.

WHEN MODIFYING OR CREATING FILES:
1. Output the COMPLETE file contents with your changes integrated
2. Do NOT include explanations, markdown formatting, code block markers, or comments about your changes
3. Preserve all existing formatting, comments, and structure unless explicitly asked to change them
4. The output should be ready to save directly to a file without any additional processing

WHEN ANSWERING GENERAL QUESTIONS:
1. Be concise and direct
2. Focus on practical solutions
3. Use clear, specific examples when helpful
4. Avoid unnecessary explanations unless requested"

  # Parse command arguments
  local args=()
  for arg in "$@"; do
    case "$arg" in
      --backup) backup_flag=1 ;;
      --push) push_flag=1 ;;
      --pr) pr_flag=1 ;;
      *) args+=("$arg") ;;
    esac
  done

  # Display usage if no arguments provided
  if [ ${#args[@]} -lt 1 ]; then
    echo -e "${CYAN}" >&2
    echo " __     __ _ _           " >&2
    echo " \ \   / /(_) |__   ___  " >&2
    echo "  \ \ / / | | '_ \ / _ \ " >&2
    echo "   \ V /  | | | | | (_) |" >&2
    echo "    \_/   |_|_| |_|\___/ " >&2
    echo -e "${RESET}${GREEN}Welcome to Vibe!${RESET}" >&2
    echo -e "${BOLD}Usage:${RESET} vibe <instructions> [<filename>] [--backup] [--push] [--pr]" >&2
    echo -e "" >&2
    echo -e "${BOLD}Options:${RESET}" >&2
    echo -e "  --backup    Create backup of original file" >&2
    echo -e "  --push      Push changes to remote after commit" >&2
    echo -e "  --pr        Create a pull request after commit" >&2
    return 1
  fi

  # Validate dependencies
  if ! command -v chatgpt &> /dev/null; then
    echo -e "${RED}❌ Required dependency 'chatgpt' not found.${RESET}" >&2
    echo -e "${YELLOW}Please install from: ${CYAN}https://github.com/kardolus/chatgpt-cli${RESET}" >&2
    return 1
  fi

  # Get instructions and determine target
  local instructions="${args[1]}"
  local file=""
  local output_to_stdout=""
  
  # Improved prompt for determining target
  local target_detection_prompt="Analyze the following instructions to determine if they require:
1. Creating or modifying a specific file (respond with just the filename)
2. A general response printed to the terminal (respond with just 'stdout')

Instructions: \"\"\"${instructions}\"\"\"

Your response should be ONLY the filename or 'stdout', nothing else."

  # Process user input to determine file or stdout
  if [ ${#args[@]} -lt 2 ]; then
    echo -e "${YELLOW}🔍 Analyzing instructions to determine target...${RESET}" >&2
    
    # Get target from AI
    target_type="$(chatgpt --omit-history --role "$VIBE_SYSTEM_PROMPT" "$target_detection_prompt" | head -n 1 | tr -d '\"')"
    
    if [ -z "$target_type" ]; then
      echo -e "${RED}❌ Failed to determine target from instructions.${RESET}" >&2
      return 1
    fi
    
    if [ "$target_type" = "stdout" ]; then
      output_to_stdout="yes"
      echo -e "${CYAN}🎯 Target determined:${RESET} ${BOLD}Terminal output${RESET}" >&2
    else
      output_to_stdout="no"
      file="$target_type"
      echo -e "${CYAN}🎯 Target determined:${RESET} ${BOLD}File: $file${RESET}" >&2
    fi
  else
    # User provided filename explicitly
    file="${args[2]}"
    echo -e "${CYAN}📄 Using provided filename:${RESET} ${BOLD}$file${RESET}" >&2
    output_to_stdout="no"
  fi

  # Handle terminal output mode
  if [ "$output_to_stdout" = "yes" ]; then
    echo -e "${YELLOW}📝 Processing your query...${RESET}" >&2
    
    # Enhanced prompt for general queries
    local query_prompt="Provide a clear, concise response to this query: $instructions"
    
    echo -e "${CYAN}🤖 Consulting AI...${RESET}" >&2
    local response="$(chatgpt --omit-history --role "$VIBE_SYSTEM_PROMPT" "$query_prompt")"
    
    if [ -z "$response" ]; then
      echo -e "${RED}❌ Failed to get a response.${RESET}" >&2
      return 1
    fi
    
    echo -e "${GREEN}✅ Response:${RESET}\n" >&2
    printf "%s\n" "$response"
    
    # Handle PR flag if applicable
    if [ "$pr_flag" -eq 1 ]; then
      pr
    fi
    return 0
  fi

  # Validate file target
  if [ -z "$file" ]; then
    echo -e "${RED}❌ No filename could be determined.${RESET}" >&2
    return 1
  fi

  # Create file if it doesn't exist
  if [ ! -f "$file" ]; then
    echo -e "${YELLOW}🆕 Creating new file:${RESET} $file" >&2
    touch "$file"
    
    if [ ! -f "$file" ]; then
      echo -e "${RED}❌ Failed to create file:${RESET} $file" >&2
      return 1
    fi
  fi

  # Read file content
  echo -e "${BLUE}📖 Reading file:${RESET} ${CYAN}$file${RESET}" >&2
  local content="$(<"$file")"

  # Enhanced prompt for file modifications
  local file_modification_prompt="Instructions for file modification:
\"\"\"${instructions}\"\"\"

Current file content:
\"\"\"${content}\"\"\"

Respond ONLY with the complete updated file content, exactly as it should be saved."

  echo -e "${CYAN}🤖 Applying improvements via AI...${RESET}" >&2
  local improved="$(chatgpt --omit-history --role "$VIBE_SYSTEM_PROMPT" "$file_modification_prompt")"
  
  if [ -z "$improved" ]; then
    echo -e "${RED}❌ AI returned empty content for${RESET} ${CYAN}$file${RESET}" >&2
    return 1
  fi

  # Create backup if requested
  if [ "$backup_flag" -eq 1 ]; then
    local backup="$file.bak.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}🗄️  Creating backup at${RESET} ${CYAN}$backup${RESET}" >&2
    cp "$file" "$backup"
  fi

  # Write improvements to file
  echo -e "${GREEN}✍️  Updating${RESET} ${CYAN}$file${RESET}" >&2
  printf "%s\n" "$improved" > "$file"
  
  if [ "$backup_flag" -eq 1 ]; then
    echo -e "${GREEN}✅ File updated!${RESET} ${BOLD}Backup saved at${RESET} ${CYAN}$backup${RESET}" >&2
  else
    echo -e "${GREEN}✅ File successfully updated!${RESET}" >&2
  fi

  # Handle git operations if in a git repository
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [ -f "$file" ]; then
    echo -e "${BLUE}🔄 Adding file to git...${RESET}" >&2
    git add "$file"
    commit
    
    if [ "$push_flag" -eq 1 ] && [ $? -eq 0 ]; then
      echo -e "${BLUE}🚀 Pushing changes...${RESET}" >&2
      git push
    fi
    
    if [ "$pr_flag" -eq 1 ] && [ $? -eq 0 ]; then
      echo -e "${BLUE}📝 Creating pull request...${RESET}" >&2
      pr
    fi
  fi
}
