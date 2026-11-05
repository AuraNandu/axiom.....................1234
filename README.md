# AXIOM — Cloudflare Workers + D1

This project keeps the existing D1 database and adds a second, additive migration for friend requests, friendships, direct-message threads, direct messages, admin sessions, and account suspension. Do not delete the database or run a destructive reset.

## Before deploying

1. Keep the existing Cloudflare D1 database `axiom-db` and its database ID in `wrangler.toml`.
2. In Cloudflare Workers & Pages → `axiomchat` → Settings → Variables and Secrets, add these **secrets/variables**:
   - `ADMIN_USERNAME` (text variable): the exact owner username you will register/sign in with (e.g. `AuraNandu`).
   - `ADMIN_SECRET` (secret): choose a new, unique admin password. Do not put it in source code or send it in chat.
3. Confirm the existing `DB` D1 binding and `CHAT_ROOMS` Durable Object binding are present.
4. Apply only the new migration to the existing database:

   ```bash
   npx wrangler d1 migrations apply axiom-db --remote
   ```

   The migration runner should apply `0002_social_features.sql`; it does not drop or recreate existing tables.
5. Install and build:

   ```bash
   npm install
   npm run build
   ```

6. Deploy using the connected GitHub repository or `npm run deploy`.

## Features in this build

- Username/password registration and sign-in (no email required)
- Group channels with WebSocket live message updates
- User search, friend requests, accept/decline, friends list
- Private one-to-one conversations with live message updates
- One-to-one WebRTC voice/video call signaling (requires HTTPS, camera/mic permission, and both users online)
- Separate owner dashboard protected by `ADMIN_USERNAME` + `ADMIN_SECRET`; basic user suspension/restore

## Important limitations

- WebRTC peer calls use a public STUN server and do not include a TURN relay. Some networks/NATs may prevent calls from connecting. Production-quality calling needs a TURN service.
- The call screen is a minimal one-to-one prototype; call invitations, ringing, reconnects, and robust offer-collision handling are not included yet.
- The admin dashboard intentionally does not expose private message contents. Use moderation tools transparently and publish a privacy notice for users.
- The browser client needs HTTPS for microphone/camera access. Cloudflare Workers URLs use HTTPS.

## Existing account/data safety

Never delete `axiom-db`, never remove `0001_initial.sql`, and never run `DROP TABLE` statements. The new migration is additive. Make a D1 backup before production schema changes if the account data is important.
