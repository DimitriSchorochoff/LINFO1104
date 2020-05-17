all : main.oza Test.oza
main.oza : main.oz Test.oz Reader.ozf SideFunction.ozf AlterDictionary.ozf
	ozc -c main.oz -o main.oza

Test.oza: Test.oz Reader.ozf SideFunction.ozf AlterDictionary.ozf
	ozc -c Test.oz -o Test.oza

%.ozf : %.oz
	ozc -c $< -o $@

test: Test.oza
	ozengine Test.oza

run : main.oza
	ozengine main.oza


clean :
	rm -f *.oza *.ozf
