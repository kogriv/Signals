//+------------------------------------------------------------------+
//|                                                        Simpo.mq5 |
//|                                Copyright 2022, burattino.finance |
//|                                        https://burattino.finance |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, burattino.finance"
#property link      "https://burattino.finance"
#property version   "1.00"
#include <Signals/CSimp.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   CSimp simpo;
   simpo.ImportSignals();
   simpo.ExportSignals();
   
  }
//+------------------------------------------------------------------+
