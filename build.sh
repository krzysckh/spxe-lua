#!/bin/sh

set -xe

wget https://raw.githubusercontent.com/LogicEu/spxe/main/spxe.h -O spxe.h
cc  `pkg-config --cflags --libs glew glfw3` -x c -DSPXE_APPLICATION -fPIC -shared spxe.h -o spxe.so
