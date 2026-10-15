# Release Workshop and SDKcraft

1. Create release/<version> from the latest origin/main. Ask for `<version>` if missing.
2. Add release notes for `<version>` to `docs/release-notes/`, covering changes on `main` since each repository's latest signed release tag: Workshop and SDKcraft (`canonical/sdkcraft`). Follow the template in `docs/doc-style-guide.md` and update `docs/release-notes/index.rst`.
3. Set the version in `internal/VERSION` to `<version>`.
4. Commit the release changes, push release/<version> to origin, and open a PR targeting main, titled Release <version>. Include a summary in the PR description.
