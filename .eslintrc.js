module.exports = {
  root: true,
  env: {
    browser: true,
    node: true
  },
  plugins: [],
  extends: [
    'eslint:recommended'
  ],
  rules: {
    // override/add rules settings here, such as:
    'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'semi': ['error', 'never'],
    'quotes': ['warn', 'single'],
    "no-multiple-empty-lines": ["error", { "max": 2 }],
    "no-unexpected-multiline": "warn",
    'no-extra-semi': 'error',
    "prefer-const": ["error"],
    "getter-return": ["error"]
  },
  parser: "babel-eslint",
  parserOptions: {
    ecmaVersion: 6,
    sourceType: "module",
  }
}
