



2SLS 思路如下：
 y=α+βx1+γx2+u，其中 x1 是严格外生的，x2 是内生的，则至少需要 1 个工具变量，z1 为工具变量。
 第一阶段回归：内生变量对工具变量和外生变量
 x2=a+bz1+cx1+e
 第二阶段回归：被解释变量对内生变量的预测值和外生变量
 y=α+βx1+γx2'+v



工具变量法的检验：

- 内生性检验：
  - Cov(x2, u)=0
  - 首先假定内生性进行 2SLS 回归，然后假定不存在内生性进行 OLS 回归，最后使用豪斯曼检验 (Wu-Hausman Test)。
- 相关性检验
  - 不可识别检验：Cov(x2, z1)=0
  - **weak instruments test**：第一阶段回归的 F>10 就能通过
- 外生性检验（过度识别检验）
  - Cov(z1, u)=0
  - Sargan Test



[内生性处理：工具变量法 - 简书 (jianshu.com)](https://www.jianshu.com/p/f6e910409823)

[(37 条消息) 两阶段最小二乘法与 R_泥壶映雪的博客 - CSDN 博客_最小二乘法中的 r 是什么](https://blog.csdn.net/weixin_46649908/article/details/118123063)

http://bkenkel.com/psci8357/notes/10-2sls.pdf

[panel data - Two-Stage-Least-Squares (2SLS) Fixed Effects in R - Stack Overflow](https://stackoverflow.com/questions/69917993/two-stage-least-squares-2sls-fixed-effects-in-r)

[ivreg: Two-Stage Least-Squares Regression with Diagnostics • ivreg (john-d-fox.github.io)](https://john-d-fox.github.io/ivreg/articles/ivreg.html)

