## Code

- Don't add error handling, fallbacks, or validation for scenarios that can't happen. Only validate at system boundaries (user input, external APIs).
- Don't leave compatibility shims, renamed `_vars`, or `// removed` comments for deleted code — delete unused things cleanly.
