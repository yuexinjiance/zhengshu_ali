import requests


# 从远端读取最新的data并返回
def get_new_data():
    response = requests.get('http://sanmao666.pythonanywhere.com/data')
    product_json = response.json()
    # 获取品牌简称的列表
    factory_list = [item['name'] for item in product_json]
    return product_json, factory_list


if __name__ == "__main__":
    print(get_new_data())
