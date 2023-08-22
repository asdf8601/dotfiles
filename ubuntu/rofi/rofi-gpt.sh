#!/usr/bin/env bash
OPENAI_API_KEY="${OPENAI_API_KEY:-PUT_YOUT_OPEEN_AI_KEY_HERE}"
model="gpt-3.5-turbo"
temperature="0.7"
QUESTION_FILE="$HOME/.bashgpt_user_prompts"
PROMPT_FILE="$HOME/.bashgpt_prompts"
ANSWER_FILE="$HOME/.bashgpt_answers"

get_user_prompt() {
    verb=$(cat $PROMPT_FILE | rofi -dmenu -p "ChatGPT($model) >>>")
    object=$(cat $QUESTION_FILE | rofi -dmenu -p "$verb")
    echo $verb>> $PROMPT_FILE
    echo "$object" >> $QUESTION_FILE
    echo "$verb $object"
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
        | sed 's/\\n/\r/g'
    )
    echo "$answer\n---" >> $ANSWER_FILE
    echo "$answer"
}

if [[ -z "$1" ]]; then
    user_prompt=$(get_user_prompt)
    [[ -z "$user_prompt" ]] && exit 1  # Exit if query is empty
    content="Avoid giving answers with triple backsticks. You answer should not be in markdown, nor should it include backsticks. Follow the Instructions: $user_prompt"
    answer=$(get_answer "$content")
    rofi -e "$answer"  # Display
    echo "$answer" | xclip -selection clipboard  # Copy to clipboard
else
    answer=$(get_answer "$1")
    echo "$answer" | xclip -selection clipboard  # Copy to clipboard
    echo -n "$answer"
fi


# vim: tw=0
