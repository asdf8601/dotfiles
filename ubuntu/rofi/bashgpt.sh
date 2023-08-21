#!/bin/bash
# GPT-3 ( text-curie-001 text-babbage-001 text-ada-001 davinci curie babbage ada)
# GPT-3.5 ( gpt-3.5-turbo gpt-3.5-turbo-0301 text-davinci-003 text-davinci-002 code-davinci-002)
# GPT-4 (gpt-4 gpt-4-0314 gpt-4-32k gpt-4-32k-0314 )

OPENAI_API_KEY="${OPENAI_API_KEY:-PUT_YOUT_OPENAI_KEY_HERE}"
model="gpt-3.5-turbo"
temperature="0.7"

prompt() {
    selected=$(rofi -theme $DOTFILES/rofi/onedark.rasi -dmenu -p "$model")
    echo "$selected"
}

query="${1:-$(prompt)}"
query=$( echo "$query" | tr '\"' '`' )

[[ -z "$query" ]] && exit 1

echo "$query" >> "$history_file"

result=$(curl -s https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "{
        \"model\": \"$model\",
        \"messages\": [{ \"role\": \"user\", \"content\": \"${query}\" }],
        \"temperature\": $temperature
    }" | jq '.choices[0].message.content' | sed 's/\\n//g' )

[[ -z "$1" ]] && rofi -e "$result" "${theme_options[@]}"
echo "$result" | xclip -selection clipboard
