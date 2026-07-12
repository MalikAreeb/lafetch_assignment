## State Management
[Riverpod — why you chose it, brief mention of your Provider → Riverpod
evolution if relevant, what provider types you used and why
(Provider, NotifierProvider, FutureProvider) and where]

## Key Technical Decisions
[Bullet list — things worth calling out:
- Cart persistence (in-memory, per session, per spec)
- Exception handling approach (typed exceptions, user-friendly messages)
- Category filtering (client-side vs re-fetch, and why)
- Responsive grid (LayoutBuilder-based column count)
- Anything else you made a deliberate call on]

## Getting Started

### Prerequisites
- Flutter SDK 3.12.0
- Docker (for containerized run)

### Run Locally
```bash
flutter pub get
flutter run
```

### Run via Docker
```bash
docker build -t lafetch-assignment .
docker run -p 8080:80 lafetch-assignment
```
Then open `http://localhost:8080`

## Screenshots
[Add PLP, PDP, Cart screenshots here once written]

## Known Limitations / Future Improvements
[Optional — anything you'd do differently with more time,
shows self-awareness, e.g. tests, offline caching, etc.]




