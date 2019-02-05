# PostCSS Merge Extends [![Build Status][ci-img]][ci]

[PostCSS] plugin that merges SASS extends.

[PostCSS]: https://github.com/postcss/postcss
[ci-img]:  https://travis-ci.org/tomasc/postcss-merge-extends.svg
[ci]:      https://travis-ci.org/tomasc/postcss-merge-extends

```css
.foo {
    /* Input example */
}
```

```css
.foo {
  /* Output example */
}
```

## Usage

```js
postcss([ require('postcss-merge-extends') ])
```

See [PostCSS] docs for examples for your environment.
