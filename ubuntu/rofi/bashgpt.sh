#!/bin/bash
# GPT-3 ( text-curie-001 text-babbage-001 text-ada-001 davinci curie babbage ada)
# GPT-3.5 ( gpt-3.5-turbo gpt-3.5-turbo-0301 text-davinci-003 text-davinci-002 code-davinci-002)
# GPT-4 (gpt-4 gpt-4-0314 gpt-4-32k gpt-4-32k-0314 )
#!/bin/bash

OPENAI_API_KEY="${OPENAI_API_KEY:-PUT_YOUT_OPENAI_KEY_HERE}"
model="gpt-3.5-turbo"
temperature="0.7"

theme_options=(
    -theme-str '#window {background: #282C34;}'             # fondo de la ventana
    -theme-str '#prompt {text-color: #61AFEF;}'             # color del texto del prompt
    -theme-str '#entry {text-color: #ABB2BF;}'              # color del texto ingresado
    -theme-str '#normal {background-color: #282C34; text-color: #ABB2BF;}'     # color de la opción normal
    -theme-str '#active {background-color: #353B45; text-color: #ABB2BF;}'     # color de la opción activa
    -theme-str '#urgent {background-color: #E06C75; text-color: #ABB2BF;}'     # color de la opción urgente
    -theme-str '#selected {background-color: #61AFEF; text-color: #282C34;}'   # color de la opción seleccionada
    -theme-str '#message {text-color: #98C379;}'            # color del mensaje
)


rofi_prompt() {
    selected=$( rofi -e -p "$model" "${theme_options[@]}")
    echo $selected
}


query="${1:-$(rofi_prompt)}"
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
