package com.youwin.api.websocket;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class ServerCumstomSocket {

    Map<String, Map> chatHashMap = new HashMap<>();
    public static void main(String[] args) {
        ServerSocket serverSocket = null;
        Socket socket = null;
        BufferedReader in = null;
        BufferedWriter out = null;
        Scanner sc = new Scanner(System.in);

        try {

            // 1. 서버 소켓 생성
            serverSocket = new ServerSocket(9999);

            // 2. 연결 대기 
            System.out.println("연결 대기중...");

            socket = serverSocket.accept();
            System.out.println("연결 되었습니다.");

            // 3. 네트워크 입출력 스트림 생성
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));

            // 4. 클라이언트로부터 데이터 수신 (서버<-클라이언트)
            while(true) {
                String inMsg = in.readLine();
                if(inMsg.equalsIgnoreCase("bye")) {
                    System.out.println("클라이언트가 나갔습니다.");
                    break;
                }

                // 정상 메시지의 경우
                System.out.println("클라이언트 > " + inMsg);

                // 5. 클라이언트로 데이터 전송 (서버->클라이언트)
                System.out.print("보내기 >> ");
                String outMsg = sc.nextLine();
                out.write(outMsg + "\n");
                out.flush();
            }


        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            // 6. 접속 종료
            try {
                sc.close();
                out.close();
                in.close();
                socket.close();
                serverSocket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }
}
