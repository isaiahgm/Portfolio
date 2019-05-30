import sys
from operator import add
from pyspark import SparkContext

def wordsFromLine(line):
    return line


def createPairMovie(input):
    inputList = input.split('\t')
    return inputList[1] + "_" + inputList[2], [inputList[0]]


if __name__ == "__main__":
    sc = SparkContext(appName="netflixdata")
    lines = sc.textFile(sys.argv[1], 1)

    user = sys.argv[2]

    result = lines.map(lambda x: createPairMovie(x))\
        .reduceByKey(lambda a, b: a + b)\
        .filter(lambda x: user in x[1])\
        .flatMap(lambda x: x[1])\
        .map(lambda x: (x, 1))\
        .reduceByKey(add)\
        .filter(lambda x: x[0] != user)\
        .sortBy(lambda x: x[1], ascending=False)

    print(result.take(10))
    result.saveAsTextFile(sys.argv[2])
    sc.stop()
