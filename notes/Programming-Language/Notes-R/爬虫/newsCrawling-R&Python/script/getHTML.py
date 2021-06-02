import requests


def getHTML(url):
    try:
        paraDict = {
            "user-agent": 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Mobile Safari/537.36 Edg/88.0.705.63'}
        response = requests.get(url, headers=paraDict, timeout=30)
        response.raise_for_status()
        print(response.status_code)
        response.encoding = response.apparent_encoding
        return response.text
    except:
        return "Something Error!"
