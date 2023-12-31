//+------------------------------------------------------------------+
//|                                                         Simp.mqh |
//|                                Copyright 2022, burattino.finance |
//|                                        https://burattino.finance |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Class for signal base import                                     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, burattino.finance"
#property link      "https://burattino.finance"
#property version   "1.00"
#include <Object.mqh>
#include<Arrays\List.mqh>

//+------------------------------------------------------------------+
//| Класс импортер                                                   |
//+------------------------------------------------------------------+
class CSimp : public CObject
{
private:
    string filePath; // путь для сохранения данных
    int m_signals_total;
    struct SignalDataInternal
    {
       // Перечисления свойств типа double торговых сигналов:
       // ENUM_SIGNAL_BASE_DOUBLE
       double balance;             // SIGNAL_BASE_BALANCE: Баланс счета
       double equity;              // SIGNAL_BASE_EQUITY: Средства на счете
       double gain;                // SIGNAL_BASE_GAIN: Прирост счета в процентах
       double max_drawdown;        // SIGNAL_BASE_MAX_DRAWDOWN: Максимальная просадка
       double price;               // SIGNAL_BASE_PRICE: Цена подписки на сигнал
       double roi;                 // SIGNAL_BASE_ROI: Значение ROI (Return on Investment) сигнала в %
       
       // Перечисления свойств типа integer торговых сигналов:
       // ENUM_SIGNAL_BASE_INTEGER
       int date_published;         // SIGNAL_BASE_DATE_PUBLISHED: Дата публикации сигнала (когда стал доступен для подписки)
       int date_started;           // SIGNAL_BASE_DATE_STARTED: Дата начала мониторинга сигнала
       int date_updated;           // SIGNAL_BASE_DATE_UPDATED: Дата последнего обновления торговой статистики сигнала
       int id;                     // SIGNAL_BASE_ID: ID сигнала
       int leverage;               // SIGNAL_BASE_LEVERAGE: Плечо торгового счета
       int pips;                   // SIGNAL_BASE_PIPS: Результат торговли в пипсах
       int rating;                 // SIGNAL_BASE_RATING: Позиция в рейтинге сигналов
       int subscribers;            // SIGNAL_BASE_SUBSCRIBERS: Количество подписчиков
       int trades;                 // SIGNAL_BASE_TRADES: Количество трейдов
       int trade_mode;             // SIGNAL_BASE_TRADE_MODE: Тип счета (0-реальный счет, 1-демо-счет, 2-конкурсный счет)
       
       // Перечисления свойств типа string торговых сигналов:
       // ENUM_SIGNAL_BASE_STRING
       string author_login;        // SIGNAL_BASE_AUTHOR_LOGIN: Логин автора сигнала
       string broker;              // SIGNAL_BASE_BROKER: Наименование брокера (компании)
       string broker_server;       // SIGNAL_BASE_BROKER_SERVER: Сервер брокера
       string name;                // SIGNAL_BASE_NAME: Имя сигнала
       string currency;            // SIGNAL_BASE_CURRENCY: Валюта счета сигнала
    };
    
    SignalDataInternal m_signal_data[]; // Массив структур SignalDataInternal
    
public:
    CSimp(int importSource, string Path);
    bool ImportSignals(); // Общая функция импорта
    bool ExportSignals(); // Общая функция экспорта
    bool FillSignalDataInternalArray(); // функция для заполнения массива структур m_signal_data
    // Метод для выгрузки импортированной базы сигналов в файл CSV
    bool ExportSignalDatabaseToCSV(string filePath);
};

//C:/Users/user/AppData/Roaming/MetaQuotes/Terminal/Common/Files/
CSimp::CSimp(int importSource=1,
             string Path="siba.csv")
{
   filePath = Path;
   m_signals_total = SignalBaseTotal();         // общее количество сигналов
   ArrayResize(m_signal_data,m_signals_total);  // массив структур сигналов
}

bool CSimp::ImportSignals()
{
//--- запрашиваем общее количество сигналов в базе   
   Print("Общее количество сигналов в базе: ",m_signals_total);
   Print("Размер массива струкур: ",ArraySize(m_signal_data));
   if(!FillSignalDataInternalArray()){
   Print("Не удалось заполнить массив структур");
   }
   Print("Массив структур заполнен");
   return true;
}

bool CSimp::ExportSignals()
{
   Print("Экспортируем сигналы в количестве: ",
         m_signals_total);
   if(!ExportSignalDatabaseToCSV(filePath)){
   Print("Запись в файл не удалась");
   }
   Print("Запись в файл удалась");
   return true;
}

