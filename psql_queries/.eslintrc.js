module.exports = {
    extends: './node_modules/@latticehr/labuild/eslint',
    parserOptions: {
        tsconfigRootDir: __dirname,
    },
    rules: {
        complexity: 'error',
        'no-unused-vars': 'off',
        '@typescript-eslint/interface-name-prefix': 'off',
        '@typescript-eslint/explicit-function-return-type': 'off',
        '@typescript-eslint/explicit-module-boundary-types': 'off',
        '@typescript-eslint/no-explicit-any': 'off',
        '@typescript-eslint/no-unused-vars': 'off',
        '@typescript-eslint/consistent-type-imports': 'off',
        'local-rules/ensure-nest-graphql-typesafety': 'error',
        'local-rules/no-global-viewer-context': 'error',
        'local-rules/no-string-concatenation-date-constructor': 'error',
    },
    overrides: [
        {
            files: ['./**/__tests__/**/*.test.ts'],
            plugins: ['jest'],
            rules: {
                'local-rules/no-global-viewer-context': 'off',
            },
        },
    ],
}; 