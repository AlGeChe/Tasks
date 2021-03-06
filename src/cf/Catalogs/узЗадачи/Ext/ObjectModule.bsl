﻿
Процедура ПередЗаписью(Отказ)
	Если ДополнительныеСвойства.Свойство("узЭтоОбработка") Тогда
		Возврат;
	Конецесли;
	
	Если НЕ ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата();		
	Конецесли;
	ОсновнаяЗадача = ПолучитьОсновнуюЗадачу(Родитель);
	Если НЕ ЗначениеЗаполнено(Статус) Тогда
		Статус = ПредопределенноеЗначение("Справочник.узСтатусыЗадачи.Зарегистрирована");		
	Конецесли;	
	
	
	пЕстьПодчиненныеЗадачи = ЕстьПодчиненныеЗадачи(Ссылка);	
	Если НЕ ДополнительныеСвойства.Свойство("узЭтоЗаписьРодителя") Тогда
		ЕстьПодчиненныеЗадачи = пЕстьПодчиненныеЗадачи;
	Конецесли;	
	
	Если пЕстьПодчиненныеЗадачи Тогда
		ИзменитьОсновнуюЗадачуДляВсехПодчиненныхЗадач();
	Конецесли;
	
	НовыйРодитель = Родитель;
	Если ЗначениеЗаполнено(НовыйРодитель)
		И НЕ НовыйРодитель.ЕстьПодчиненныеЗадачи Тогда
		НовыйРодительОбъект = НовыйРодитель.ПолучитьОбъект();
		НовыйРодительОбъект.ЕстьПодчиненныеЗадачи = Истина;
		НовыйРодительОбъект.ДополнительныеСвойства.Вставить("узЭтоЗаписьРодителя");
		НовыйРодительОбъект.Записать();
	Конецесли;
	Если НЕ ЭтоНовый() Тогда
		СтарыйРодитель = Ссылка.ПолучитьОбъект().Родитель;
		Если СтарыйРодитель <> НовыйРодитель Тогда
			пЕстьПодчиненныеЗадачи = ЕстьПодчиненныеЗадачи(СтарыйРодитель,Ссылка);
			Если ЗначениеЗаполнено(СтарыйРодитель)
				И пЕстьПодчиненныеЗадачи <> СтарыйРодитель.ЕстьПодчиненныеЗадачи Тогда
				СтарыйРодительОбъект = СтарыйРодитель.ПолучитьОбъект();
				СтарыйРодительОбъект.ЕстьПодчиненныеЗадачи = пЕстьПодчиненныеЗадачи;
				СтарыйРодительОбъект.ДополнительныеСвойства.Вставить("узЭтоЗаписьРодителя");
				СтарыйРодительОбъект.Записать();
			Конецесли;
		Конецесли;
	Конецесли;	
	
	ТекПользователь = Пользователи.ТекущийПользователь();
	ДатаПоследнегоИзменения = ТекущаяДата();
	АвторПоследнегоИзменения = ТекПользователь;

	СтарыйСтатус = Ссылка.Статус;
	
	СтарыйВидСтатуса = СтарыйСтатус.ВидСтатуса;
	НовыйВидСтатуса = Статус.ВидСтатуса;
	ВидСтатуса_Готово = ПредопределенноеЗначение("Справочник.узВидыСтатусов.Готово");
	ВидСтатуса_ВРаботе = ПредопределенноеЗначение("Справочник.узВидыСтатусов.ВРаботе");
	Если НовыйВидСтатуса = ВидСтатуса_Готово
		И СтарыйВидСтатуса <> ВидСтатуса_Готово Тогда
		ДатаВыполнения = ТекущаяДата();
		Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
			Исполнитель = ТекПользователь; 
		Конецесли;		
	Конецесли;
	Если НовыйВидСтатуса = ВидСтатуса_ВРаботе
		И СтарыйВидСтатуса <> ВидСтатуса_ВРаботе Тогда
		Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
			Исполнитель = ТекПользователь; 
		Конецесли;
	Конецесли;
	
	
	Если ФактическиеЧасы.Количество() > 0 Тогда
		ЧасыФакт = ФактическиеЧасы.Итог("ЧасыФакт");
	Конецесли;
	
	СобытияВИстории = ОбновитьИсторию();
	
	ДополнительныеСвойства.Вставить("СобытияВИстории",СобытияВИстории);
	
