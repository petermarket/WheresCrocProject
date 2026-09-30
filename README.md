# WheresCroc Project

Uppsala Assignment 2: Where's Croc

三人小组的 R 语言作业仓库。主函数必须叫 `myFunction`。
当前版本是**可运行的项目骨架**：均匀概率占位 + 随机合法移动后搜索。
HMM、路径规划及性能优化留给小组实现，当前版本不是最终作业答案。

## 文件与分工

| 文件 / 分支 | 负责人 | 工作 |
|---|---|---|
| `hmm.R` / `hmm` | A | 转移模型、forward algorithm、传感器与游客信息、概率归一化 |
| `strategy.R` / `strategy` | B（你） | 最短路径、目标选择、每回合两个动作的搜索策略 |
| `myFunction.R`, `test.R`, `notes/results.md` / `integration-test` | C | 状态管理、整合、测试及结果记录 |
| `main` | 全组 | 经检查后可运行的共同版本 |

## 安装与运行

使用 R 和老师提供的 `WheresCroc_1.2.2.tar.gz`，算法不使用额外第三方包。
课程包已放在 `packages/WheresCroc_1.2.2.tar.gz`，函数命名要求见
`materials/naming-conventions.pdf`，资料说明见 `materials/README.md`。
在仓库根目录运行 R：

```r
dir.create(".Rlib", showWarnings = FALSE)
.libPaths(c(normalizePath(".Rlib"), .libPaths()))
install.packages("packages/WheresCroc_1.2.2.tar.gz", repos = NULL,
                 type = "source", lib = ".Rlib")
source("hmm.R")
source("strategy.R")
source("myFunction.R")
WheresCroc::runWheresCroc(myFunction, doPlot = FALSE, pause = 0)
```

终端快速测试（10 局）及正式规模测试（500 局）：

```sh
R_LIBS_USER=.Rlib Rscript test.R 10 21
R_LIBS_USER=.Rlib Rscript test.R 500 21
```

包文档的 par 均值为 5.444、SD 约 3.853（500 局，seed 21）；
目标是在评分机器上 30 秒内完成。`testWC` 自带默认时间限制是 300 秒，
本项目显式设为 30 秒。评分会换 seed，不能只针对 21 调优。

## 已核对的函数接口

```r
myFunction <- function(moveInfo, readings, positions, edges, probs)
```

- 返回更新后的 `moveInfo`，其中 `moves` 必须恰好包含两个动作。
- `0` 表示搜索当前位置；正数表示移动到相邻水坑或停留在当前水坑。
  Croc 在两次动作之间不移动，只有回合之间移动。
- `readings` 是盐度、磷酸盐、氮含量；`probs` 是对应的三个均值/标准差矩阵。
- `positions[1:2]` 是游客：正数表示存活位置、负数表示本回合被吃的位置、
  `NA` 表示之前已被吃；`positions[3]` 是 ranger 位置。
- `edges` 为双向边，每条只列一次。
- `mem$status` 为 0（首次初始化）或 1（上一局结束）时重置逐局状态；
  本控制器随后设为 2。跨局可以缓存图及路径，但 `probs` 每局重新生成。
- `updateProbabilities` 输出归一化概率向量；`chooseMoves` 输出
  `list(moves = ..., searched = ...)`。若下一回合仍被调用，上回合搜索都失败，
  应先排除搜索过的位置，再预测 Croc 移动。新游戏的第一回合不做移动预测。

## 三人协作

小组已确认使用 **Public** 仓库，代码和已上传课程资料均公开可见。
仓库所有者在 GitHub Settings → Collaborators
邀请另两位同学（需要他们的 GitHub 用户名）。不要提交凭据或个人信息。课程资料的版权仍属于原作者。

```sh
git clone https://github.com/petermarket/WheresCrocProject.git
cd WheresCrocProject
git switch strategy   # A 改为 hmm；C 改为 integration-test
git pull --ff-only
# 修改自己负责的文件
git add strategy.R
git commit -m "Implement routing strategy"
git push -u origin strategy
```

在 GitHub 提交 Pull Request 到 `main`，由另一位成员检查，C 运行测试后合并。
更新个人分支时先 `git fetch origin`，再 `git merge origin/main`。
涉及模块接口的修改先在小组内约定，避免直接修改他人的文件。分支保护未自动配置。

## 最终单文件提交

开发时按三个文件拆分；最终合并为独立 R script，不能依赖本地 `source()` 路径。
在仓库根目录运行：

```r
dir.create("dist", showWarnings = FALSE)
files <- c("hmm.R", "strategy.R", "myFunction.R")
writeLines(unlist(lapply(files, function(f) c(readLines(f), ""))),
           "dist/myFunction.R")
```

提交前在干净 R 会话中仅加载 `dist/myFunction.R`，再运行课程测试。
提交内容与命名以老师要求为准。所有成员需加入课程的 Where's Croc 小组。
