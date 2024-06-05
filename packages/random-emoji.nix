{pkgs, ...}:
# https://unicode.org/emoji/charts/full-emoji-list.html
pkgs.writeScriptBin "random-emoji" ''
  EMOJIS=( \
    😀 😃 😄 😁 😆 😅 🤣 😂 🙂 🙃 🫠 😉 😊 😇 \
    🥰 😍 🤩 😘 😗 ☺ 😚 😙 🥲 \
    😋 😛 😜 🤪 😝 🤑 \
    🤗 🤭 🫢 🫣 🤫 🤔 🫡 \
    🤐 🤨 😐 😑 😶 🫥 😶‍🌫️ 😏 😒 🙄 😬 😮‍💨 🤥 🫨 🙂‍↔️ 🙂‍↕️ \
    😌 😔 😪 🤤 😴 \
    🤒 🤕 🤢 🤮 🤧 🥵 🥶 🥴 😵 😵‍💫 🤯 \
    🤠 🥳 🥸 \
    😎 🤓 🧐 \
    😕 🫤 😟 🙁 ☹ 😮 😯 😲 😳 🥺 🥹 😦 😧 😨 😰 😥 😢 😭 😱 😖 😣 😞 😓 😩 😫 🥱 \
    😤 😡 😠 🤬 💀 ☠ \
    💩 👻 👾 🤖 \
    😺 😸 😹 😻 😼 😽 🙀 😿 😾 \
    🙈 🙉 🙊 \
  )
  echo ''${EMOJIS[$RANDOM % ''${#EMOJIS[@]}]};
''
