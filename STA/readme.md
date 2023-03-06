# STA

1. a very simple static timing analyse project, only lack of TARGET_LIB.

2. substitute TARGET_LIB to your porcess "db" in run.sh

3. run run.sh

# Note
check the results in `synth.timing.rpt` file under `results/rpt` directory,
here should be your wanted information

all you need to do is change the correspending script to your project



--------
一个非常简单的静态时序分析项目

把里面 run.sh 的 TARGET_LIB 换成你们的 process 的 db

直接运行 run.sh 就可以跑

关于timing

在生成的 results/rpt 下面会有一个 synth.timing.rpt 看一下是不是你想要的

只要改一改适配你们自己的工程就行了



现在的这个包只要给 TARGET_LIB 就能直接跑
