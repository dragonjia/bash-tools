##VICUBE升级流程及相关工具

###目的
>规范化、标准化 增量更新流程
>尽可能工具化，减少人的出错

###分析
>发布部署流程(当前）
>>1.人工找到上一次（怎么定义它）的版本是什么？
>>2. 增量文件收集、汇总  。 增量包括什么？ class/ conf/sql ? 
>>3. 实验， 搭建基准版本（生产环境版本），用第2步的增量来升级，部署。
>>4. 验证服务正确性、扫查功能正确性
>>5. 提供给项目组 增量文件和增量部署流程说明

>分析可改进点
>>No.1 : 增量文件整理，靠人，容易出错！
>>No.2 : 部署验证效率，
>>No.3: ?

###Ant build 分析


build.xml

```

```

###auto流程梳理
1. svn diff  urlV1.0  urlV1.2  > diff.txt  
2. svn export  导出增量文件包
3. deploy-patch.sh 提供增量部署脚本
4. 测试验证
>其他考虑:
>>a
>>b




###技术参考

####参考链接
-(http://www.tldp.org/LDP/abs/html/abs-guide.html#DIALOGREF)[aaaa]



####参考技术点
- 模拟windows dialog 界面 （见项目sample目录 dislog）

- linux命令行 菜单选择 (见项目sample目录 menu.sh)