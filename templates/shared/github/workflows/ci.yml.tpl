name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lat-check:
    name: lat.md check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: actions/setup-node@v4
        with:
          node-version: '22'

      - name: Install lat.md
        run: npm install -g lat.md

      - name: Validate knowledge graph
        run: LAT_LLM_KEY=unused lat check

      - name: Check lat.md sync policy
        if: github.event_name == 'pull_request'
        run: bash scripts/check-lat-sync.sh --range origin/${{ github.base_ref }} HEAD

{{CI_PROFILE_JOBS}}