КонецПроцедуры

Функция ОбновитьИсторию()
	СтарыйИсполнитель = Ссылка.Исполнитель;
	
	СобытияВИстории = Новый Структура();
	СобытияВИстории.Вставить("СтарыйИсполнитель",СтарыйИсполнитель);
	
	ТЗСобытияВИсторииДляУведомлений = Новый ТаблицаЗначений;
	ТЗСобытияВИсторииДляУведомлений.Колонки.Добавить("ВидСобытия",Новый ОписаниеТипов("ПеречислениеСсылка.узВидыСобытий"));
	
	ДатаСобытия = ТекущаяДата();
	пАвтор = Пользователи.ТекущийПользователь();
	
	ПараметрыДляИстории = Новый Структура();
	ПараметрыДляИстории.Вставить("ДатаСобытия",ДатаСобытия);
	ПараметрыДляИстории.Вставить("Автор",пАвтор);
	ПараметрыДляИстории.Вставить("НовыйСтатус",Статус);
	
	Если ЭтоНовый() Тогда
		ВидСобытия = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ДобавленаЗадача");
		Событие = "Добавлена задача";
		
		ПараметрыДляИстории.Вставить("ВидСобытия",ВидСобытия);
		ПараметрыДляИстории.Вставить("Событие",Событие);
		ДобавитьВИсторию(ПараметрыДляИстории,ТЗСобытияВИсторииДляУведомлений);
		
		ДобавитьВИсториюСтатусов();
		СобытияВИстории.Вставить("ТЗСобытияВИсторииДляУведомлений",ТЗСобытияВИсторииДляУведомлений);
		Возврат СобытияВИстории;
	Конецесли;	
	
	
	Если Исполнитель <> СтарыйИсполнитель Тогда
		ВидСобытия = ПредопределенноеЗначение("Перечисление.узВидыСобытий.НовыйИсполнитель");
		Если НЕ ЗначениеЗаполнено(СтарыйИсполнитель) Тогда
			Событие = "Указан исполнитель [" + Исполнитель+"]";
		Иначе
			Событие = "Изменен исполнитель с ["+СтарыйИсполнитель+"] на [" + Исполнитель+"]";
		Конецесли;
		
		ПараметрыДляИстории.Вставить("ВидСобытия",ВидСобытия);
		ПараметрыДляИстории.Вставить("Событие",Событие);
		ДобавитьВИсторию(ПараметрыДляИстории,ТЗСобытияВИсторииДляУведомлений);
		
		ДобавитьВИсториюСтатусов();
	Конецесли;
	
	СтарыйСтатус = Ссылка.Статус;
	Если Статус <> СтарыйСтатус Тогда
		ДобавитьВИсториюСтатусов();
		
		ВидСобытия = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ИзменениеСтатуса");
		Событие = "Изменен статус с ["+СтарыйСтатус+"] на [" + Статус+"]";
		
		ПараметрыДляИстории.Вставить("ВидСобытия",ВидСобытия);
		ПараметрыДляИстории.Вставить("Событие",Событие);
		ДобавитьВИсторию(ПараметрыДляИстории,ТЗСобытияВИсторииДляУведомлений);
	Конецесли;
	
	СтарыеКомментарии = Ссылка.Комментарии;
	Если Комментарии.Количество() <> СтарыеКомментарии.Количество() Тогда
		ВидСобытия = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ДобавленКомментарий");
		Событие = "Добавлен новый комментарий";
		
		ПараметрыДляИстории.Вставить("ВидСобытия",ВидСобытия);
		ПараметрыДляИстории.Вставить("Событие",Событие);
		ДобавитьВИсторию(ПараметрыДляИстории,ТЗСобытияВИсторииДляУведомлений);

	Иначе
		ИзменилисьЛиКомментарии = ПолучитьИзменилисьЛиКомментарии();
		Если ИзменилисьЛиКомментарии Тогда
			ВидСобытия = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ИзмененКомментарий");
			Событие = "Изменили комментарий";
			
			ПараметрыДляИстории.Вставить("ВидСобытия",ВидСобытия);
			ПараметрыДляИстории.Вставить("Событие",Событие);
			ДобавитьВИсторию(ПараметрыДляИстории,ТЗСобытияВИсторииДляУведомлений);

		Конецесли;		
	Конецесли;
	
	
	СтароеНаименование = СокрЛП(Ссылка.Наименование);
	СтароеТекстСодержания = СокрЛП(Ссылка.ТекстСодержания);
	Если СокрЛП(Наименование) <> СтароеНаименование
		ИЛИ СокрЛП(ТекстСодержания) <> СтароеТекстСодержания Тогда
		ВидСобытия = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ИзмененоОписаниеЗадачи");
		Событие = "Изменено описание задачи";
		
		ПараметрыДляИстории.Вставить("ВидСобытия",ВидСобытия);
		ПараметрыДляИстории.Вставить("Событие",Событие);
		ДобавитьВИсторию(ПараметрыДляИстории,ТЗСобытияВИсторииДляУведомлений);
	Конецесли;
	
	История.Сортировать("ДатаСобытия УБЫВ");
	
	СобытияВИстории.Вставить("ТЗСобытияВИсторииДляУведомлений",ТЗСобытияВИсторииДляУведомлений);
	Возврат СобытияВИстории;
	
	
