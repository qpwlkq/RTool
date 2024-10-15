library(forestplot)
library(rstudioapi)

script_file_path <- rstudioapi::getSourceEditorContext()$path
script_dir <- dirname(script_file_path)
setwd(script_dir)

cat("当前执行目录: ", getwd(), "\n")

# 文件路径
data_file_path <- "E:/test/RTool/src/tool/森林图/data.csv"

# 读取当前数据文件, 前三行按顺序分别代表: mean, lower, upper, 四行之后是列数据
data <- read.csv(data_file_path, header = FALSE, fileEncoding = "utf-8")

# 遍历data四行之后, 构造数据矩阵
table_text <- unlist(data[4, ], use.names = FALSE)
cbind(for (i in 5:nrow(data)) {
  c <- unlist(data[i, ], use.names = FALSE)
  print(c)
  table_text <- cbind(table_text, c)
})

print(table_text)

mean <- unlist(data[1, ], use.names = FALSE)
lower <- unlist(data[2, ], use.names = FALSE)
upper <- unlist(data[3, ], use.names = FALSE)


logistic_regression_results <-
  structure(
    list(
      mean = mean,
      lower = lower,
      upper = upper
    ),
    .Names = c("mean", "lower", "upper"),
    row.names = c(NA, length(mean)),
    class = "data.frame"
  )

forest_plot <- forestplot(table_text,
  title = "单因素Logistic回归森林图",
  fn.ci_norm = "fpDrawCircleCI", # 点点的形状, 圆
  boxsize = .1, # 点点的大小, .1 = 0.1
  graph.pos = 4, # 森林图展示在表格的第几列
  vertices = TRUE, # 是否显示置信区间两端的小竖线
  hrzl_lines = list(
    "1" = gpar(lwd = 1, col = "#000044"),
    "2" = gpar(lty = 2),
    "9" = gpar(lwd = 1, columns = seq_len(length(data[, 1]) - 3), col = "#000044")
    # 在第九行数据上方画一条实线, columns() 用于指定第几列画到第几列, lwd 是宽度, lty是线条类型(2:虚线)
  ),
  logistic_regression_results, new_page = TRUE, # mean, lower, upper数据, 不用动
  is.summary = c(TRUE, rep(FALSE, 7)), # 是否是总结数据(其实就是这一行数据是否加粗), 除了第一行是TRUE(加粗), 其他行全是FALSE即可
  clip = c(0.1, 4), # 刻度范围
  xticks = c(0, 1, 2, 3, 4), # x轴刻度
  # xlog = TRUE, # x轴使用指数刻度
  xlab = "OR", # x轴标签
  zero = 1, # x轴的竖线画在那个刻度上
  lwd.xaxis = 2, # x轴线宽度
  col = fpColors(box = "black", line = "black", summary = "black", hrz_lines = "#444444") # 线条颜色
)

print(forest_plot)
