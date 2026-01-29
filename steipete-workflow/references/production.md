# Production Checklist

## MVP (Before First Customer)

```
□ Env vars (no hardcoded secrets)
□ Error handling (graceful failures)
□ One-click deploy
□ Payment flow tested (Stripe test mode)
□ Works on mobile
```

## After First Users

```
□ Error tracking (Sentry)
□ Uptime monitoring
□ Database backups
□ Rate limiting
```

## Security Essentials

**Never:**
- Hardcode secrets
- Store plain passwords
- Trust user input
- Expose stack traces
- Log sensitive data

**Always:**
```
□ HTTPS only
□ Hash passwords (bcrypt/argon2)
□ Validate inputs
□ Parameterized queries
□ Check permissions per request
```

## Deploy Pattern

```bash
# Should be this simple
git push  # → auto deploys
```

Vercel/Railway/Netlify handle the rest.

## Database

```
□ Automated backups (most managed DBs do this)
□ Migrations tested on staging first
□ Indexes on query columns
□ Connection pooling
```

## Monitoring

Minimum:
```
□ Is it up? (uptime check)
□ Error spike? (Sentry)
□ Is it slow? (response times)
```

## Legal Minimum

```
□ Terms of Service
□ Privacy Policy
□ Refund policy (if payments)
```

## Launch Day

```
□ SSL working
□ Error tracking active
□ Backups working
□ Payment tested (live mode)
□ Manual smoke test passed
```
