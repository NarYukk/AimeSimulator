import socket
import json
import pyautogui
import tkinter as tk
from threading import Thread

def load_config(filename):
    with open(filename, 'r') as file:
        config = json.load(file)
    return config

def send_enter_key():
    pyautogui.press('enter')

def handle_client(client_socket, address, log_text):
    print(f"クライアント {address[0]}:{address[1]} が接続しました。")
    log_text.insert(tk.END, f"Client {address[0]}:{address[1]} connected.\n")
    log_text.see(tk.END)

    try:
        while True:
            # データを受信
            data = client_socket.recv(1024)
            if not data:
                break
            print("クライアントからのデータ:", data.decode())
            log_text.insert(tk.END, f"Received data from client: {data.decode()}\n")
            log_text.see(tk.END)
            
            # エンターキーのキー操作を送信
            send_enter_key()

    except Exception as e:
        print("エラー:", e)
        log_text.insert(tk.END, f"Error: {e}\n")
        log_text.see(tk.END)
    finally:
        # 接続をクローズ
        client_socket.close()

def main():
    # Configからサーバーホストを読み込む
    config = load_config('config.json')
    host = config.get('server_host', '127.0.0.1')
    port = config.get('server_port', 12345)

    # GUIの設定
    root = tk.Tk()
    root.title("Connection Log")
    log_text = tk.Text(root)
    log_text.pack()

    # ソケットを作成し、指定したホストとポートにバインド
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((host, port))

    # 接続の待機
    server_socket.listen(5)
    print(f"サーバーが {host}:{port} で起動しました。")

    try:
        while True:
            # クライアントからの接続を待ち受け
            client_socket, client_address = server_socket.accept()
            client_thread = Thread(target=handle_client, args=(client_socket, client_address, log_text))
            client_thread.start()

    except Exception as e:
        print("エラー:", e)
    finally:
        server_socket.close()

    root.mainloop()

if __name__ == "__main__":
    main()
