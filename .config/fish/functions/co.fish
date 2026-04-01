function co --description "Copilot one-shot with Sonnet"
    copilot --yolo --disable-builtin-mcps --silent --stream on --no-auto-update -p "$argv" --model claude-sonnet-4.6
end