КонецФункции

Функция ПолучитьИзменилисьЛиКомментарии() 
	пИзменилисьЛиКомментарии = Ложь;
	Для каждого СтрокаКомментарииСтарый из Ссылка.Комментарии цикл
		Для каждого СтрокаКомментарииНовый из Комментарии цикл
			Если СокрЛП(СтрокаКомментарииСтарый.Комментарий) <> СокрЛП(СтрокаКомментарииНовый.Комментарий) Тогда
				пИзменилисьЛиКомментарии = Истина;
				Прервать;
			Конецесли;
		Конеццикла;		
	Конеццикла;
	Возврат пИзменилисьЛиКомментарии;
КонецФункции 

Процедура ДобавитьВИсториюСтатусов() Экспорт
	
	ДобавитьНовуюСтроку = Истина;
	ВсегоСтрок = ИсторияСтатусов.Количество();
	Если ВсегоСтрок > 0 Тогда
		ПоследняяСтрокаИсторияСтатусов = ИсторияСтатусов[ВсегоСтрок-1];
		Если ПоследняяСтрокаИсторияСтатусов.Исполнитель = Исполнитель 
			И ПоследняяСтрокаИсторияСтатусов.Статус = Статус Тогда
			ДобавитьНовуюСтроку = Ложь;
		Конецесли;
	Конецесли;
	
	Если НЕ ДобавитьНовуюСтроку Тогда
		Возврат;
	Конецесли;
	
	ПроставитьДатуОкончанияДляСтарогоСтатуса();	
	
	СтрокаИсторияСтатусов = ИсторияСтатусов.Добавить();
	СтрокаИсторияСтатусов.ДатаНачала = ТекущаяДата();
	СтрокаИсторияСтатусов.Исполнитель = Исполнитель;
	СтрокаИсторияСтатусов.Статус = Статус;
КонецПроцедуры 

Процедура ПроставитьДатуОкончанияДляСтарогоСтатуса()
	ВсегоСтрок = ИсторияСтатусов.Количество();
	Если ВсегоСтрок = 0 Тогда
		Возврат;
	Конецесли;
	
	СтрокаИсторияСтатусов = ИсторияСтатусов[ВсегоСтрок-1];
	СтрокаИсторияСтатусов.ДатаОкончания = ТекущаяДата();
КонецПроцедуры 

Процедура ДобавитьВИсторию(ПараметрыДляИстории,ТЗСобытияВИсторииДляУведомлений)
	
	СтрокаИстория = История.Добавить();
	СтрокаИстория.ДатаСобытия = ПараметрыДляИстории.ДатаСобытия;
	СтрокаИстория.Автор = ПараметрыДляИстории.Автор;
	СтрокаИстория.ВидСобытия = ПараметрыДляИстории.ВидСобытия;
	СтрокаИстория.Событие = ПараметрыДляИстории.Событие;
	
	Если ПараметрыДляИстории.НовыйСтатус = ПредопределенноеЗначение("Справочник.узСтатусыЗадачи.Архив") Тогда
		Возврат;
	Конецесли;
	
	СтрокаТЗСобытияВИсторииДляУведомлений = ТЗСобытияВИсторииДляУведомлений.Добавить();
	СтрокаТЗСобытияВИсторииДляУведомлений.ВидСобытия = ПараметрыДляИстории.ВидСобытия;
