function copus --description "Copilot one-shot with Opus"
    copilot --yolo --disable-builtin-mcps --silent --stream on --no-auto-update -p "$argv" --model claude-opus-4.6
end
