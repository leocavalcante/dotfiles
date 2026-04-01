function coha --description "Copilot one-shot with Haiku"
    copilot --yolo --disable-builtin-mcps --silent --stream on --no-auto-update -p "$argv" --model claude-haiku-4.5
end
