[TOC]

# Jupyter Lab 中使用 JavaScript



安装：https://www.dazhuanlan.com/2020/05/27/5ece2f73814c5/

各种语言的 kernel：https://github.com/jupyter/jupyter/wiki/Jupyter-kernels

主题和插件：https://zhuanlan.zhihu.com/p/83252017

````bash
# 首先安装 Jupyter Lab
python3 --version # 确认Python安装成功
pip3 --version # 确认pip3安装成功
pip3 install jupyterlab==3 # 安装成功，但是还没有对js的支持。


# 安装对js的支持
npm i -g ijavascript
ijsinstall


# 进入你项目路径
cd "C:\Users\Humoonruc\OneDrive\ICT\Website\static\notes\Programming-Language\Notes-JavaScript\3-Node.js\303-jupyter-node"
jupyter lab # 即可开启 Jupyter Lab
# 此时就可以在新建中看到 javascript(Node.js) 了。
````

![image-20210514200931385](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210514200931385.png)

```bash
# 安装中文语言包，然后在设置中选择中文
pip install jupyterlab_language_pack_zh_CN-0.0.1.dev0-py2.py3-none-any.whl
```

![image-20210514200837662](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/JavaScript/image-20210514200837662.png)



```bash
jupyter labextension install jupyterlab-toc
```



