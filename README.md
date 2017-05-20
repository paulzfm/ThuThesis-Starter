# ThuThesis
基于 [ThuThesis](https://github.com/xueruini/thuthesis) v5.3.2 并配置好字体的初始模板，
默认设置为本科毕业设计，可从此工程开始撰写论文。同时 Makefile 增加单独编译并预览某一章节的功能，
以解决编译整篇论文耗时过长的问题。

# 配环境

## LaTeX 安装

无论你是何种平台，都建议使用`texlive 2016`。

- Windows：前往 https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/ 下载`texlive.iso`，挂载之后运行脚本`install-tl-windows`，根据 GUI 引导完成安装（建议默认设置安装）。
- Mac：前往 https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/mac/mactex/ 下载`MacTeX.pkg`，运行此安装程序，根据 GUI 引导完成安装（建议默认设置安装）。
- Linux：直接用包管理器安装`texlive 2016`，或者从 https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/ 下载`texlive.iso`，挂载之后运行脚本`./install-tl`。

## 依赖工具安装

依赖工具在 Linux 和 Mac 上一般都预装了，Windows 用户需要检查以下软件是否安装，且在 PATH 中能够找到：

- `make` (http://gnuwin32.sourceforge.net/packages/make.htm)
- `perl` (https://www.activestate.com/activeperl/downloads)
- `cut` (http://gnuwin32.sourceforge.net/packages/coreutils.htm)

未安装的可前往括号内给出的官网地址下载，其中`cut`工具在 Makefile 的扩展功能`data-%`中才会用到，不用此功能的话可以不用安装。

## 中文字体

请确认操作系统有如下4种字体：

1. 宋体 (SimSun)
2. 黑体 (SimHei)
3. 楷体 GB2312 (KaiTi_GB2312)
4. 仿宋 GB2312 (FangSong_GB2312)

没有的话请下载后安装，如果能在 Word 里面找到这些字体的话，安装就没有问题。

字体定义见`ctex-fontset-custom.def`文件。

# Makefile的用法

为了正常编译，请一律调用 Makefile 中的相关命令，直接`xelatex`单个文件很可能出错。

```shell
make [{all|thesis|shuji|doc|data-%|clean|cleanpdf|cleanall|distclean}] \
     [METHOD={latexmk|xelatex|pdflatex}]
```

## 目标
* `make all`       等于 `make thesis && make shuji && make doc`；
* `make cls`       生成模板文件；
* `make thesis`    生成论文 `main.pdf`；
* `make shuji`     生成书脊 `shuji.pdf`；
* `make doc`       生成使用说明书 `thuthesis.pdf`；
* `make data-chap` 生成 `data/` 目录下某个单独章节文件 `chap.tex` 对应的 PDF，叫做 `temp.pdf`
                   (把 `chap` 换成某具体章节文件的名字，如 `background`, `approach`, etc. )；
* `make clean`     删除示例文件的中间文件（不含 `main.pdf`）；
* `make cleanpdf`  删除示例文件的中间文件和 `main.pdf`；
* `make distclean` 删除示例文件和模板的所有中间文件和 PDF；
* `make cleanall`  删除示例文件和模板的所有中间文件和 PDF 和 .xdv。

## 参数
* **METHOD**：指定生成 pdf 的方式，缺省采用 latexmk。
  * METHOD=latexmk  表示使用 latexmk 的方式生成 pdf（使用 xelatex）。
  * METHOD=xelatex  表示使用 xelatex 引擎编译生成 pdf；
  * METHOD=pdflatex 表示使用 pdflatex 引擎编译生成 pdf。

# 使用方法

- 自定义的命令和要导入的额外包请定义在`custom.sty`里，这样无论单独编译一个章节还是全部编译都用同一套配置
- 论文每一章在`data/`目录下单独创建一个文件编写，然后在`main.tex`的`\mainmatter`之后依次`\include{...}`进来，
附录也类似
- 将`ref/refs.bib`修改为自己的参考文献
- 将`data/`目录下的`ack.tex`、`cover.tex`、`denotation.tex`、`resume.tex` 按需求修改为自己的内容

# 常见问题

1. 一篇引用都没有的时候，请注释掉`main.tex`的61、62行，否则可能编译出错。
2. 强行修改字体的命令如下

| 命令 | 含义 |
| :-- | :-- |
| `{\songti ...}` | 将...部分设置为宋体|
| `{\heiti ...}` | 将...部分设置为黑体 |
| `{\fangsong ...}`| 将...部分设置为仿宋 |
| `{\kaishu ...}` | 将...部分设置为楷体 |

3. 其他问题请移步官方 FAQ：https://github.com/xueruini/thuthesis/wiki/FAQ
