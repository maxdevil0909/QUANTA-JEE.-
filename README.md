# QUANTA JEE — starter website

This is an editable, responsive front-end starter for a JEE preparation and mock-test platform.

## Open locally
1. Extract the ZIP.
2. Open `index.html` in Chrome, Edge or Firefox.
3. Demo tests, chapter revision cards and the browser-local admin panel work without a build step.

## Important: demo vs production
This starter is a working front-end prototype, **not yet a secure public membership platform**:
- Login is browser-local demo login, not real email verification.
- Admin actions and question data are stored in that browser's local storage.
- Uploaded payment screenshots are local demo data, not securely stored in a cloud.
- UPI payment is not automatically collected or verified.
- Never deploy this prototype as-is while claiming secure authentication or paid membership.

## Owner account
The starter uses `shekharpaulin0@gmail.com` as the intended owner email in `app.js`. For production, create this email as a Supabase Auth user, then assign the owner/admin role using a protected server-side process. Do not rely on an email string in front-end JavaScript for real admin security.

## Configure real email login and cloud data
1. Create a Supabase project at https://supabase.com/.
2. In Supabase, enable Email authentication.
3. Run `supabase-schema.sql` in the SQL Editor.
4. Configure Row Level Security policies and Storage bucket policies before launch.
5. Add Supabase project URL and anon key to a secure app configuration and replace the demo login/localStorage layer with Supabase Auth + database queries.
6. Deploy the site to Cloudflare Pages or GitHub Pages. Set your own GitHub/Cloudflare account as owner.

## Payments
For a ₹29 membership, use a payment provider with a server-verified webhook (or UPI collection through a provider). Screenshot upload can be an additional manual review route, but a screenshot alone is not proof of payment. Admin should compare UTR/reference against the merchant/bank statement before approving. Never ask students for UPI PIN, OTP, card PIN or banking password.

## Content plan
The initial question set and revision cards are illustrative starter content only. It does not contain 2,000 verified JEE questions or 92 complete quizzes yet. Add licensed/original, fact-checked questions with solutions and diagrams. Use the Admin → Add questions interface for small additions; export JSON for backup. The optional image field in the notes form is a placeholder in this prototype and needs cloud storage integration for real image hosting.

## Suggested production roadmap
- Phase 1: real Supabase authentication, student profiles and admin roles.
- Phase 2: cloud question bank, image storage, topic/chapter taxonomy, bulk CSV/JSON import.
- Phase 3: robust exam engine (question types, marking schemes, timer, review palette, autosave).
- Phase 4: payment provider + verified webhooks + membership entitlements.
- Phase 5: 2,000+ original/authorized questions, detailed explanations, short notes and mind maps.
- Phase 6: analytics, leaderboards, moderation, backups and accessibility testing.

## Content accuracy
JEE Main and Advanced patterns and marking schemes can change. Verify every test against the current official NTA/JEE Advanced information before publishing. Do not describe generated/demo questions as official previous-year questions.
