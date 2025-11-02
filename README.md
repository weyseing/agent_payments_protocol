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
- AP2 Source code in **local** `src/ap2/`
- In `samples/python/pyproject.toml`, it refer to **uv workspace**
```properties
dependencies = [
    ...
    "ap2"
]

# refer to local uv workspace
[tool.uv.sources]
ap2 = { workspace = true }
```
- In **root workspace** `(/pyproject.toml)`, it refer to **local source code** `src/ap2/`
```properties
# root workspace = ap2
[project]
name = "ap2"

# point to local (src/ap2/)
[tool.setuptools.packages.find]
where = ["src"]
```
- **To install**
```bash
# install
uv sync --all-packages
# you will see the version follow LOCAL (/pyproject.toml)
uv pip list | grep ap2
# check ap2 path & local code change
uv run python -c "import ap2.types.mandate as m, ap2; print(ap2.__file__, m.__file__, m.CART_MANDATE_DATA_KEY)"
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
# install
cd samples/python
uv sync
# you will see the version follow LOCAL (/pyproject.toml)
uv pip list | grep ap2
# check ap2 path & local code change
uv run python -c "import ap2.types.mandate as m, ap2; print(ap2.__file__, m.__file__, m.CART_MANDATE_DATA_KEY)"
```
