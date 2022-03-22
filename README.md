注意事项：

- Netlify 新建 website 从 GitHub 导入时，注意 Deploy 选项要全部空着，否则会部署失败
- .gitignore 文件中禁止同步二进制文件，如 `*.png`，减少同步负担，某些必须同步的，如 abc.pdf，用`!abc.pdf`注明