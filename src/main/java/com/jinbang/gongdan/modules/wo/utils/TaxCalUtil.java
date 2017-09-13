package com.jinbang.gongdan.modules.wo.utils;

import java.math.BigDecimal;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/12/12 15:06
 */
public class TaxCalUtil {

    private static BigDecimal getPercent(String billType){
        BigDecimal per=BigDecimal.ONE;
        if(billType.equals("0")){
            per=new BigDecimal(1.17);
        }else if(billType.equals("1")){
            per=new BigDecimal(1.11);
        }else if(billType.equals("2")){
            per=new BigDecimal(1.06);
        }else if(billType.equals("3")){
            per=new BigDecimal(1.03);
        }else if(billType.equals("4")){
        }else if(billType.equals("5")){
        }
        return per;
    }
    public static BigDecimal calSellM4PO(BigDecimal kaiPiao,String billType){
        if(kaiPiao.compareTo(BigDecimal.ZERO)==0)
            return BigDecimal.ZERO;
        return BigDecimal.ZERO;
    }
}
