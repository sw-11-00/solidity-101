### 为什么选Go

1. 语言简单，开发效率高
2. 高效的垃圾回收机制
3. 支持多返回值
4. 更丰富的内置类型：map、slice、channel、interface
5. 语言层面支持并发编程
6. 编译型语言，编译即测试
7. 跨平台编译



### 能力划分

- 高级
  - 不仅能够熟练掌握Go基础语法，还能使用Go语言高级特性，例如channel、interface、并发编程等
  - 使用面向对象的编程思想开发一个相对复杂的Go项目
- 资深
  - 熟练掌握Go语言编程技能与编程哲学，能够独立编写符合Go编程哲学的复杂项目
  - 对Go语言生态有比较好的理解，具备较好的软件架构能力
- 专家
  - 精通Go语言及其生态，能够独立开发大型、高质量的Go项目，编程过程中较少依赖搜索引擎，且对Go语言编程有自己的理解和方法论
  - 具备优秀的软件架构能力，能够设计、部署一套高可用、可伸缩的Go应用
    - **云原生架构**
  - 把控技术方向、攻克技术难点、解决各种疑难杂症

### 规范

1. **日志规范**

   1. 在需要的地方记录日志
      1. 在分支语句处记录日志
      2. 写操作处打印日志
      3. 在循环中打印日志要慎重
      4. 在错误产生的最原始位置打印日志
   2. 在合适的级别记录日志
      1. Debug
      2. Info
      3. Warn
      4. Error
      5. Panic
      6. Fatal
   3. 合理的记录日志
      1. 不输出敏感信息
      2. 统一日志记录格式
         1. 日志内容大写字母开头
      3. 日志最好包含请求ID、用户、行为
      4. 不要将日志记录在错误的日志级别上
   4. 其他
      1. 支持动态开关Debug日志
      2. 将日志记录在本地文件
      3. 集中化日志存储处理
      4. 结构化日志记录

2. **目录规范**

   ```
   https://github.com/golang-standards/project-layout/blob/master/README_zh.md
   ```

   - 命名清晰
   - 功能明确
   - 全面性
   - 可扩展性

3. **错误规范**

   1. 期望功能：
      1. 有业务code码标识
      2. 对内对外展示不同的错误信息

4. **版本规范**

   ```
   语义化版本规范(SemVer)
   
   1. 在实际开发中，建议使用0.1.0作为第一个开发版本号，并在后续的每次发行时递增次版本号
   2. 当我们的版本是一个稳定的版本，并且第一次对外发布时，版本号可以定位1.0.0
   3. 我们严格按照Angular commit message规范提交代码时，版本号可以这么确定：
       1. fix类型的commit可以将修订号 + 1
       2. feat类型的commit可以将次版本号 + 1
       3. 带有BREAKING CHANGE的commit可以将主版本号 + 1
   ```

5. **提交规范**

   1. ```
      AngularJS规范
      <type>(<scope>):<subject>
      ```

6. **文档规范**
   1. 文档种类全
      1. README.md
      2. 用户文档
      3. 开发文档
   2. 文档质量高
      1. 格式规范
      2. 内容专业
      3. 及时更新



## 生命周期

### 开发流程

### 代码管理模式

- GitFlow工作流(非开源项目)
  - master
  - develop
  - feature
  - release
  - hotfix
- Forking工作流(开源项目)
  - pull request模式

### 开发模式

- 敏捷模式
  - 把一个大需求分成多个、可分阶段完成的小迭代，每个迭代交付的都是一个可用的软件。在开发过程中，软件一直处于可使用的状态
  - 快速迭代，拥抱变化，软件快速更新，上线，适应互联网时代
- DevOps
  - 研发运维一体化
  - 包含CI、CD

### DevOps



## 高质量的Go代码

- 代码结构
  - 目录结构
  - 按功能拆分模块
    - 不同模块，功能单一，可以实现高内聚低耦合的设计哲学
    - 大大减少出现循环引用的概率
- 代码规范
  - 编码规范
  - 最佳实践
- 编程哲学
  - 面向接口编程
    - 接口是衡量代码质量高低的一个核心指标
    - 代码扩展性更强
    - 解耦上下游实现，不用关心具体细节
    - 提高代码的可测性
    - 使代码更健壮、稳定
  - 面向对象编程
- 代码质量
  - 编写可测试的代码
  - 高单元测试覆盖率
    - 借助工具gotests、golang/mock、sqlmock、httpmock、bouk/monkey
    - 加入Makefile，集成进CI流程，设置质量红线
  - Code Review
- 设计模式
  - 设计模式
    - 单例模式
    - 简单工厂模式
    - 抽象工厂模式
    - 工厂方法模式
    - 策略模式
    - 模版模式
    - 代理模式
    - 选项模式
  - 遵循SOLID原则
    - 单一功能原则
      - 一个类或者模块只负责一个职责
    - 开闭原则
      - 对扩展开放，对修改关闭
    - 里氏替换原则
      - 如果S是T的子类型，则类型T的对象可以替换为类型S的对象，而不会破坏程序
    - 依赖倒置原则
      - 依赖于抽象而不是一个实例，其本质是面向接口编程，不要面向实现编程
    - 接口分离原则
      - 客户端程序不应该依赖它不需要的方法



## 项目管理

1. 制定并遵守规范
2. 建立CR机制
3. 对接CI/CD
4. Makefile管理项目
5. 高效的开发流程
6. 善于借助工具
7. 自动生成代码 



```
golangci-lint 静态代码检查工具
swagger 自动生成Go Swagger文档
gotests 根据Go代码自动生成单元测试模版
gsemver 根据git commit规范自动生成语义化版本
golines 格式化Go代码中的长行为短行
git-chglog 根据git commit自动生成CHANGELOG
go-mod-outdated 检查依赖包是否有更新
db2struct 将数据库表一键转换为go struct
rts 用于根据服务器的响应生成Go结构体
goimports 自动格式化Go代码并对所有引入的包进行管理
```
















