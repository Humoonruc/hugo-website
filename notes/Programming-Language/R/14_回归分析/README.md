#### 多层线性模型

[第 56 章 多层线性模型 | 数据科学中的 R 语言 (bookdown.org)](https://bookdown.org/wangminjie/R4DS/tidystats-lmm.html#变化的斜率-变化的截距)：涉及固定效应、混合效应等，样本中的观测可以按一定规则分组，因此截距和系数也要分组来估计。



#### 广义线性模型 `glm()`

被解释变量服从分布的参数的函数，与解释变量为线性关系。

[第 57 章 广义线性模型 | 数据科学中的 R 语言 (bookdown.org)](https://bookdown.org/wangminjie/R4DS/tidystats-poisson-regression.html)：广义线性模型中的 Poisson 回归，被解释变量一般是非负的离散整数，如出现次数等。该模型中，Poisson 分布的参数 $\lambda_i$ 的对数值与自变量为线性关系。

[第 58 章 logistic回归模型 | 数据科学中的 R 语言 (bookdown.org)](https://bookdown.org/wangminjie/R4DS/tidystats-logistic-regression.html)：广义线性模型中的 Logistic 回归，被解释变量一般是二值选择型，如成功/失败。该模型中，$\log(\frac{p_i}{1-p_i})$ 与自变量为线性关系。

![广义回归](http://humoon-image-hosting-service.oss-cn-beijing.aliyuncs.com/img/typora/2022/广义回归.png)

[第 59 章 有序logistic回归 | 数据科学中的 R 语言 (bookdown.org)](https://bookdown.org/wangminjie/R4DS/tidystats-ordinal.html): 多分类 Logistic 回归，被解释变量为类别，且个数大于两个。有序 Logistic 回归，被解释变量为类别，且有序。



