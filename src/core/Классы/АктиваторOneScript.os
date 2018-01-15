Перем СистемнаяИнформация;
Перем ЭтоWindows;

Процедура ИспользоватьВерсиюOneScript(Знач ИспользуемаяВерсия, Знач ВыполнятьУстановкуПриНеобходимости = Ложь) Экспорт
	
	ПроверитьНаличиеИспользуемойВерсии(ИспользуемаяВерсия, ВыполнятьУстановкуПриНеобходимости);
	
	КаталогУстановки = ПараметрыOVM.КаталогУстановкиПоУмолчанию();
	КаталогУстановкиВерсии = ОбъединитьПути(КаталогУстановки, ИспользуемаяВерсия);
	
	ПутьКОбщемуКаталогуOneScript = ОбъединитьПути(КаталогУстановки, "current");
	
	СоздатьСимЛинкНаКаталог(ПутьКОбщемуКаталогуOneScript, КаталогУстановкиВерсии);
	ДобавитьКаталогBinВPath(ОбъединитьПути(ПутьКОбщемуКаталогуOneScript, "bin"));
	
КонецПроцедуры

Процедура СоздатьСимЛинкНаКаталог(Знач Ссылка, Знач ПутьНазначения)
	
	Если ЭтоWindows Тогда
		Команда = Новый Команда;
		Команда.УстановитьКоманду("mklink");
		Команда.ДобавитьПараметр("/D");
		Команда.ДобавитьПараметр(Ссылка);
		Команда.ДобавитьПараметр(ПутьНазначения);
		
		Команда.Исполнить();
	Иначе
		
		Если ФС.ФайлСуществует(Ссылка) Тогда
			Команда = Новый Команда;
			Команда.УстановитьКоманду("rm");
			Команда.ДобавитьПараметр(ПутьНазначения);
			
			Команда.Исполнить();
		КонецЕсли;

		Команда = Новый Команда;
		Команда.УстановитьКоманду("ln");
		Команда.ДобавитьПараметр("-s");
		Команда.ДобавитьПараметр(ПутьНазначения);
		Команда.ДобавитьПараметр(Ссылка);
		
		Команда.Исполнить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьКаталогBinВPath(Знач ПутьККаталогуBin)
	
	ПеременнаяPATH = ПолучитьПеременнуюСреды("PATH");
	Если СтрНайти(ПеременнаяPATH, ПутьККаталогуBin) <> 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоWindows Тогда
		УстановитьПеременнуюСреды("PATH", ПеременнаяPATH + ";" + ПутьККаталогуBin, РасположениеПеременнойСреды.Пользователь);
	Иначе
		ТекстФайлаПрофиля = "export PATH=""" + ПутьККаталогуBin + ";$PATH""";
		ПутьКФайлу = ОбъединитьПути(
			СистемнаяИнформация.ПолучитьПутьПапки(СпециальнаяПапка.ПрофильПользователя),
			".profile"
		);
		
		ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлу);
		НайденныйТекстФайлаПрофиля = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		Если СтрНайти(НайденныйТекстФайлаПрофиля, ТекстФайлаПрофиля) <> 0 Тогда
			Возврат;
		КонецЕсли;
		
		ЗаписьТекста = Новый ЗаписьТекста();
		ЗаписьТекста.Открыть(ПутьКФайлу, , , Истина);
		
		ЗаписьТекста.ЗаписатьСтроку(ТекстФайлаПрофиля);
		ЗаписьТекста.Закрыть();
		
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьНаличиеИспользуемойВерсии(Знач ИспользуемаяВерсия, Знач ВыполнятьУстановкуПриНеобходимости)
	
	Если ВерсииOneScript.ВерсияУстановлена(ИспользуемаяВерсия) Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыполнятьУстановкуПриНеобходимости Тогда
		УстановщикOneScript = Новый УстановщикOneScript();
		УстановщикOneScript.УстановитьOneScript(ИспользуемаяВерсия);
	Иначе
		ВызватьИсключение СтрШаблон("Не обнаружена требуемая версия <%1>", ИспользуемаяВерсия);
	КонецЕсли;
	
КонецПроцедуры

СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(ВРег(СистемнаяИнформация.ВерсияОС), "WINDOWS") > 0;
