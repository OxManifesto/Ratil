# Ratil

Offline-ready Quran reader/listener built with Flutter.

## Configure PDFs
- Web and native builds load PDFs **only** from the HTTPS URLs in `link/big-quran.txt`; no PDF files are bundled.
- Use a host that allows CORS for GET (Google Drive links typically fail in browsers). Put your direct, public HTTPS links in `link/big-quran.txt` under the `arabic=`, `english=`, and `kurdish=` keys.

## Build for web

### GitHub Pages
```sh
flutter pub get
flutter build web --release --base-href /quran-gitub/
```
Deploy the contents of `build/web` to your `gh-pages` branch (or GitHub Pages docs folder). The included `web/404.html` redirects refreshes back to the SPA entry point.

### Cloudflare Pages
1) Build with a root base href:
```sh
flutter pub get
flutter build web --release
```
2) Deploy `build/web` to Cloudflare Pages. With Wrangler you can run `npx wrangler pages deploy build/web --project-name <project-name>`. In the dashboard, set Framework preset to None, Build command `flutter build web --release`, and Output directory `build/web`.
3) The `web/_redirects` file ships with the build so SPA routes fall back to `index.html`.

If you see WASM dry-run warnings from `pdfx`, add `--no-wasm-dry-run` to the build command to silence them; the JS build still works.

## Notes
- For best results on web, serve over HTTPS so geolocation and downloads work without mixed-content blocks.
