# -*- coding: utf-8 -*-
import requests
import time
import json


def checkError(r):
    response = r.get('response')
    if response != None: 
        return response
    errorArr = r.get('error')
    if errorArr != None:
        errorKode = errorArr.get("error_code")
        errorMsg = errorArr.get("error_msg")
        errorParams = errorArr.get("request_params")
        if errorKode != None:
            print("Код ошибки = ", errorKode)
        if errorMsg != None:
            print("Текст ошибки = ", errorMsg)
        if errorParams != None:
            print("Параметры ошибки = ", errorParams)
        input()
    else:
        print("Не обрабатываемая ошибка = ", r)
        input()
        return None
print("Введите адрес в строку браузера: https://oauth.vk.com/authorize?client_id=6876305&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=wall&v=5.92&response_type=token")
print("Далее вырезайте код из ссылки от access_token= до &expires_in= и вставляйте в консоль:")
token = str(input()).strip() 
print("Теперь Id группы:") 
idGroup = str(input()).strip()
print("Теперь Id опроса:")
idPoll = str(input()).strip()
vApi = "5.92"
try:
    result = requests.get('https://api.vk.com/method/polls.getById?poll_id=' + idPoll + "&owner_id=-" + idGroup + "&access_token=" + token + "&version=" + vApi).json()
    time.sleep(0.3)
except requests.exceptions.ReadTimeout:
    print("Метод - polls.getById, Ошибка - exceptions.ReadTimeout...")
except requests.exceptions.ConnectTimeout:
    print("Метод - polls.getById, Ошибка - exceptions.ConnectTimeout...")
responseGetById = checkError(result)
try:
    print("Всего проголосовавших: ", responseGetById["votes"])
except KeyError:
    print("KeyError - votes, не удалось получить общее количество проголосовавших!")
except:
    print("Не известная ошибка, не удалось получить общее количество проголосовавших!")
try:
    print("Всего голосов: ", len(responseGetById["answers"]))
except KeyError:
    print("KeyError - answers, не удалось получить количество голосов!")
except:
    print("Не известная ошибка, не удалось получить количество голосов!")
for i in responseGetById["answers"]:
    id = i.get("id", "")
    countVotes = i.get("votes", "")
    oldCountVotes = countVotes
    if id == "":
        print("Не известная ошибка, не удалось получить ID голоса...")
        continue
    if countVotes == "":
        print("Не известная ошибка, не удалось получить количество голосов у ID =", id)
        continue
    offsetUser = 0
    while 1:
        try:
            result = requests.get('https://api.vk.com/method/polls.getVoters?count=500&poll_id=' + idPoll + "&offset=" + str(offsetUser) + "&answer_ids=" + str(id) + "&owner_id=" + idGroup + "&access_token=" + token + "&version=" + vApi).json()
            time.sleep(0.3)
        except requests.exceptions.ReadTimeout:
            print("Метод - polls.getVoters, Ошибка - exceptions.ReadTimeout...")
        except requests.exceptions.ConnectTimeout:
            print("Метод - polls.getVoters, Ошибка - exceptions.ConnectTimeout...")
        if result.get("error",{}).get("error_msg","").find("to poll denied") > 0:
            print("Проголосуйте в опросе!, иначе работать не будет, потом нажмите enter...")
            input()
            continue
        responseGetVoters = checkError(result)
        userList = responseGetVoters[0].get("users")
        if len(userList) == 1: 
            break
        offsetUser += 500 
        userList.pop(0)
        userIds = ",".join(map(str, userList))
        try:
            result = requests.get('https://api.vk.com/method/groups.isMember?extended=1&group_id=' + idGroup + "&user_ids=" + userIds + "&access_token=" + token + "&version=" + vApi).json()
            time.sleep(0.3)
        except requests.exceptions.ReadTimeout:
            print("Метод - polls.isMember, Ошибка - exceptions.ReadTimeout...")
        except requests.exceptions.ConnectTimeout:
            print("Метод - polls.isMember, Ошибка - exceptions.ConnectTimeout...")
        responseIsMember = checkError(result)
        for i2 in responseIsMember:
            member = i2.get("member", "")
            user_id = i2.get("user_id", "")
            if user_id == "":
                print("Не известная ошибка, не удалось получить user_id")
                continue
            if member == "":
                print("Не известная ошибка, не удалось получить member, user_id = ", user_id)
                continue
            if member == 0:
                countVotes -= 1
    print("id голоса = ", id, ", голосов = ", oldCountVotes, ", остаток = ", countVotes, ", % = ", (oldCountVotes - countVotes)/(oldCountVotes/100))
print("Нажмите enter, чтобы завершить работу программы.")
input()
