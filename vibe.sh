vibe() {
  local BLUE="\033[1;34m"
  local GREEN="\033[1;32m"
  local YELLOW="\033[1;33m"
  local RED="\033[1;31m"
  local CYAN="\033[1;36m"
  local RESET="\033[0m"
  local BOLD="\033[1m"

  local backup_flag=0
  local push_flag=0
  local pr_flag=0

  local VIBE_SYSTEM_PROMPT="You are a helpful assistant who answers questions clearly and directly, focusing only on the essential information.\nWhen asked to write or modify code in a file, always provide the entire content of the file, including unchanged lines and your modifications. Do not include any explanations or additional comments—only output the complete, updated file. Always ensure that the entire file contents are returned in your response, preserving all content unless explicitly instructed otherwise. Never add markdown code block quotes or any additional formatting—output the file content exactly as it should appear in the file."

  local args=()
  for arg in "$@"; do
    if [ "$arg" = "--backup" ]; then
      backup_flag=1
    elif [ "$arg" = "--push" ]; then
      push_flag=1
    elif [ "$arg" = "--pr" ]; then
      pr_flag=1
    else
      args+=("$arg")
    fi
  done

  if [ ${#args[@]} -lt 1 ]; then
    echo -e "${CYAN}" >&2
    echo " __     __ _ _           " >&2
    echo " \ \   / /(_) |__   ___  " >&2
    echo "  \ \ / / | | '_ \ / _ \ " >&2
    echo "   \ V /  | | | | | (_) |" >&2
    echo "    \_/   |_|_| |_|\___/ " >&2
    echo -e "${RESET}${GREEN}Welcome to Vibe!${RESET}" >&2
    echo -e "${BOLD}Usage:${RESET} vibe <instructions> [<filename>] [--backup] [--push] [--pr]" >&2
    return 1
  fi

  local instructions="${args[1]}"
  local file=""
  local output_to_stdout=""
  local target_type=""
  local ask_target_prompt="Determine if the target of the instructions is a file or the stdout. I need to know if a file should be created/modified or the result should be echoed in the terminal. Here is the instructions: $instructions. If it is a file, please provide the filename. If it is stdout, please say 'stdout'."

  if [ ${#args[@]} -lt 2 ]; then
    echo -e "${YELLOW}🔍 Determining target (file or stdout) via chatgpt...${RESET}" >&2
    target_type="$(chatgpt "$ask_target_prompt" | head -n 1 | tr -d '\"')"
    if [ -z "$target_type" ]; then
      echo -e "${RED}❌ No target could be extracted from the instructions.${RESET}" >&2
      return 1
    fi
    if [ "$target_type" = "stdout" ]; then
      output_to_stdout="yes"
    else
      output_to_stdout="no"
      file="$target_type"
    fi
    echo -e "${CYAN}🔎 ChatGPT decided:${RESET} ${BOLD}$target_type${RESET}" >&2
  else
    file="${args[2]}"
    echo -e "${CYAN}📄 Filename provided as argument:${RESET} ${BOLD}$file${RESET}" >&2
    output_to_stdout="no"
  fi

  if git rev-parse --abbrev-ref HEAD | grep -q -E 'main|master'; then
    echo -e "${YELLOW}💡 You are on the main or master branch. It is recommended to create a dev or feat branch for new changes.${RESET}" >&2
    echo -e "Do you want to continue? (y/n): "
    read approval
    if [[ "$approval" != "y" ]]; then
      echo -e "${RED}❌ Operation canceled.${RESET}" >&2
      return 1
    fi
  fi

  if [ "$output_to_stdout" = "yes" ]; then
    local content prompt improved
    echo -e "${YELLOW}📝 Building prompt for chatgpt...${RESET}" >&2
    prompt="Improve this file with the following instructions: $instructions"
    echo -e "${CYAN}🤖 Requesting improvements from chatgpt...${RESET}" >&2
    improved="$(chatgpt --role "$VIBE_SYSTEM_PROMPT" "$prompt")"
    if [ -z "$improved" ]; then
      echo -e "${RED}❌ No improvement result produced.${RESET}" >&2
      return 1
    fi
    printf "%s\n" "$improved"
    if [ "$pr_flag" -eq 1 ]; then
      pr
    fi
    return 0
  fi

  if [ -z "$file" ]; then
    echo -e "${RED}❌ No filename was determined for file update.${RESET}" >&2
    return 1
  fi

  if [ ! -f "$file" ]; then
    echo -e "${YELLOW}🆕 File does not exist. Creating file:${RESET} $file" >&2
    touch "$file"
  fi

  if [ ! -f "$file" ]; then
    echo -e "${RED}❌ File not found:${RESET} $file${RESET}" >&2
    return 1
  fi

  local content prompt improved

  echo -e "${BLUE}📖 Reading file:${RESET} ${CYAN}$file${RESET}" >&2
  content="$(<"$file")"

  echo -e "${YELLOW}📝 Building prompt for chatgpt...${RESET}" >&2
  prompt="Improve this file with the following instructions: $instructions
\`\`\`
$content
\`\`\`"

  echo -e "${CYAN}🤖 Requesting improvements from chatgpt...${RESET}" >&2
  improved="$(chatgpt --role "$VIBE_SYSTEM_PROMPT" "$prompt")"
  if [ -z "$improved" ]; then
    echo -e "${RED}❌ No improvements made to ${RESET}${CYAN}$file${RESET}${RED}.${RESET}" >&2
    return 1
  fi

  if [ "$backup_flag" -eq 1 ]; then
    local backup="$file.bak.$(date +%s)"
    echo -e "${YELLOW}🗄️  Creating backup at${RESET} ${CYAN}$backup${RESET}" >&2
    cp "$file" "$backup"
  fi

  echo -e "${GREEN}✍️  Overwriting${RESET} ${CYAN}$file${RESET} ${GREEN}with improvements...${RESET}" >&2
  printf "%s\n" "$improved" > "$file"
  if [ "$backup_flag" -eq 1 ]; then
    echo -e "${GREEN}✅ Improvement complete!${RESET} ${BOLD}Backup saved as${RESET} ${CYAN}$backup${RESET} ${GREEN}🎉${RESET}" >&2
  else
    echo -e "${GREEN}✅ Improvement complete!${RESET} ${CYAN}$file${RESET} ${GREEN}overwritten.${RESET}" >&2
  fi

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [ -f "$file" ]; then
    git add "$file"
    commit
    if [ "$push_flag" -eq 1 ] && [ $? -eq 0 ]; then
      git push
    fi
    if [ "$pr_flag" -eq 1 ] && [ $? -eq 0 ]; then
      pr
    fi
  fi
}
