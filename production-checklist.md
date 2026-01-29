# Production Readiness

What to check before shipping something people pay for.

## Minimum Viable Production

Before first paying customer:

```
□ Env vars (no hardcoded secrets)
□ Error handling (graceful failures)
□ One-click deploy (automated)
□ Works on mobile (if web app)
□ Payment flow tested (real Stripe test mode)
```

That's it for MVP. Everything else can wait.

## Progressive Checklist

### After First Users

```
□ Error tracking (Sentry or similar)
□ Basic logging (know what's happening)
□ Backup strategy (database, uploads)
□ SSL everywhere (should be automatic)
□ Rate limiting (prevent abuse)
```

### After Paying Users

```
□ Monitoring/alerts (know when it's down)
□ Load testing (know your limits)
□ Security audit (auth, permissions, injection)
□ Terms of service
□ Privacy policy
□ Refund policy
```

### Scaling Up

```
□ CDN (static assets, caching)
□ Database indexes (query performance)
□ Connection pooling
□ Background jobs (move slow things async)
□ Redundancy (multi-region if needed)
```

## Security Essentials

### Never Do

- Hardcode secrets
- Store passwords in plain text
- Trust user input without validation
- Expose stack traces to users
- Log sensitive data

### Always Do

```
□ Env vars for secrets
□ HTTPS only
□ Hash passwords (bcrypt, argon2)
□ Validate all inputs
□ Sanitize outputs (XSS)
□ Use parameterized queries (SQL injection)
□ Check permissions on every request
```

### Auth Checklist

```
□ Secure session handling
□ Password requirements
□ Rate limit login attempts
□ Secure password reset flow
□ Logout invalidates session
□ CSRF protection (if cookies)
```

## Environment Setup

### Env Var Pattern

```bash
# .env.example (commit this)
DATABASE_URL=
STRIPE_SECRET_KEY=
NEXT_PUBLIC_STRIPE_KEY=

# .env.local (never commit)
DATABASE_URL=postgres://...
STRIPE_SECRET_KEY=sk_live_...
NEXT_PUBLIC_STRIPE_KEY=pk_live_...
```

### Secret Management

Development: `.env.local` (gitignored)
Production: Platform secrets (Vercel, Railway, etc.)
Sensitive: Consider vault (if truly critical)

### AGENTS.md Note

```markdown
## Secrets
- Never hardcode secrets
- Use process.env.VAR_NAME
- Add new vars to .env.example
- Production secrets in Vercel dashboard
```

## Deployment

### One-Click Deploy

Goal: `git push` → deployed

Vercel/Netlify:
```
Connect repo → automatic deploys on push
```

Railway:
```
Connect repo → automatic deploys on push
```

Docker:
```bash
# Should be this simple
docker build -t app .
docker push registry/app
# Platform pulls and runs
```

### Deploy Checklist

```
□ Build succeeds
□ Tests pass
□ Migrations run
□ Env vars set
□ Health check endpoint works
□ Rollback plan exists
```

### Rollback Plan

Option 1: Revert commit, push
Option 2: Platform rollback (Vercel instant rollback)
Option 3: Database rollback (have migration down scripts)

## Monitoring

### Minimum Monitoring

```
□ Is it up? (uptime check)
□ Is it slow? (response times)
□ Are there errors? (error tracking)
```

Tools: Sentry (errors), Better Stack (uptime), Vercel Analytics (performance)

### Logging Pattern

```typescript
// Good
logger.info('user_created', { userId, email })
logger.error('payment_failed', { userId, error: e.message })

// Bad
console.log('something happened')
console.log(user) // Don't log entire objects
```

### Alerts

Set alerts for:
- Site down > 1 minute
- Error rate spike
- Response time > 5 seconds
- Database connection failures

## Testing for Production

### Critical Path Tests

Identify and test the money path:
```
1. User signs up
2. User adds payment method
3. User makes purchase
4. User receives product/service
5. User can get refund
```

Write automated tests for this flow.

### Manual Smoke Test

Before major releases:
```
□ Sign up flow works
□ Login works
□ Core feature works
□ Payment works (test mode)
□ Logout works
□ Error states show correctly
□ Mobile works
```

## Database Production

### Backup Strategy

```
□ Automated daily backups
□ Tested restore process
□ Backup retention policy
□ Point-in-time recovery (if needed)
```

Most managed databases (Supabase, Neon, PlanetScale) do this automatically.

### Migration Safety

```
□ Test migrations on staging first
□ Migrations are reversible
□ Large migrations done in batches
□ No downtime migrations (if needed)
```

### Connection Management

```typescript
// Good: Connection pooling
const pool = new Pool({ max: 20 })

// Bad: New connection per request
const client = new Client() // Don't do this
```

Use platform connection poolers (Supabase pgbouncer, Neon pooler).

## Performance Basics

### Quick Wins

```
□ Compress responses (gzip/brotli)
□ Cache static assets (CDN)
□ Optimize images (WebP, lazy load)
□ Minimize JavaScript (code split)
□ Database indexes on query columns
```

### When to Optimize

1. Measure first (Lighthouse, profiling)
2. Find the actual bottleneck
3. Fix that specific thing
4. Measure again

Don't guess. Measure.

## Legal Minimum

### For MVP

```
□ Terms of Service
□ Privacy Policy
□ Cookie notice (if using cookies)
□ GDPR compliance (if EU users)
```

Templates: Termly, Iubenda, or lawyer for serious business.

### For Payments

```
□ Clear pricing
□ Refund policy
□ Billing terms
□ Cancel flow works
```

## Launch Checklist

```
□ Domain configured
□ SSL working
□ Error tracking active
□ Monitoring active
□ Backups working
□ Payment flow tested (real mode)
□ Legal pages live
□ Support email set up
□ Analytics installed
□ Manual smoke test passed
```

## Post-Launch

First week:
```
□ Monitor error rates
□ Watch for abuse
□ Respond to user feedback
□ Hot-fix critical issues
```

First month:
```
□ Analyze usage patterns
□ Performance audit
□ Security audit
□ Plan improvements
```
