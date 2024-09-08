module.exports = {
  rules: {
    "body-leading-blank": [1, "always"],
    "body-max-line-length": [2, "always", 72],
    "footer-leading-blank": [1, "always"],
    "footer-max-line-length": [2, "always", 72],
    "header-max-length": [2, "always", 72],
    "scope-case": [2, "always", "lower-case"],
    "scope-empty": [1, "never"],
    "scope-enum": [
      1,
      "always",
      [
        "cdn",
        "commitlint",
        "github",
        "org",
        "pr-check",
        "release",
        "tofu",
        "tofu-ci",
        "trunk",
        "vpc",
        "vpc-peer",
      ],
    ],
    //"signed-off-by": [1, "always", "Signed-off-by:"],
    "subject-case": [1, "always", "sentence-case"],
    "subject-empty": [2, "never"],
    "subject-full-stop": [2, "never", "."],
    "type-case": [2, "always", "lower-case"],
    "type-empty": [2, "never"],
    "type-enum": [
      2,
      "always",
      [
        "build",
        "chore",
        "ci",
        "docs",
        "feat",
        "fix",
        "perf",
        "refactor",
        "revert",
        "style",
        "test",
      ],
    ],
  },
};
