# Playus Arcade

A mobile-first, black-and-electric-green mini-game arcade starter.

## Included
- Responsive welcome screen and 13 selectable mini-games
- Touch-friendly controls and replay flows
- Local nickname and per-game best scores
- Local group-code prototype
- Supabase SQL schema for persistent players, groups, memberships and scores

## Run locally
Open `index.html` in a browser, or serve this folder with any static web server.

## Deploy to GitHub + Vercel
1. Create a GitHub repository and upload the contents of this folder.
2. Import the repository in Vercel. No build command is needed; the output directory is the repository root.
3. Deploy.

## Enable real cross-device friends leaderboard
The included group-code and score UI is currently a local prototype: localStorage only syncs within the same browser/device. To make accounts, groups, invitations and scores truly shared across devices:
1. Create a Supabase project.
2. Run `supabase/schema.sql` in the Supabase SQL editor.
3. Add Supabase URL and anon key to a small client integration, then replace the localStorage methods with authenticated Supabase reads/writes.
4. Enable Row Level Security and review policies before inviting real users.

## Important gameplay fidelity note
The 13 supplied Shorts links are recorded in the project brief, but this build has not verified the actual video contents. The games are playable starter interpretations, not a claim of exact recreation of every Short. The game mechanics should be checked against the videos and tuned where needed.
