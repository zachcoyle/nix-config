{pkgs, ...}:
# https://unicode.org/emoji/charts/full-emoji-list.html
pkgs.writeShellApplication {
  name = "random-emoji";
  text = ''
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
    echo "''${EMOJIS[$RANDOM % ''${#EMOJIS[@]}]}";
  '';
}
