# AXIOM social upgrade (backend milestone)

This upgrade keeps the existing `0001_initial.sql` schema and adds `0002_social.sql` for friend requests and private messages. It also fixes the Cloudflare PBKDF2 limit by using 100,000 iterations.

## Before deploying

1. Keep your existing Cloudflare D1 database `axiom-db`. Do not delete it or rerun/reset the first migration.
2. Add two Worker secrets in Cloudflare: `ADMIN_USERNAME` (your owner account username) and `ADMIN_PASSWORD` (a new, unique password that you have NOT shared in chat). Do not put secrets in GitHub files.
3. Run `npx wrangler d1 migrations apply axiom-db --remote` from this project folder. This applies only the new migration if `0001` is already recorded.
4. Build with `npm install` then `npm run build`.

## API added

- `GET /api/users/search?q=...`
- `GET /api/friends`
- `POST /api/friends/request` with `{ "user_id": "..." }`
- `POST /api/friends/respond` with `{ "id": "...", "action": "accept" | "decline" }`
- `GET /api/dm?user=...`
- `POST /api/dm` with `{ "user_id": "...", "body": "..." }`
- `POST /api/admin/verify` with `{ "username": "...", "password": "..." }`
- `GET /api/admin/overview` requires the logged-in owner account and `X-Admin-Password` header.

Voice/video calling UI and WebRTC signalling still need to be integrated in the frontend; this milestone does not claim those are finished.
