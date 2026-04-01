function coco --description "Copilot one-shot with Sonnet (continue)"
    copilot --yolo --disable-builtin-mcps --silent --stream on --no-auto-update -p "$argv" --model claude-sonnet-4.6 --continue
end