КонецПроцедуры 

Процедура ОтправитьУведомлениеНаПочту(СобытияВИстории)
	
	НастройкиСобытий = ПолучитьНастройкиСобытий();
	
	ОтправитьУведомлениеНаПочтуИсполнителю(НастройкиСобытий,СобытияВИстории);
	
	ОтправитьУведомлениеНаПочтуСтаромуИсполнителю(НастройкиСобытий,СобытияВИстории);
	
	ОтправитьУведомлениеНаПочтуНаблюдателям(НастройкиСобытий,СобытияВИстории)
КонецПроцедуры 


Функция ПолучитьНастройкиСобытий() 
	РезультатФункции = Новый Структура();
	
	ВидыСобытий_ДобавленаЗадача = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ДобавленаЗадача");
	ВидыСобытий_НовыйИсполнитель = ПредопределенноеЗначение("Перечисление.узВидыСобытий.НовыйИсполнитель");
	ВидыСобытий_ДобавленКомментарий = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ДобавленКомментарий");
	ВидыСобытий_ИзмененКомментарий = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ИзмененКомментарий");
	ВидыСобытий_ИзмененоОписаниеЗадачи = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ИзмененоОписаниеЗадачи");
	ВидыСобытий_ИзменениеСтатуса = ПредопределенноеЗначение("Перечисление.узВидыСобытий.ИзменениеСтатуса");
	
	РезультатФункции.Вставить("ВидыСобытий_ДобавленаЗадача",ВидыСобытий_ДобавленаЗадача);
	РезультатФункции.Вставить("ВидыСобытий_НовыйИсполнитель",ВидыСобытий_НовыйИсполнитель);
	РезультатФункции.Вставить("ВидыСобытий_ДобавленКомментарий",ВидыСобытий_ДобавленКомментарий);
	РезультатФункции.Вставить("ВидыСобытий_ИзмененКомментарий",ВидыСобытий_ИзмененКомментарий);
	РезультатФункции.Вставить("ВидыСобытий_ИзмененоОписаниеЗадачи",ВидыСобытий_ИзмененоОписаниеЗадачи);
	РезультатФункции.Вставить("ВидыСобытий_ИзменениеСтатуса",ВидыСобытий_ИзменениеСтатуса);
	
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки = Новый Массив();
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ИзменениеСтатуса);
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_НовыйИсполнитель);
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ДобавленКомментарий);
	МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ИзмененКомментарий);
	
	РезультатФункции.Вставить("МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки",МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки);
	
	МассивСобытийКоторыеПодлежатОтправки = Новый Массив();
	МассивСобытийКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ДобавленаЗадача);
	МассивСобытийКоторыеПодлежатОтправки.Добавить(ВидыСобытий_НовыйИсполнитель);
	МассивСобытийКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ДобавленКомментарий);
	МассивСобытийКоторыеПодлежатОтправки.Добавить(ВидыСобытий_ИзмененКомментарий);
	
	РезультатФункции.Вставить("МассивСобытийКоторыеПодлежатОтправки",МассивСобытийКоторыеПодлежатОтправки);
	
	МассивСобытийДляСтарогоИсполнителяКоторыеПодлежатОтправки = Новый Массив();
	МассивСобытийДляСтарогоИсполнителяКоторыеПодлежатОтправки.Добавить(ВидыСобытий_НовыйИсполнитель);
	РезультатФункции.Вставить("МассивСобытийДляСтарогоИсполнителяКоторыеПодлежатОтправки",МассивСобытийДляСтарогоИсполнителяКоторыеПодлежатОтправки);
	
	Возврат РезультатФункции;	
КонецФункции 

