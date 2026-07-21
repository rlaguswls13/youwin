package com.youwin.api.websocket;

import java.io.*;
import java.net.Socket;
import java.util.Scanner;

public class ClinetSocket {
    public static void main(String[] args) {

        Socket socket = null;
        BufferedReader in = null;
        BufferedWriter out = null;
        Scanner sc = new Scanner(System.in);

        try {
            // 1. 클라이언트 소켓 생성 및 서버 접속
            Socket clientSocket = new Socket("localhost", 9999);

            // 2. 네트워크 입출력 스트림 생성
            in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
            out = new BufferedWriter(new OutputStreamWriter(clientSocket.getOutputStream()));

            // 3. 서버로 데이터 전송 (클라이언트->서버)
            while(true) {
                System.out.print("보내기 >> ");
                String outMsg = sc.nextLine();

                if(outMsg.equalsIgnoreCase("bye")) {
                    out.write(outMsg + "\n");
                    out.flush();
                    break;
                }

                // 정상 메시지의 경우
                out.write(outMsg + "\n");
                out.flush();

                // 4. 서버로부터 데이터 수신 (서버->클라이언트)
                String inMsg = in.readLine();
                System.out.println("서버 >> " + inMsg);

            }



        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            // 5. 접속 종료
            try {
                sc.close();
                out.close();
                in.close();
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }


        }

    }

}
