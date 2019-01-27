# asm_sing
使用汇编语言“唱歌”

## 目录结构说明

```
.
├── a.bat # 编译并运行脚本，使用它可以提高开发效率(`a sing`)
├── convert_music.py # 将乐谱转换为数据段的 pitches 和 durations
├── music # 乐谱（一种自定义的格式，只记录了音长和音调）
│   ├── 卖报歌.txt
│   ├── 故乡的原风景.txt
│   └── 沂蒙山小调.txt
├── README.md # 本文档
├── sing.asm # 主文件，汇编程序源码
└── SING.EXE # 可执行文件

1 directory, 10 files
```

## 乐谱文件格式说明
以卖报歌为例：

```
5,5,5,5,5,5,
3,5,6,5,3,2,3,5,
5,3,5,3,2,1,3,2,
3,3,2,-1,1,2,
6,6,5,3,6,5,
5,3,2,3,5,
5,3,2,3,5,3,2,3,
-1,1,2,3,1,

drt,

e,e,f,e,e,f,
e,e,e,s,s,e,e,f,
e,e,e,s,s,e,e,f,
e,e,f,e,e,f,
f,e,e,e,e,f,
e,e,e,e,t,
e,e,e,e,e,e,e,e,
e,e,e,e,t
```
前面是音调，后面是音长（中间`drt`是 duration 的缩写）。

对于音调，有如下对应关系：

| -6 | -5 | -4 | -3 | -2  | -1 | 0  | 1  | 2  | 3  | 4  | 5   | 6  | 7  | 8  | 9  | 10 | 11 | 12  | 13 | 14 |
|----|----|----|----|-----|----|----|----|----|----|----|-----|----|----|----|----|----|----|-----|----|----|
| Do | Re | Mi | Fa | Sol | La | Si | Do | Re | Mi | Fa | Sol | La | Si | Do | Re | Mi | Fa | Sol | La | Si |

对于音长，有如下对应关系：

| s                   | e               | f              | t             | z            |
|---------------------|-----------------|----------------|---------------|--------------|
| 十六分音符(sixteen) | 八分音符(eight) | 四分音符(four) | 二分音符(two) | 全音符(zero) |

## 使用方法
在 [DOSBox (an x86 emulator with DOS)](https://www.dosbox.com/) 中直接运行即可（`.\SING.EXE`）

或者：
1. 确保 DOSBox 汇编环境配置正确。这一步主要包括安装 DOSBox，下载汇编程序（`masm.exe`和`link.exe`），设置自动执行命令（环境变量（如`PATH`）、挂载磁盘（`mount`））等。可以参考我的另一篇博客 [16位汇编程序设计](https://wsxq2.55555.io/blog/2018/12/02/16位汇编程序设计)
1. 修改要唱的歌。修改`convert_music.py`中的`convert_music`函数的参数（在调用处）。即对于这一行：
   ```python
       convert_music('./music/卖报歌.txt')
   ```
   将`./music/卖报歌.txt`改成`./music/故乡的原风景.txt`

1. 运行`convert_music.py`。用输出内容替换 sing.asm 中`;data start`到`;data end`间的部分
2. 编译并运行。直接执行如下命令即可：

   ```dos
   .\a.bat sing
   ```

3. （可选）运行可执行文件。 如果你想再听一遍，则可以直接运行而非重新编译后运行：
   ```dos
   sing
   ```
   