Процедура ОтправитьУведомлениеНаПочтуИсполнителю(НастройкиСобытий,СобытияВИстории)
	Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
		Возврат;
	Конецесли;
	
	Если Исполнитель.узНеОтправлятьУведомленияНаПочту Тогда
		Возврат;
	Конецесли;
	
	ТекПользователь = Пользователи.ТекущийПользователь(); 
	Если ТекПользователь = Исполнитель Тогда			
		Возврат;
	Конецесли;	
	ТЗСобытияВИсторииДляУведомлений = СобытияВИстории.ТЗСобытияВИсторииДляУведомлений;
	ВсегоСобытий = ТЗСобытияВИсторииДляУведомлений.Количество();
	Если ВсегоСобытий = 0 Тогда
		Возврат;
	Конецесли;
	
	ВТДопПараметры = Новый Структура();
	ВТДопПараметры.Вставить("ЭтоОтправкаИсполнителю",Истина);
	ВТДопПараметры.Вставить("НастройкиСобытий",НастройкиСобытий);
	РезультатФункции = ПолучитьТемаПисьмаСобытие(ВТДопПараметры,СобытияВИстории);
	
	Если НЕ РезультатФункции.НеобходимоОтправитьУведомление Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыПисьма = ПолучитьПараметрыПисьма(РезультатФункции.ТемаПисьмаСобытие);
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ВажностьЗадачи",Важность);
	ДопПараметры.Вставить("ТекстПисьма",ПараметрыПисьма.ТекстПисьма);
	ДопПараметры.Вставить("ТемаПисьма",ПараметрыПисьма.ТемаПисьма);
	ДопПараметры.Вставить("ПользовательКому",Исполнитель);
	узОбщийМодульСервер.ОтправитьПисьмо(ДопПараметры);			
КонецПроцедуры 

Процедура ОтправитьУведомлениеНаПочтуСтаромуИсполнителю(НастройкиСобытий,СобытияВИстории)
	СтарыйИсполнитель = СобытияВИстории.СтарыйИсполнитель;
	
	Если НЕ ЗначениеЗаполнено(СтарыйИсполнитель) Тогда
		Возврат;
	Конецесли;
	
	Если СтарыйИсполнитель.узНеОтправлятьУведомленияНаПочту Тогда
		Возврат;
	Конецесли;
	
	ТекПользователь = Пользователи.ТекущийПользователь(); 
	Если ТекПользователь = СтарыйИсполнитель Тогда			
		Возврат;
	Конецесли;	
	
	Если Исполнитель = СтарыйИсполнитель Тогда
		Возврат;
	КонецЕсли;
	
	ТЗСобытияВИсторииДляУведомлений = СобытияВИстории.ТЗСобытияВИсторииДляУведомлений;
	ВсегоСобытий = ТЗСобытияВИсторииДляУведомлений.Количество();
	Если ВсегоСобытий = 0 Тогда
		Возврат;
	Конецесли;
	
	ВТДопПараметры = Новый Структура();
	ВТДопПараметры.Вставить("ЭтоОтправкаСтаромуИсполнителю",Истина);
	ВТДопПараметры.Вставить("НастройкиСобытий",НастройкиСобытий);
	РезультатФункции = ПолучитьТемаПисьмаСобытие(ВТДопПараметры,СобытияВИстории);		
		
	Если НЕ РезультатФункции.НеобходимоОтправитьУведомление Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыПисьма = ПолучитьПараметрыПисьма(РезультатФункции.ТемаПисьмаСобытие);
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ВажностьЗадачи",Важность);
	ДопПараметры.Вставить("ТекстПисьма",ПараметрыПисьма.ТекстПисьма);
	ДопПараметры.Вставить("ТемаПисьма",ПараметрыПисьма.ТемаПисьма);
	ДопПараметры.Вставить("ПользовательКому",СтарыйИсполнитель);
	узОбщийМодульСервер.ОтправитьПисьмо(ДопПараметры);			

КонецПроцедуры 

