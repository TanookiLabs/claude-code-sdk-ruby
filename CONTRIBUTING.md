# Contributing to Claude Code SDK for Ruby

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## We Develop with GitHub

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## We Use [GitHub Flow](https://guides.github.com/introduction/flow/index.html)

All code changes happen through pull requests. We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Any contributions you make will be under the MIT Software License

In short, when you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project. Feel free to contact the maintainers if that's a concern.

## Report bugs using GitHub's [issues](https://github.com/TanookiLabs/claude-code-sdk-ruby/issues)

We use GitHub issues to track public bugs. Report a bug by [opening a new issue](https://github.com/TanookiLabs/claude-code-sdk-ruby/issues/new); it's that easy!

## Write bug reports with detail, background, and sample code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## Development Process

1. Clone the repository
2. Run `bundle install` to install dependencies
3. Run `bundle exec rake spec` to run tests
4. Make your changes
5. Add tests for your changes
6. Run `bundle exec rubocop` to ensure code style
7. Create a pull request

### Running Tests

```bash
# Run all tests
bundle exec rake spec

# Run with coverage
bundle exec rake coverage

# Run integration tests (requires Claude Code CLI)
bundle exec rake integration

# Run linter
bundle exec rubocop
```

### Code Style

We use RuboCop to maintain consistent code style. Please ensure your code passes RuboCop checks before submitting.

## License

By contributing, you agree that your contributions will be licensed under its MIT License.

## References

This document was adapted from the open-source contribution guidelines for [Facebook's Draft](https://github.com/facebook/draft-js/blob/a9316a723f9e918afde44dea68b5f9f39b7d9b00/CONTRIBUTING.md)