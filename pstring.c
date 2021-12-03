//
// Created by ben on 18/11/2021.
//
#include "pstring.h"
char pstrlen(Pstring* pstr) {
   return pstr->len;
}

Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar){
    for (int i = 0; i < pstr->len; ++i) {
        if(pstr->str[i] == oldChar) {
            pstr->str[i] = newChar;
        }
    }
    return pstr;
}

Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j) {
    for (int k = i; k < j; ++k) {
        dst->str[k] = src->str[k];
    }
}
