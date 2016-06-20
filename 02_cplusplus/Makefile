CPP_FILE= market.cpp \
agent.cpp\
node.cpp\
netfac.cpp\
netfacderivatives.cpp\
edgederivative.cpp\

OBJ_FILE= market.o \
agent.o\
node.o\
netfac.o\
netfacderivatives.o\
edgederivative.o\

INCLUDE_FILE=market.h \
agent.h\
node.h\
netfac.h\
netfacderivatives.h\
edgederivative.h\

MAIN_SRC=main.cpp 

CC=g++ -g 
#-lgsl -lgslcblas -lm
LIB= -L/usr/local/lib
INCLUDE= -I. -I/usr/local/include -I/usr/include 
#FLAGS= -g -march=i686 -O5 -mcpu=i686
FLAGS= -g -O3

all: main


${OBJ_FILE}:
	${CC} ${FLAGS} ${INCLUDE}-c ${CPP_FILE}

main: ${MAIN_SRC} ${OBJ_FILE}
	${CC} ${FLAGS} -pthread ${INCLUDE} -o run *.o ${MAIN_SRC} ${LIB}


clean:
	rm -f run
	rm -f *.o
