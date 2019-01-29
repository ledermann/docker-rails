module.exports = {
  root: true,
  env: {
    browser: true,
    node: true
  },
  plugins: [],
  extends: [
    'eslint:recommended',
    'airbnb-base',
  ],
  rules: {
    // override/add rules settings here, such as:
    'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'semi': ['error', 'never'],
    "class-methods-use-this": [0],
    'quotes': ['warn', 'single'],
    "no-multiple-empty-lines": ["error", {
      "max": 2
    }],
    "no-unexpected-multiline": "warn",
    'no-extra-semi': 'error',
    "no-underscore-dangle": 0,
    "prefer-const": ["error"],
    "getter-return": ["error"],
    "comma-dangle": ["error", "never"],
    "object-curly-spacing": 2,
    "object-curly-newline": ["error", {
      "ImportDeclaration": {
        "multiline": true,
        "minProperties": 4
      }
    }]
  },
  parser: "babel-eslint",
  parserOptions: {
    ecmaVersion: 6,
    sourceType: "module"
  }
}
