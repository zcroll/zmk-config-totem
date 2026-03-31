#!/usr/bin/env bash

set -euo pipefail

TITLE="Totem Bluetooth Helper"

supports_whiptail() {
  command -v whiptail >/dev/null 2>&1 && [ -t 1 ]
}

show_text() {
  printf '\n%s\n\n%s\n' "$1" "$2"
}

show_message() {
  local title="$1"
  local body="$2"

  if supports_whiptail; then
    whiptail --title "$title" --msgbox "$body" 20 78
  else
    show_text "$title" "$body"
  fi
}

menu_choice() {
  if supports_whiptail; then
    whiptail \
      --title "$TITLE" \
      --menu "Choose an action" 22 78 12 \
      "bt0" "Bluetooth device 0" \
      "bt1" "Bluetooth device 1" \
      "bt2" "Bluetooth device 2" \
      "bt3" "Bluetooth device 3" \
      "usb" "Switch to USB output" \
      "clear0" "Clear Bluetooth device 0" \
      "clear1" "Clear Bluetooth device 1" \
      "clear2" "Clear Bluetooth device 2" \
      "clear3" "Clear Bluetooth device 3" \
      "layout" "Show thumb-key map" \
      "quit" "Exit" \
      3>&1 1>&2 2>&3
  else
    cat <<'EOF'
Totem Bluetooth Helper

1) Bluetooth device 0
2) Bluetooth device 1
3) Bluetooth device 2
4) Bluetooth device 3
5) Switch to USB output
6) Clear Bluetooth device 0
7) Clear Bluetooth device 1
8) Clear Bluetooth device 2
9) Clear Bluetooth device 3
10) Show thumb-key map
11) Exit
EOF
    printf '\nChoose: '
    read -r choice
    case "$choice" in
      1) printf 'bt0' ;;
      2) printf 'bt1' ;;
      3) printf 'bt2' ;;
      4) printf 'bt3' ;;
      5) printf 'usb' ;;
      6) printf 'clear0' ;;
      7) printf 'clear1' ;;
      8) printf 'clear2' ;;
      9) printf 'clear3' ;;
      10) printf 'layout' ;;
      *) printf 'quit' ;;
    esac
  fi
}

thumb_map() {
  cat <<'EOF'
Hold the left yellow thumb key to enter NAV.

While holding NAV, use the left hand:

- Q = USB output
- A = Bluetooth output
- W = Bluetooth device 3
- R = Bluetooth device 0
- S = Bluetooth device 1
- T = Bluetooth device 2
- D = Clear selected Bluetooth device

SYS layer is still available as a fallback using FN + NUM.
EOF
}

bt_steps() {
  local slot="$1"

  case "$slot" in
    0)
      cat <<'EOF'
To use Bluetooth device 0:

1. Hold the left yellow thumb key (NAV).
2. Tap A to switch to Bluetooth output.
3. Tap R to select Bluetooth device 0.
4. Pair or reconnect from your computer or phone.
EOF
      ;;
    1)
      cat <<'EOF'
To use Bluetooth device 1:

1. Hold the left yellow thumb key (NAV).
2. Tap A to switch to Bluetooth output.
3. Tap S to select Bluetooth device 1.
4. Pair or reconnect from your computer or phone.
EOF
      ;;
    2)
      cat <<'EOF'
To use Bluetooth device 2:

1. Hold the left yellow thumb key (NAV).
2. Tap A to switch to Bluetooth output.
3. Tap T to select Bluetooth device 2.
4. Pair or reconnect from your computer or phone.
EOF
      ;;
    3)
      cat <<'EOF'
To use Bluetooth device 3:

1. Hold the left yellow thumb key (NAV).
2. Tap A to switch to Bluetooth output.
3. Tap W to select Bluetooth device 3.
4. Pair or reconnect from your computer or phone.
EOF
      ;;
  esac
}

clear_steps() {
  local slot="$1"
  local select_step

  case "$slot" in
    0) select_step="Tap R to select Bluetooth device 0." ;;
    1) select_step="Tap S to select Bluetooth device 1." ;;
    2) select_step="Tap T to select Bluetooth device 2." ;;
    3) select_step="Tap W to select Bluetooth device 3." ;;
  esac

  cat <<EOF
To clear Bluetooth device $slot:

1. Hold the left yellow thumb key (NAV).
2. Tap A to switch to Bluetooth output.
3. $select_step
4. Tap D to clear the selected Bluetooth device.
5. Remove the keyboard from your computer or phone Bluetooth settings.
6. Pair again if needed.
EOF
}

usb_steps() {
  cat <<'EOF'
To switch the keyboard to USB output:

1. Hold the left yellow thumb key (NAV).
2. Tap Q for USB output.

This makes key presses go over the cable instead of Bluetooth.
EOF
}

while true; do
  choice="$(menu_choice)"

  case "$choice" in
    bt0) show_message "$TITLE" "$(bt_steps 0)" ;;
    bt1) show_message "$TITLE" "$(bt_steps 1)" ;;
    bt2) show_message "$TITLE" "$(bt_steps 2)" ;;
    bt3) show_message "$TITLE" "$(bt_steps 3)" ;;
    usb) show_message "$TITLE" "$(usb_steps)" ;;
    clear0) show_message "$TITLE" "$(clear_steps 0)" ;;
    clear1) show_message "$TITLE" "$(clear_steps 1)" ;;
    clear2) show_message "$TITLE" "$(clear_steps 2)" ;;
    clear3) show_message "$TITLE" "$(clear_steps 3)" ;;
    layout) show_message "$TITLE" "$(thumb_map)" ;;
    quit) exit 0 ;;
    *) exit 0 ;;
  esac
done
