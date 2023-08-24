#!/usr/bin/env bash
OPENAI_API_KEY="${OPENAI_API_KEY:-PUT_YOUT_OPEEN_AI_KEY_HERE}"
model="gpt-3.5-turbo"
model="gpt-4"
temperature="0.7"
PROMPT1_FILE="$HOME/.bashgpt_prompts1"
PROMPT2_FILE="$HOME/.bashgpt_prompts2"
ANSWERS_FILE="$HOME/.bashgpt_answers"
MOD_PROMPT="Avoid giving answers with triple backsticks. You answer should not be in markdown, nor should it include backsticks. Follow the Instructions:"
MOD_PROMPT=""

get_user_prompt() {
    prompt1=$(cat $PROMPT1_FILE | rofi -dmenu -p "$model")
    prompt2=$(cat $PROMPT2_FILE | rofi -dmenu -p "$prompt1")
    update_file $PROMPT1_FILE "$prompt1"
    update_file $PROMPT2_FILE "$prompt2"
    echo "$prompt1 $prompt2"
}

update_file() {
    file=$1
    text="$2"
    echo "$text" >> $file
    cat $file | sort -u > /tmp/.bashgpt && mv /tmp/.bashgpt $file
}

get_answer() {
    local content="$1"
    answer=$( \
    curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"$model\",
            \"messages\": [{ \"role\": \"user\", \"content\": \"$content\" }],
            \"temperature\": $temperature \
        }" \
        | jq '.choices[0].message.content' \
        | sed 's/\\n/\r/g' \
        | python -c "import sys; print(sys.stdin.read().strip('\"\r\s\n'))"
    )
    # echo "$answer\n---" >> $ANSWERS_FILE
    echo "$answer"
}

if [[ -z "$1" ]]; then
    user_prompt=$(get_user_prompt)
    [[ -z "$user_prompt" ]] && exit 1  # Exit if query is empty
    ask_this="$MOD_PROMPT $user_prompt"
    answer=$(get_answer "$ask_this")
    rofi -e "$answer"  # Display
    echo "$answer" | xclip -selection clipboard  # Copy to clipboard
else
    answer=$(get_answer "$1")
    echo "$answer" | xclip -selection clipboard  # Copy to clipboard
    echo -n "$answer"
fi


# vim: tw=0 ft=sh
