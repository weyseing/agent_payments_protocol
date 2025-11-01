# Setup
- **Obtain a API key from [Google AI Studio](http://aistudio.google.com/apikey)**
- **Copy `.env.example` to `.env` & fill up properties below**
```properties
GOOGLE_API_KEY=
```

# Human-Present Card
- **Run sh script below**
```shell
bash samples/python/scenarios/a2a/human-present/cards/run.sh
```
- **Access to http://localhost:8000/**

# AP2 Package Install
### `Dev` Environment: -
- AP2 Source code in `src/ap2/`
- In `samples/python/pyproject.toml`, it refer to `(/pyproject.toml)`
```properties
dependencies = [
    ...
    "ap2"
]

# refer to local uv workspace
[tool.uv.sources]
ap2 = { workspace = true }
```
- In `(/pyproject.toml)`, it refer to `src/ap2/`
```properties
# point to local src/ap2/
[tool.setuptools.packages.find]
where = ["src"]
```
- **To install**
```bash
cd samples/python
uv sync
uv pip list | grep ap2
```

### `Prod` Environment: -
- Source code from **PyPI** or **GitHub**
- Edit `(/pyproject.toml)`, disable workspace
```properties
# [tool.uv.workspace]
# members = ["samples/python"]
```
- Edit `samples/python/pyproject.toml`, disable workspace
```properties
# [tool.uv.sources]
# ap2 = { workspace = true }
```
- Update ap2 source
```properties
dependencies = [
    ...
    "ap2 @ git+https://github.com/google-agentic-commerce/AP2.git@main"
]
```
- **To install**
```bash
cd samples/python
uv sync
uv pip list | grep ap2
```
