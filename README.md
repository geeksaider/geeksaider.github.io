# MyZoznamka

Personal Vue/Vite website for `geeksaider.online`.

## Local development

```sh
npm ci
npm run dev
```

## GitHub Pages

The workflow in `.github/workflows/pages.yml` builds and deploys `dist` on pushes to `main`. Use a public repository named `geeksaider.github.io` under the `geeksaider` account, select **GitHub Actions** as the Pages source, and set **Custom domain** to `geeksaider.online` in repository Settings → Pages.

At REG.RU, replace any old `A` record for `@` pointing to `95.163.244.138` with four `A` records pointing to `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, and `185.199.111.153`. Replace any `A` record for `www` with a `CNAME` record pointing to `geeksaider.github.io`. Once DNS and the certificate are ready, enable **Enforce HTTPS** in Pages settings.

The site uses root relative asset URLs, so the `geeksaider.github.io` repository name keeps them working on the default and custom domains.
