#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

# 音长
f = 300  # four, 四分音符，即外部循环使用的延时，默认为 400
t = f*2  # two, 二分音符
z = f*4  # zero, 全音符
e = f/2.0  # eight, 八分音符
s = f/4.0  # sixteen, 十六分音符

# 音调相关
yincheng = 300  # 音程，即将 do，re 间的音程设置为 yincheng，默认为 250
# yinyu = (yincheng*5, yincheng*13)  # 音域，即最低音和最高音，默认为 250,7600
#middleC = (yinyu[1]+yinyu[0])/yincheng/2  # 中央C，即以该音作 do，默认为 10
middleC = 12 # 中央C，即以该音作 do

# 输出格式控制
textwidth = 10  # 即输出时每行显示的数据（音调和音长）个数


def convert_music(sname):
    """

    :sname: TODO
    :returns: TODO

    """
    with open(sname) as f:
        pds = f.read()  # pitches and durations 音调和音长
    # print pds
    del f
    pds = [pd.strip('\n\t ') for pd in pds.split(',')]
    result = 'pitches WORD '
    pds_len = len(pds)
    drt = pds_len

    i = 0
    for pd in pds:
        if pd == 'drt':
            drt = i
            drt_mod = i % textwidth
            break
        i += 1
    if drt*2 != pds_len-1:
        raise RuntimeError('音调和音长的数目不对应')
        return
    i = 0
    while i < drt:
        pd = pds[i]
        pd = '{0:0>4X}H'.format((middleC+1-int(pd))*yincheng)
        #print i
        if i % textwidth == 0 and i != 0:
            result += '\n        WORD '
            result += pd+','
        elif i % textwidth == 9 or i == drt-1:
            result += pd
            #print i==drt-1,drt
        else:
            result += pd+','
        i += 1
    result += '\npitches_len=( $ - pitches)/2\ndurations WORD '
    i = drt+1
    while i < pds_len:
        pd = pds[i]
        pd = '{0:0>4X}H'.format(int(eval(pd)))
        #print eval(pd)
        if i % textwidth == drt_mod+1 and i != drt+1:
            result += '\n          WORD '
            result += pd+','
        elif i % textwidth == drt_mod or i == pds_len-1:
            result += pd
        else:
            result += pd+','
        i += 1
    print result


if __name__ == "__main__":
    #convert_music(sys.argv[1])
    # 修改参数以改变要唱的歌
    convert_music('./music/卖报歌.txt')
