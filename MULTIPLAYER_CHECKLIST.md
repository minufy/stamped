# LAN Multiplayer Tetris Checklist

## Gate
- [ ] Confirm this checklist before implementation begins.

## Setup
- [ ] Review current scene, board, player, and input flow before each implementation chunk.
- [ ] Keep netcode isolated under `net/`.
- [ ] Preserve unrelated user changes in the working tree.

## Networking
- [ ] Add `net/protocol.lua` for message constants and table payload encode/decode.
- [ ] Add `net/transport.lua` for UDP socket setup, polling, send, broadcast, and graceful missing-socket errors.
- [ ] Implement host lobby authority for player IDs, names, lobby order, room start, disconnects, seeds, attack routing, and match result.
- [ ] Implement client join flow with host IP, port, name, lobby status, and start handling.
- [ ] Keep board state and movement local to each player; never wait for network confirmation before moving, rotating, holding, dropping, locking, or spawning.

## Menu And Scenes
- [ ] Expand `scenes/menu.lua` with Single Player, Host Multiplayer, Join Multiplayer, input fields, validation errors, and lobby status.
- [ ] Add `scenes/multiplayer.lua` for the LAN match scene.
- [ ] Ensure scene transitions support passing session/options cleanly.

## Board And Battle Gameplay
- [ ] Fix compact board handling by assigning `self.compact` from board options.
- [ ] Add automatic gravity, lock/spawn flow, and game-over detection to shared board behavior.
- [ ] Add board snapshot export/import for grid, active mino, next preview, hold, alive/dead, pending garbage, combo, and back-to-back state.
- [ ] Add garbage queue and insertion with one random hole column.
- [ ] Add attack calculation: single `0`, double `1`, triple `2`, quad `4`.
- [ ] Add T-spin detection where feasible from last rotation and corner occupancy.
- [ ] Add combo and back-to-back attack bonuses.

## Multiplayer Match
- [ ] Treat each player's own machine as authoritative for that player's board simulation and input response.
- [ ] Send board snapshots plus attack/death events after local simulation updates, not remote movement commands.
- [ ] Use received snapshots only to render opponent boards and status, not to drive the local player's controls.
- [ ] Relay remote snapshots through host for compact opponent board rendering.
- [ ] Route attacks to the next alive player in lobby order; receivers queue incoming garbage locally when the attack event arrives.
- [ ] Mark disconnected players dead and continue matches when possible.
- [ ] End the match when one player remains and show winner/defeat state.

## UI Layout
- [ ] Keep local player board full size.
- [ ] Render 2-player opponent board to the side.
- [ ] Render 3-4 player opponent boards with compact mode.
- [ ] Show player name, alive/dead/disconnected status, pending garbage, and final result.
- [ ] Reuse existing assets, font, and background.

## Verification
- [ ] Run single-player and verify existing controls still work with automatic gravity and game-over behavior.
- [ ] Test host and client locally with `127.0.0.1`.
- [ ] Test 3-4 local clients with different names.
- [ ] Verify compact opponent boards, next-alive targeting, disconnect handling, and match end.
- [ ] Verify menu validation for empty name, invalid IP/port, unavailable socket module, and host port bind failure.