Процедура ОтправитьУведомлениеНаПочтуНаблюдателям(НастройкиСобытий,СобытияВИстории)
	ТЗСобытияВИсторииДляУведомлений = СобытияВИстории.ТЗСобытияВИсторииДляУведомлений;
	ВсегоСобытий = ТЗСобытияВИсторииДляУведомлений.Количество();
	Если ВсегоСобытий = 0 Тогда
		Возврат;
	Конецесли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	узНаблюдателиЗаЗадачами.Пользователь
	|ИЗ
	|	РегистрСведений.узНаблюдателиЗаЗадачами КАК узНаблюдателиЗаЗадачами
	|ГДЕ
	|	узНаблюдателиЗаЗадачами.Задача = &Задача
	|	И узНаблюдателиЗаЗадачами.Пользователь.узНеОтправлятьУведомленияНаПочту = ЛОЖЬ
	|	И узНаблюдателиЗаЗадачами.Пользователь <> &ТекущийПользователь
	|	И узНаблюдателиЗаЗадачами.Пользователь <> &Исполнитель";
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	Запрос.УстановитьПараметр("ТекущийПользователь", ТекущийПользователь);
	Запрос.УстановитьПараметр("Исполнитель", Исполнитель);
	Запрос.УстановитьПараметр("Задача", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	Конецесли;
	
	Выборка = РезультатЗапроса.Выбрать();
	МассивПользователейКому = Новый Массив();
	Пока Выборка.Следующий() Цикл
		МассивПользователейКому.Добавить(Выборка.Пользователь);
	КонецЦикла;
		
	ВТДопПараметры = Новый Структура();
	ВТДопПараметры.Вставить("ЭтоОтправкаНаблюдателям",Истина);
	ВТДопПараметры.Вставить("НастройкиСобытий",НастройкиСобытий);
	РезультатФункции = ПолучитьТемаПисьмаСобытие(ВТДопПараметры,СобытияВИстории);	
		
	Если НЕ РезультатФункции.НеобходимоОтправитьУведомление Тогда		
		Возврат;
	КонецЕсли;	
	
	ПараметрыПисьма = ПолучитьПараметрыПисьма(РезультатФункции.ТемаПисьмаСобытие);
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ВажностьЗадачи",Важность);
	ДопПараметры.Вставить("ТекстПисьма",ПараметрыПисьма.ТекстПисьма);
	ДопПараметры.Вставить("ТемаПисьма",ПараметрыПисьма.ТемаПисьма);
	ДопПараметры.Вставить("МассивПользователейКому",МассивПользователейКому);
	узОбщийМодульСервер.ОтправитьПисьмо(ДопПараметры);			
	
КонецПроцедуры 

Функция ПолучитьТемаПисьмаСобытие(ДопПараметры,СобытияВИстории) 
	
	ТЗСобытияВИсторииДляУведомлений = СобытияВИстории.ТЗСобытияВИсторииДляУведомлений;
	РезультатФункции = Новый Структура();
	
	НастройкиСобытий = ДопПараметры.НастройкиСобытий;
	
	ЭтоОтправкаИсполнителю = Ложь;
	Если ДопПараметры.Свойство("ЭтоОтправкаИсполнителю") Тогда
		ЭтоОтправкаИсполнителю = Истина;
		МассивСобытийКоторыеПодлежатОтправки = НастройкиСобытий.МассивСобытийКоторыеПодлежатОтправки; 
	КонецЕсли;
	
	ЭтоОтправкаНаблюдателям = Ложь;
	Если ДопПараметры.Свойство("ЭтоОтправкаНаблюдателям") Тогда
		ЭтоОтправкаНаблюдателям = Истина;
		МассивСобытийКоторыеПодлежатОтправки = НастройкиСобытий.МассивСобытийДляНаблюдателяКоторыеПодлежатОтправки; 
	КонецЕсли;
	
	ЭтоОтправкаСтаромуИсполнителю = Ложь;
	Если ДопПараметры.Свойство("ЭтоОтправкаСтаромуИсполнителю") Тогда
		ЭтоОтправкаНаблюдателям = Истина;
		МассивСобытийКоторыеПодлежатОтправки = НастройкиСобытий.МассивСобытийДляСтарогоИсполнителяКоторыеПодлежатОтправки; 
	КонецЕсли;
	
	НеобходимоОтправитьУведомление = Ложь;	
	ТемаПисьмаСобытие = "";
	
	ВсегоСобытий = ТЗСобытияВИсторииДляУведомлений.Количество();
	Если ВсегоСобытий = 1 Тогда
		СтрокаТЗСобытияВИсторииДляУведомлений = ТЗСобытияВИсторииДляУведомлений[0];
		ВидСобытия = СтрокаТЗСобытияВИсторииДляУведомлений.ВидСобытия;
		Если ВидСобытия = НастройкиСобытий.ВидыСобытий_ДобавленаЗадача Тогда
			Если ЭтоОтправкаИсполнителю Тогда
				НеобходимоОтправитьУведомление = Истина;
				ТемаПисьмаСобытие = "Вам была назначена задача:";			
			КонецЕсли;
		ИначеЕсли ВидСобытия = НастройкиСобытий.ВидыСобытий_НовыйИсполнитель Тогда
			Если ЭтоОтправкаИсполнителю Тогда
				НеобходимоОтправитьУведомление = Истина;
				ТемаПисьмаСобытие = "Вам была назначена задача:";
			КонецЕсли;
			Если ЭтоОтправкаНаблюдателям 
				ИЛИ ЭтоОтправкаСтаромуИсполнителю Тогда
				НеобходимоОтправитьУведомление = Истина;
				ТемаПисьмаСобытие = "Изменился исполнитель у задачи:";
			Конецесли;	
		ИначеЕсли ВидСобытия = НастройкиСобытий.ВидыСобытий_ДобавленКомментарий Тогда
			Если ЭтоОтправкаИсполнителю
				ИЛИ ЭтоОтправкаНаблюдателям Тогда
				НеобходимоОтправитьУведомление = Истина;
				ТемаПисьмаСобытие = "Добален комментарий по задаче:";
			КонецЕсли;
		ИначеЕсли ВидСобытия = НастройкиСобытий.ВидыСобытий_ИзмененКомментарий Тогда
			Если ЭтоОтправкаИсполнителю
				ИЛИ ЭтоОтправкаНаблюдателям Тогда
				НеобходимоОтправитьУведомление = Истина;
				ТемаПисьмаСобытие = "Изменен комментарий по задаче:";			
			КонецЕсли;
		ИначеЕсли ВидСобытия = НастройкиСобытий.ВидыСобытий_ИзменениеСтатуса Тогда
			Если ЭтоОтправкаНаблюдателям Тогда
				НеобходимоОтправитьУведомление = Истина;
				ТемаПисьмаСобытие = "Изменен статус у задачи:";
			Конецесли;
		Конецесли;
	Иначе
		Если ТЗСобытияВИсторииДляУведомлений.Найти(НастройкиСобытий.ВидыСобытий_НовыйИсполнитель,"ВидСобытия") <> Неопределено Тогда
			Если ЭтоОтправкаИсполнителю Тогда
				НеобходимоОтправитьУведомление = Истина;
				ТемаПисьмаСобытие = "Вам была назначена задача: ";				
			КонецЕсли;
			Если ЭтоОтправкаНаблюдателям
				ИЛИ ЭтоОтправкаСтаромуИсполнителю Тогда
				НеобходимоОтправитьУведомление = Истина;
				ТемаПисьмаСобытие = "Изменился исполнитель у задачи:";
			Конецесли;				
		Иначе
			Для каждого СтрокаТЗСобытияВИсторииДляУведомлений из ТЗСобытияВИсторииДляУведомлений цикл
				ВидСобытия = СтрокаТЗСобытияВИсторииДляУведомлений.ВидСобытия;
				Если МассивСобытийКоторыеПодлежатОтправки.Найти(ВидСобытия) <> Неопределено Тогда
					НеобходимоОтправитьУведомление = Истина;
					ТемаПисьмаСобытие = "Изменена задача: ";										
					Прервать;
				Конецесли;
			Конеццикла;	
		Конецесли;
	Конецесли;
	РезультатФункции.Вставить("НеобходимоОтправитьУведомление",НеобходимоОтправитьУведомление);
	РезультатФункции.Вставить("ТемаПисьмаСобытие",ТемаПисьмаСобытие);
	Возврат РезультатФункции;	
КонецФункции 


Функция ПолучитьПараметрыПисьма(ТемаПисьмаСобытие) 
	РезультатФункции = Новый Структура();
	
	НаименованиеЗадачи = СокрЛП(Наименование);
	НомерЗадачи = ""+Код;
	ТемаПисьма = "[#"+НомерЗадачи+"] "+ТемаПисьмаСобытие + НаименованиеЗадачи;		
	ТекстПисьма = "
	|Добрый день.
	|
	|"+ТемаПисьмаСобытие+" "+НаименованиеЗадачи+"
	|Номер задачи: #"+НомерЗадачи+"
	|";
	Если ЗначениеЗаполнено(ТекстСодержания) Тогда
		ТекстПисьма = ТекстПисьма + "
		|
		|Описание задачи: 
		|"+ТекстСодержания+"
		|";			
	Конецесли;	
	
	ТекстПисьма = ТекстПисьма + "
	|
	|Реквизиты задачи:
	|- Исполнитель ["+Исполнитель+"]
	|- Статус ["+Статус+"]
	|- Важность ["+Важность+"]
	|- ОсновнаяЗадача ["+ОсновнаяЗадача+"]
	|";			
	
	РезультатФункции.Вставить("ТемаПисьма",ТемаПисьма);
	РезультатФункции.Вставить("ТекстПисьма",ТекстПисьма);
	
	Возврат РезультатФункции;	
КонецФункции 

Функция ЕстьПодчиненныеЗадачи(Задача,ЗадачаРебенок = Неопределено) Экспорт
	пЕстьПодчиненныеЗадачи = Ложь;
	Если ЭтоНовый() Тогда
		Возврат пЕстьПодчиненныеЗадачи;	
	Конецесли;
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	узЗадачи.Ссылка
	|ИЗ
	|	Справочник.узЗадачи КАК узЗадачи
	|ГДЕ
	|	узЗадачи.Ссылка В ИЕРАРХИИ(&Задача)
	|	И узЗадачи.Ссылка <> &Задача
	|	И узЗадачи.Ссылка <> &ЗадачаРебенок
	|");

	Запрос.УстановитьПараметр("Задача", Задача);
	Запрос.УстановитьПараметр("ЗадачаРебенок", ЗадачаРебенок);

	РезультатЗапроса = Запрос.Выполнить(); 
	Если НЕ РезультатЗапроса.Пустой() Тогда
		пЕстьПодчиненныеЗадачи = Истина;
	Конецесли;
	Возврат пЕстьПодчиненныеЗадачи;
КонецФункции

Функция ПолучитьОсновнуюЗадачу(СсылкаНаОбъект)
	РодителяОбъекта = СсылкаНаОбъект.Родитель;
	Если ЗначениеЗаполнено(РодителяОбъекта) Тогда
		Возврат ПолучитьОсновнуюЗадачу(РодителяОбъекта);
	Иначе
		Возврат СсылкаНаОбъект;			
	Конецесли;	
КонецФункции 

Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ДополнительныеСвойства.Свойство("узЭтоОбработка") Тогда
		Возврат;
	Конецесли;
	
	СобытияВИстории = ДополнительныеСвойства.СобытияВИстории;
	ОтправитьУведомлениеНаПочту(СобытияВИстории);
	ДополнительныеСвойства.Удалить("СобытияВИстории");
КонецПроцедуры

Процедура ИзменитьОсновнуюЗадачуДляВсехПодчиненныхЗадач()
	Если ЭтоНовый() Тогда
		Возврат;	
	Конецесли;
	Если НЕ ЗначениеЗаполнено(ОсновнаяЗадача) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	узЗадачи.Ссылка
	|ИЗ
	|	Справочник.узЗадачи КАК узЗадачи
	|ГДЕ
	|	узЗадачи.Ссылка В ИЕРАРХИИ(&Задача)
	|	И узЗадачи.Ссылка <> &Задача
	|	И узЗадачи.ОсновнаяЗадача <> &ОсновнаяЗадача
	|");

	Запрос.УстановитьПараметр("Задача", Ссылка);
	Запрос.УстановитьПараметр("ОсновнаяЗадача", ОсновнаяЗадача);

	РезультатЗапроса = Запрос.Выполнить(); 
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;	
	Конецесли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();
		#Если Тромбон тогда
			СпрОбъект = Справочники.узЗадачи.СоздатьЭлемент();
		#Конецесли
		
		СпрОбъект.ОсновнаяЗадача = ОсновнаяЗадача;
		СпрОбъект.ДополнительныеСвойства.Вставить("узЭтоОбработка",Истина);
		СпрОбъект.Записать();
	Конеццикла;
КонецПроцедуры 
