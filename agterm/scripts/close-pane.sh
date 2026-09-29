#!/bin/sh
# agterm: make Cmd+W close the focused PANE, falling back to closing the session when
# that pane is the last one — what Cmd+W does over Ghostty's split tree.
#
# agterm ships no "close pane" action, so this reproduces the cascade its own
# close_session runs: dismiss whatever covers the focused pane first, then the pane,
# then the session. The built-in action stays reachable on Cmd+Shift+W.
#
# Bound from keymap.conf, run detached via /bin/sh -c with the app's GUI PATH.

set -u

sid="${AGT_SESSION_ID:-}"
pane="${AGT_PANE:-left}"
sock="${AGT_SOCKET:-}"

[ -n "$sid" ] || exit 0

agt() {
  if [ -n "$sock" ]; then
    agtermctl "$@" --socket "$sock"
  else
    agtermctl "$@"
  fi
}

# Read the session's current shape: is the focused pane under its own overlay, is
# anything covering the whole session, is there a second pane at all.
eval "$(agt tree --json | /usr/bin/python3 -c '
import json, sys

sid, pane = sys.argv[1], sys.argv[2]
node = None
for workspace in json.load(sys.stdin)["result"]["tree"].get("workspaces", []):
    for session in workspace.get("sessions", []):
        if session["id"] == sid:
            node = session
if node is None:
    print("found=0")
    raise SystemExit
print("found=1")
print("pane_overlay=%d" % (pane in node.get("paneOverlays", [])))
print("covered=%d" % bool(node.get("overlay") or node.get("hud")))
print("has_split=%d" % bool(node.get("hasSplit")))
print("scratch=%d" % bool(node.get("scratch")))
' "$sid" "$pane")"

[ "${found:-0}" = 1 ] || exit 0

# The scratch terminal is a pane too: hide it instead of closing the session behind it.
if [ "$pane" = scratch ]; then
  [ "$scratch" = 1 ] && agt session scratch off --target "$sid"
  exit 0
fi

# An overlay or HUD in front of the user goes first, as the built-in Cmd+W does.
if [ "$pane_overlay" = 1 ]; then
  agt session overlay close --target "$sid" --pane "$pane"
  exit 0
fi
if [ "$covered" = 1 ]; then
  agt session overlay close --target "$sid"
  exit 0
fi

# Two panes: drop the focused one and let the other have the session. Only the split
# pane can be torn down, so Cmd+W on the primary swaps the two terminals first
# (positions and roles, neither process restarts) and tears down what is now the split.
if [ "$has_split" = 1 ]; then
  [ "$pane" = right ] || agt session swap --target "$sid"
  agt session split close --target "$sid"
  exit 0
fi

# Last pane standing: an ordinary session close, undo grace period included.
agt session close --target "$sid"
