#%% import packages -- need pandas,
#       sklearn.datasets, statistics, and plotnine -- NEW
import pandas as pd
from sklearn import datasets
import statistics
from plotnine import *
#%% suppress warnings
import warnings
warnings.filterwarnings('ignore')
#%% load iris data into dataframe -- NEW
iris = datasets.load_iris()
df = pd.DataFrame(iris.data, columns=iris.feature_names)
df['Species'] = pd.Categorical.from_codes(iris.target,iris.target_names)
#%% plot sepal length vs. sepal width using pandas -- default is line plot
df.scatter(x='sepal length (cm)',y='sepal width (cm)', title='My Sepal Length-Width')
#%% pandas scatter plot
df.plot.scatter(x='sepal length (cm)',y='sepal width (cm)', title='My Sepal Length-Width')
#%% plot sepal length against index using pandas
df.plot(y='sepal length (cm)')
#%% ggplot -- scatter plot
# creating window
scatter = ggplot(aes(x='sepal length (cm)',y='sepal width (cm)'),data=df)
scatter
#%% adding data
scatter0 = scatter + geom_point(data=df)
scatter0
#%% adding shapes and colors
scatter1 = scatter + geom_point(aes(color='factor(Species)', shape='factor(Species)'),data=df)
scatter1
#%% adding labels
scatter1 = (scatter1 + xlab("Sepal Length") + ylab("Sepal Width") +
        ggtitle("Sepal Length-Width"))
scatter1
 #%% one-line scatter plot with transparency, labels, mean lines, shapes, size weight, and color weight
scatter = (scatter +
           geom_point(aes(color = 'petal width (cm)', shape='factor(Species)', size='petal length (cm)'), alpha=0.5) +
           geom_vline(aes(xintercept = statistics.mean(df['sepal length (cm)'])), color="red", linetype="dashed") +
           geom_hline(aes(yintercept = statistics.mean(df['sepal width (cm)'])), color="red", linetype="dashed") +
           scale_color_gradient(low="yellow", high="red") +
           xlab("Sepal Length") +  ylab("Sepal Width") +
           ggtitle("Sepal Length-Width"))
scatter
#%% pandas boxplot
df.boxplot(column=['sepal length (cm)'],by="Species")
#%% ggplot boxplot
# window
box = ggplot(aes(x='Species',y='sepal length (cm)'),data=df)
box
#%% add data and aesthetics
box = (box + geom_boxplot(aes(fill='Species')) +
  ylab("Sepal Length") + ggtitle("Iris Boxplot") +
  stat_summary(geom="point", shape=5, size=4))
box
#%% save plot to file
box.save("boxplot.pdf", width=20,height=20,units="cm")
#%% pandas histogram
df.hist(column="sepal width (cm)", bins=12)
#%% ggplot histogram
# window
hist = ggplot(aes(x="sepal width (cm)"),data=df)
hist
#%% add data and aesthetics
hist =(hist + geom_histogram(aes(fill='Species'),binwidth=0.2, color="black") +
  xlab("Sepal Width") +  ylab("Frequency") + ggtitle("Histogram of Sepal Width"))
hist