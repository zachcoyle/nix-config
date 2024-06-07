const yubikeyNeedsAttention = Variable(false, {
  poll: [
    1000,
    ["yubikey-touch-detector", "-stdout", "-no-socket"],
    (out) => {
      print(out);
      return out === "U2F_1";
    },
  ],
});

export const Yubikey = Widget.Icon({
  icon: yubikeyNeedsAttention
    .bind()
    .as((b) => App.configDir + "/" + (b ? "pop-cat.png" : "pixel.png")),
  size: 20,
});