bool CSimp::FillSignalDataInternalArray()
{
   // Цикл по всем сигналам
   for (int i = 0; i < m_signals_total; i++)
   {
      // Выбираем сигнал для дальнейшей работы
      if (SignalBaseSelect(i))
      {
         // Получение свойств сигнала
         m_signal_data[i].balance         = SignalBaseGetDouble(SIGNAL_BASE_BALANCE);             // Баланс счета
         m_signal_data[i].equity          = SignalBaseGetDouble(SIGNAL_BASE_EQUITY);              // Средства на счете
         m_signal_data[i].gain            = SignalBaseGetDouble(SIGNAL_BASE_GAIN);                // Прирост счета в процентах
         m_signal_data[i].max_drawdown    = SignalBaseGetDouble(SIGNAL_BASE_MAX_DRAWDOWN);        // Максимальная просадка
         m_signal_data[i].price           = SignalBaseGetDouble(SIGNAL_BASE_PRICE);               // Цена подписки на сигнал
         m_signal_data[i].roi             = SignalBaseGetDouble(SIGNAL_BASE_ROI);                 // Значение ROI (Return on Investment) сигнала в %

         m_signal_data[i].date_published  = SignalBaseGetInteger(SIGNAL_BASE_DATE_PUBLISHED);     // Дата публикации сигнала
         m_signal_data[i].date_started    = SignalBaseGetInteger(SIGNAL_BASE_DATE_STARTED);       // Дата начала мониторинга сигнала
         m_signal_data[i].date_updated    = SignalBaseGetInteger(SIGNAL_BASE_DATE_UPDATED);       // Дата последнего обновления торговой статистики сигнала
         m_signal_data[i].id              = SignalBaseGetInteger(SIGNAL_BASE_ID);                 // ID сигнала
         m_signal_data[i].leverage        = SignalBaseGetInteger(SIGNAL_BASE_LEVERAGE);           // Плечо торгового счета
         m_signal_data[i].pips            = SignalBaseGetInteger(SIGNAL_BASE_PIPS);               // Результат торговли в пипсах
         m_signal_data[i].rating          = SignalBaseGetInteger(SIGNAL_BASE_RATING);             // Позиция в рейтинге сигналов
         m_signal_data[i].subscribers     = SignalBaseGetInteger(SIGNAL_BASE_SUBSCRIBERS);        // Количество подписчиков
         m_signal_data[i].trades          = SignalBaseGetInteger(SIGNAL_BASE_TRADES);             // Количество трейдов
         m_signal_data[i].trade_mode      = SignalBaseGetInteger(SIGNAL_BASE_TRADE_MODE);         // Тип счета (0-реальный счет, 1-демо-счет, 2-конкурсный счет)

         m_signal_data[i].author_login    = SignalBaseGetString(SIGNAL_BASE_AUTHOR_LOGIN);        // Логин автора сигнала
         m_signal_data[i].broker          = SignalBaseGetString(SIGNAL_BASE_BROKER);              // Наименование брокера (компании)
         m_signal_data[i].broker_server   = SignalBaseGetString(SIGNAL_BASE_BROKER_SERVER);       // Сервер брокера
         m_signal_data[i].name            = SignalBaseGetString(SIGNAL_BASE_NAME);                // Имя сигнала
         m_signal_data[i].currency        = SignalBaseGetString(SIGNAL_BASE_CURRENCY);            // Валюта счета сигнала
      }
      else
      {
         PrintFormat("Ошибка выбора сигнала. Код ошибки=%d", GetLastError());
         return false;
      }
   }
return true;
}

bool CSimp::ExportSignalDatabaseToCSV(string filePath)
{
    // Открытие файла для записи
    int fileHandle = FileOpen(filePath, FILE_COMMON | FILE_READ | FILE_WRITE|FILE_CSV, ',');

    if (fileHandle == INVALID_HANDLE)
    {
        Print("Ошибка открытия файла ", filePath);
        return false;
    }

    // Запись заголовка CSV файла
    string header = "Balance,Equity,Gain,Max Drawdown,Price,ROI,Date Published,Date Started,Date Updated,ID,Leverage,Pips,Rating,Subscribers,Trades,Trade Mode,Author Login,Broker,Broker Server,Name,Currency";
    FileWriteString(fileHandle, header + "\r\n");

    // Запись данных сигналов из массива m_signal_data в файл CSV
    string dataLine = "";
    for (int i = 0; i < m_signals_total; i++)
    {
      dataLine = DoubleToString(m_signal_data[i].balance) + "," +
                 DoubleToString(m_signal_data[i].equity) + "," +
                 DoubleToString(m_signal_data[i].gain) + "," +
                 DoubleToString(m_signal_data[i].max_drawdown) + "," +
                 DoubleToString(m_signal_data[i].price) + "," +
                 DoubleToString(m_signal_data[i].roi) + "," +
                 IntegerToString(m_signal_data[i].date_published) + "," +
                 IntegerToString(m_signal_data[i].date_started) + "," +
                 IntegerToString(m_signal_data[i].date_updated) + "," +
                 IntegerToString(m_signal_data[i].id) + "," +
                 IntegerToString(m_signal_data[i].leverage) + "," +
                 IntegerToString(m_signal_data[i].pips) + "," +
                 IntegerToString(m_signal_data[i].rating) + "," +
                 IntegerToString(m_signal_data[i].subscribers) + "," +
                 IntegerToString(m_signal_data[i].trades) + "," +
                 IntegerToString(m_signal_data[i].trade_mode) + "," +
                 m_signal_data[i].author_login + "," +
                 m_signal_data[i].broker + "," +
                 m_signal_data[i].broker_server + "," +
                 m_signal_data[i].name + "," +
                 m_signal_data[i].currency;
        FileWriteString(fileHandle, dataLine+"\r\n");
    }

    // Закрытие файла
    FileClose(fileHandle);
    return true;
}